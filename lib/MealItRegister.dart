import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_it/Models/Customer.dart';
import 'package:meal_it/Services/FirebaseDBServices.dart';
import 'package:meal_it/view_models/custom_RadioButton1.dart';

enum GenderSelector { male, female }
class MealItRegister  extends StatefulWidget {
  const MealItRegister({super.key});

  @override
  _MealItRegister createState() => _MealItRegister();


}

class _MealItRegister extends State<MealItRegister>{
  //Firebase DB Services
  final FirebaseDBServices _dbServices = FirebaseDBServices();


  // Text editing controller for field and _gender will have value of selected gender from customRadiobutton1
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController rePassword = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  GenderSelector _gender = GenderSelector.male;

  //reg text field label(hint) styles
  //  changes font color
  var regTextFieldLabelStyle = const TextStyle(
      color: Color.fromRGBO(228, 228, 228, 1)
  );

  //reg text field styles
  //  changes font color
  var regTextFieldStyle = const TextStyle(
      color: Colors.white
  );

  //Focus border the will have the color
  var regFocusBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Color.fromRGBO(255, 255, 255, 1)),
    borderRadius: BorderRadius.circular(5),
  );

  var regEnableBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey.shade600, width: 1),
    borderRadius: BorderRadius.circular(5),
  );

  //to set obscureText false for the password field so it won't show the text
  bool _passVisible = true;
  bool _rePassVisible = true;




  @override
  Widget build(BuildContext context) {

    void snackBarMessage(String msg){
      if(msg == null){
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(msg),
        ),
      );
    }


    Future registerUser(BuildContext context) async{
      try{

        if(name.text.trim().isEmpty || email.text.trim().isEmpty || password.text.trim().isEmpty || rePassword.text.trim().isEmpty|| phoneNumber.text.trim().isEmpty){
          snackBarMessage("please fill the field");
          return;
        }


        Customer customer = Customer();
        customer.email = email.text.trim();
        if(password.text.trim() != rePassword.text.trim()){
          snackBarMessage("Password dose not match");
          return;
        }
        customer.password = password.text.trim();
        customer.phoneNumber = phoneNumber.text.trim();
        customer.name = name.text.trim();
        customer.gender = _gender.name.toString();

        String respond = "";
        await _dbServices.registerCustomer(customer).then((value) => respond = value);

        if("Success"==respond){
          snackBarMessage("you have successfully signup");
        }else{
          snackBarMessage("something went wrong while signup \n please try again");
        }




      } on FirebaseAuthException catch (e){
        print(e);
      }
    }




    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 43, 43, 1),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 70),
                    child: const Text("Signup with Meal IT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(224, 76, 43, 1),
                        fontSize: 30,
                        fontWeight: FontWeight.w900
                      ),
                    ),

                  ),


                  Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 30),

                      child: TextField(
                        style: regTextFieldStyle,
                        controller: name,
                        decoration: InputDecoration(
                            fillColor: Color.fromRGBO(74, 74, 74, 1),
                            filled: true,

                            prefixIcon: Icon(Icons.person_2_outlined,color: Color.fromRGBO(224, 76, 43, 1)),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: 'Name',

                            labelStyle: regTextFieldLabelStyle,
                            enabledBorder: regEnableBorder,
                            focusedBorder: regFocusBorder,

                        ),
                      )
                  ),



                  //Email address
                  Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 14),
                      child: TextField(
                        style: regTextFieldStyle,
                        controller: email,
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(74, 74, 74, 1),
                          filled: true,

                          prefixIcon: Icon(Icons.mail_outline, color: Color.fromRGBO(224, 76, 43, 1),),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Email address',
                          labelStyle: regTextFieldLabelStyle,
                          // hintText: "Email address",
                          enabledBorder: regEnableBorder,
                          focusedBorder: regFocusBorder,
                        ),
                      )
                  ),

                  // phone number
                  Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 14),
                      child: TextField(
                        controller: phoneNumber,
                        style: regTextFieldStyle,
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(74, 74, 74, 1),
                          filled: true,

                          prefixIcon: Icon(Icons.phone_outlined,color: Color.fromRGBO(224, 76, 43, 1),),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Phone number',
                          labelStyle: regTextFieldLabelStyle,
                          enabledBorder: regEnableBorder,
                          focusedBorder: regFocusBorder,
                        ),
                      )
                  ),

                  //password
                  Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 14),
                      child: TextField(
                        style: regTextFieldStyle,
                        obscureText: _passVisible,
                        controller: password,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(74, 74, 74, 1),
                          filled: true,

                          suffixIcon: IconButton(
                            icon: _passVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _passVisible = !_passVisible;
                              });
                            },
                          ),
                          prefixIcon: Icon(Icons.lock_outline,color: Color.fromRGBO(224, 76, 43, 1),),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Password',
                          labelStyle: regTextFieldLabelStyle,
                          enabledBorder: regEnableBorder,
                          focusedBorder: regFocusBorder,


                        ),
                      )
                  ),


                  //retype password

                  Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,top: 14),
                      child: TextField(
                        controller: rePassword,
                        style: regTextFieldStyle,
                        obscureText: _rePassVisible,
                        decoration: InputDecoration(
                          fillColor: Color.fromRGBO(74, 74, 74, 1),
                          filled: true,

                          suffixIcon: IconButton(
                            icon: _rePassVisible ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _rePassVisible = !_rePassVisible;
                              });
                            },
                          ),
                          prefixIcon: Icon(Icons.lock_outline,color: Color.fromRGBO(224, 76, 43, 1),),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Confirm password',
                          labelStyle: regTextFieldLabelStyle,
                          enabledBorder: regEnableBorder,
                          focusedBorder: regFocusBorder,

                        ),
                      )
                  ),

                  // gender select label
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 20,top: 10),
                    child: const Text("Please Select Gender",
                      style: TextStyle(

                          fontSize: 18,
                          color: Color.fromRGBO(228, 228, 228, 1)
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),

                  //radio Male and female
                  Padding(
                      padding: const EdgeInsets.only(left: 25,right: 20,top: 14),
                      child: Row(

                        children: [
                          CustomRadioButton1(
                            icon: Icons.man,
                            isSelected: true,
                            label: "Male",
                            groupValue: _gender,
                            value: GenderSelector.male,
                            iconColor: Color.fromRGBO(224, 76, 43, 1),
                            defaultIconColor: Color.fromRGBO(228, 228, 228, 1),
                            defaultBgColor: Color.fromRGBO(74, 74, 74, 1),
                            onSelect: (value){
                              setState(() {
                                _gender = value;
                              });

                            },


                          ),
                          Padding(padding: EdgeInsets.only(left: 10)),

                          CustomRadioButton1(
                            icon: Icons.woman,
                            label: "Female",
                            groupValue: _gender,
                            iconColor: Color.fromRGBO(224, 76, 43, 1),
                            defaultIconColor: Color.fromRGBO(228, 228, 228, 1),
                            backgroundColor: Color.fromRGBO(228, 228, 228, 1),
                            defaultBgColor: Color.fromRGBO(74, 74, 74, 1),
                            value: GenderSelector.female,
                            onSelect: (value){
                              setState(() {
                                _gender = value;
                              });
                            },


                          ),

                        ],
                      ),

                  ),



                  const SizedBox(height: 40),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(right: 20,left: 20),
                    child: TextButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(224, 76, 43, 1),
                        ),
                      ),

                      onPressed: (){
                        registerUser(context);
                      },
                      child: const Text("Register",
                        style: TextStyle(fontSize: 28,color: Colors.white),
                      ),




                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: 20,left: 20,right: 20),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Text(
                          "Already have account? ",
                          style: TextStyle(
                            fontSize: 22,
                            color: Color.fromRGBO(167, 167, 167, 1)
                          ),

                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("login",
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                ]
            ),
          )
        )

    );


  }




}