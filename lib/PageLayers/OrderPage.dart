import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meal_it/Models/CustomerOrder.dart';
import 'package:meal_it/Models/SaveCustomerDataStatic.dart';

import '../Models/BusinessLayer.dart';
import '../Models/CartModel.dart';
import '../Models/DispatchTimes.dart';
import '../view_models/CartCard.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  BusinessLayer _businessL = BusinessLayer();
  late CartModel cartModel = CartModel();

  late List<DispatchTimes> dispatchTimes = [];
  late DispatchTimes nextDispatch;
  late double standardDeliveryFee=0.0;
  bool isTimeFrameDeliveryEnable = true;

  //Address
  String? addressInString;

  // define the available payment and delivery methods
  final List<String> paymentMethods = [
    'Credit/Debit card',
    'Direct pay',
    'Cash on delivery'
  ];
  final List<String> deliveryMethods = [
    'Standard delivery',

  ];

  Future<void> getCartDetails() async {
    cartModel = await _businessL.getCart();

    setState(() {

    });
  }

  Future<void> getUserAddress() async {
    Position? location = SaveCustomerDataStatic.currentLocation;
    if(location == null){
      return;
    }

    List<Placemark> placemarks = await placemarkFromCoordinates(location!.latitude, location!.longitude);
    Placemark placemark = placemarks[0];
    addressInString = "${placemark.street}, ${placemark.locality}";

    setState(() {

    });
  }

  String getNextFutureTime(List<DispatchTimes> times) {
    final now = TimeOfDay.now();
    DispatchTimes? nextTime;
    int minDiff = 24 * 60; // Initialize to a big number

    for (final time1 in times) {
      var time = time1.finishingTime;
      final diff = time.hour * 60 + time.minute - now.hour * 60 - now.minute;
      if (diff > 0 && diff < minDiff) {
        nextTime = time1;
        minDiff = diff;
      }
    }

    if (nextTime == null) {
      return "Tomorrow";
    } else {
      if (minDiff < 60) {
        return "$minDiff mins";
      } else {
        nextDispatch = nextTime;
        final hours = minDiff ~/ 60;
        final minutes = minDiff % 60;
        return "$hours${hours > 1 ? 'Hrs' : 'Hr'} ${minutes > 0 ? '$minutes mins' : ''}";
      }
    }
  }

  String getHowManyHours(TimeOfDay time){
    final now = TimeOfDay.now();
    final diff = time.hour * 60 + time.minute - now.hour * 60 - now.minute;
    final hours = diff ~/ 60;
    final minutes = diff % 60;
    return "$hours${hours > 1 ? 'Hrs' : 'Hr'} ${minutes > 0 ? '$minutes mins' : ''}";
  }

  Future<void> getDispatchTimes() async {
    dispatchTimes = await _businessL.getAllActiveDispatchTimes();
    setState(() {
    });
  }

  Future<void> getDeliveryFee() async {
    standardDeliveryFee = await _businessL.getCalculateDeliveryPrice(GeoPoint(SaveCustomerDataStatic.currentLocation!.latitude, SaveCustomerDataStatic.currentLocation!.longitude));
    setState(() {

    });
  }




  // define the selected payment and delivery methods
  String selectedPaymentMethod = 'Credit/Debit card';
  String selectedDeliveryMethod = 'Standard delivery';


  Future<void> setOrderingData() async {
    await getCartDetails();
    await getDispatchTimes();

    if(cartModel.colabFoodProduct.isEmpty){
      isTimeFrameDeliveryEnable = true;
      String nextDeliveryIn =getNextFutureTime(dispatchTimes);

      if(nextDeliveryIn!= "Tomorrow"){
        deliveryMethods.add("Time-Framed");
      }
    }else{
      isTimeFrameDeliveryEnable = false;
    }


  }

  void placeOrder(){
    CustomerOrder order = CustomerOrder.empty();

    order.customerName = "Customer details";
    order.customerEmail = "email";
    order.customerNumber = "";
    order.orderItems = cartModel;
    order.address = "test address";
    // order.location = null;
    order.orderPlaceTime = DateTime.now();
    order.status = "Active";

    if(SaveCustomerDataStatic.currentLocation == null){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User location not found"))
      );

      return;
    }


    GeoPoint location = GeoPoint(SaveCustomerDataStatic.currentLocation!.latitude, SaveCustomerDataStatic.currentLocation!.longitude);
    
    _businessL.addOrder(addressInString!, location);
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setOrderingData();
    getUserAddress();
    getDeliveryFee();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Text(
                  'Your Order',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),


              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cartModel.surpriseList.length+cartModel.foodProduct.length+cartModel.colabFoodProduct.length, // replace with the actual number of items
                itemBuilder: (BuildContext context, int index) {
                  // replace with your cart card widget
                  if (index < cartModel.surpriseList.length) {
                    // build cart card for surpriseList[index]
                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.25,
                        motion: BehindMotion(),
                        children: [
                          SlidableAction(onPressed: (context) {

                          },
                            icon: Icons.delete,
                          )
                        ],

                      ),
                      child: CartCard(surprisePack: cartModel.surpriseList[index]),
                    );
                  } else if (index < cartModel.surpriseList.length + cartModel.foodProduct.length) {
                    // build cart card for foodProduct[index - surpriseList.length]
                    return Slidable(
                      endActionPane: ActionPane(
                        extentRatio: 0.25,
                        motion: BehindMotion(),
                        children: [
                          SlidableAction(onPressed: (context) {

                          },
                            icon: Icons.delete,
                          )
                        ],

                      ),
                      child: CartCard(foodProduct: cartModel.foodProduct[index - cartModel.surpriseList.length]),
                    );
                  } else{
                    return CartCard(colabFoodProduct: cartModel.colabFoodProduct[index - cartModel.surpriseList.length - cartModel.foodProduct.length]);
                  }
                },
              ),
              SizedBox(height: 20.0),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Location",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(addressInString ?? "Location not found"!,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),



              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Payment method:',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    SizedBox(width: 16.0),
                    DropdownButton<String>(
                      value: selectedPaymentMethod,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPaymentMethod = newValue!;
                        });
                      },
                      items: paymentMethods
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        'Delivery method:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    SizedBox(width: 16.0),

                  ],
                ),
              ),

              Container(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        value: selectedDeliveryMethod,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDeliveryMethod = newValue!;
                          });
                        },

                        items: deliveryMethods
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(

                            value: value,
                            child: value!="Time-Framed" ? Text(value): Text(value +" In : "+ getHowManyHours(nextDispatch.finishingTime), softWrap: true,maxLines: 2,),
                          );
                        }).toList(),

                      ),
                    ),
                  ],
                ),
              ),


              SizedBox(height: 16.0),


              Container(
                padding: EdgeInsets.symmetric(vertical: 10 ),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Products",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text("Rs : ${cartModel.getTotal()}.00",
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Delivery",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            selectedDeliveryMethod == 'Standard delivery' ?standardDeliveryFee.toString(): "Rs : ${(standardDeliveryFee*.9).toStringAsFixed(2)}",
                            // "Rs:300.00",
                            style: TextStyle(
                                fontSize: 20
                            ),
                          ),

                        ],
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                placeOrder();
                              },
                              child: Text('Place Order'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(225, 77, 42, 1),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
