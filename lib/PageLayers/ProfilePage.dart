import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:meal_it/Models/BusinessLayer.dart';
import 'package:meal_it/Models/Customer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../view_models/Skeleton.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  final BusinessLayer _businessL = BusinessLayer();
  String customerName="",customerPoints="",customerProfileURL="";
  late Customer customer;
  late File? _profilePic =null;

  Future<void> setCustomerData() async {
    customer = await _businessL.getCustomerData();
    await Future.delayed(const Duration(seconds: 1));
    customerName = customer.name;
    customerPoints = customer.points.toString();
    customerProfileURL = customer.profileImgUrl;

    nameController.text = customer.name;
    emailController.text = customer.email;
    phoneNumberController.text = customer.phoneNumber;

    setState(() {

    });
  }

  Future<void> selectedImage() async {
    if(!kIsWeb){
      PermissionStatus permissionStatus ;

      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          await Permission.storage.request();
          permissionStatus = await Permission.storage.status;
        }  else {
          await Permission.photos.request();
          permissionStatus = await Permission.photos.status;
        }

        if(permissionStatus.isDenied){
          return;
        }
      }


    }


    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Upload the image
      File file = File(pickedFile.path);

      _profilePic=file;
      setState(()  {});
    }

  }

  Future<void> updateProfile() async {
    bool isDataChange=false;
    if(!_formKey.currentState!.validate()){
      return;
    }

    if(customer.email != emailController.text.trim()){
      bool isAvailable = await _businessL.emailsAvailability(emailController.text.trim());
      if(isAvailable){
        customer.email = emailController.text.trim();
        isDataChange=true;
      }else{
        isDataChange=false;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Email is already in use"))
        );

        return;
      }

    }

    if(customer.name != nameController.text.trim()){
      customer.name = nameController.text.trim();
      isDataChange=true;
    }

    if(customer.phoneNumber != phoneNumberController.text.trim()){
      customer.phoneNumber = phoneNumberController.text.trim();
      isDataChange=true;
    }

    if(_profilePic !=null){
      isDataChange=true;
    }


    if(isDataChange){
      String result = await _businessL.updateCustomerData(customer, _profilePic);

      if(result=="Success"){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Updated"))
        );

        Navigator.pop(context);
        setCustomerData();
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Updated failed"))
        );
      }
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCustomerData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20,right: 20,top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: IconButton(
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.only(top: 5,right: 5),
                      icon: Icon(Icons.edit,
                      size: MediaQuery.of(context).size.width*.05,
                      ),
                      onPressed: () {
                        _showProfileBS(context);
                      },
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 16.0),

                      customerProfileURL.isEmpty ?
                      Shimmer.fromColors(
                        enabled: customerProfileURL.isEmpty,
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                          radius: MediaQuery.of(context).size.width*.14,
                        ),
                      ) : CircleAvatar(
                        backgroundImage: Image.network(customerProfileURL).image,
                        radius: MediaQuery.of(context).size.width*.14,
                      ),
                      SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          customerName.isEmpty ?
                          Shimmer.fromColors(
                            enabled: customerName.isEmpty,
                            baseColor: Color.fromRGBO(255, 234, 228, 1),
                            highlightColor: Color.fromRGBO(255, 245, 244, 1.0),
                            child: SkeletonBox(width: MediaQuery.of(context).size.width*.4,height: 18,borderRadius: BorderRadius.circular(40)),
                          ) : Text(
                            customerName,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height*.03
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on_sharp,
                                color: Color.fromRGBO(225, 77, 42, 1),
                                size: MediaQuery.of(context).size.height*.035,
                              ),
                              SizedBox(width: 4.0),

                              customerPoints.isEmpty ? Shimmer.fromColors(

                                enabled: customerPoints.isEmpty,
                                baseColor: Color.fromRGBO(255, 234, 228, 1),
                                highlightColor: Color.fromRGBO(255, 245, 244, 1.0),
                                child: SkeletonBox(width: MediaQuery.of(context).size.width*.2,height: 18,borderRadius: BorderRadius.circular(40)),
                              ) : Text(
                                '${customerPoints} Points',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.width*.05,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 30,right: 30,top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    //order list
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(

                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 4,
                        shadowColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.list_alt,
                            color: Color.fromRGBO(225, 77, 42, 1),
                          ),
                          SizedBox(width: 16.0),
                          Text('Order list',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal
                            ),
                          ),

                          Expanded(
                            child: SizedBox(width: 1,),
                          ),
                          Icon(Icons.east),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    //Save recipes
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 4,
                        shadowColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.bookmark,
                            color: Color.fromRGBO(225, 77, 42, 1),
                          ),
                          SizedBox(width: 16.0),
                          Text('Save Recipes',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal
                            ),
                          ),

                          Expanded(
                            child: SizedBox(width: 1,),
                          ),
                          Icon(Icons.east),
                        ],
                      ),

                    ),
                    SizedBox(height: 16),

                    //Report problem
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 4,
                        shadowColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.report,
                            color: Color.fromRGBO(225, 77, 42, 1),
                          ),
                          SizedBox(width: 16.0),
                          Text('Report Problem',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal
                            ),
                          ),

                          Expanded(
                            child: SizedBox(width: 1,),
                          ),
                          Icon(Icons.east),
                          
                        ],
                      ),

                    ),
                    SizedBox(height: 16),

                    //Change password
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 4,
                        shadowColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Icon(Icons.lock,
                            color: Color.fromRGBO(225, 77, 42, 1),
                          ),
                          SizedBox(width: 16.0),
                          Text('Change Password',
                            style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal
                            ),
                          ),

                          Expanded(
                            child: SizedBox(width: 1,),
                          ),
                          Icon(Icons.east),
                        ],
                      ),

                    ),

                    Expanded(
                        child: SizedBox(height: 1,),
                    ),



                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ElevatedButton(
                        onPressed: () {
                        },

                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Color.fromRGBO(160, 160, 160, 1),
                          foregroundColor: Color.fromRGBO(225, 77, 42, 1),
                          textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: Icon(Icons.power_settings_new)
                              ),
                              Expanded(
                                  child: Text("Logout",
                                    textAlign: TextAlign.center,
                                  ),
                              ),
                              Expanded(
                                  child: SizedBox()
                              ),
                            ],
                          ),

                      ),
                    )


              ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showProfileBS(BuildContext context) {


    showModalBottomSheet(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height*.9
      ),
      isScrollControlled: true,

      enableDrag: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {

        return SingleChildScrollView(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            // height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        selectedImage();
                      },
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: _profilePic==null ? NetworkImage(customer.profileImgUrl): Image.file(_profilePic!).image,
                      ),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if(value==null || value.trim().isEmpty){
                          return "Please enter your name";
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),

                      validator: (value) {
                        if(value== null||value.trim().isEmpty){
                          return "Please enter an valid email address";
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      inputFormatters:[
                        MaskTextInputFormatter(
                            mask: '+94 ## ### ####',
                            filter:{ "#": RegExp(r'\d') },
                            type: MaskAutoCompletionType.lazy

                        )
                      ],

                      validator: (value) {
                        if (value==null || value.trim().isEmpty) {
                          return 'Please enter a Phone number';
                        }

                        if(value.length<15){
                          return 'Please enter a valid Phone number';
                        }

                        return null;
                      },
                    ),


                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                            child: ElevatedButton(
                              onPressed: () {
                                if(!_formKey.currentState!.validate()){
                                  return;
                                }

                                updateProfile();

                              },
                              child: Text(
                                'Update Profile',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFE14D2A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

          ),
        );
      },
    );
  }



}
