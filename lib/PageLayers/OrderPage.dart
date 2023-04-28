import 'package:flutter/material.dart';

import '../Models/BusinessLayer.dart';
import '../Models/CartModel.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  BusinessLayer _businessL = BusinessLayer();
  late CartModel cartModel = CartModel();

  Future<void> getCartDetails() async {
    cartModel = await _businessL.getCart();

    setState(() {

    });
  }

  // define the available payment and delivery methods
  final List<String> paymentMethods = [
    'Credit/Debit card',
    'Direct pay',
    'Cash on delivery'
  ];
  final List<String> deliveryMethods = [
    'Standard delivery',
    'Express delivery'
  ];

  // define the selected payment and delivery methods
  String selectedPaymentMethod = 'Credit card';
  String selectedDeliveryMethod = 'Standard delivery';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartDetails();
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
                itemCount: 2, // replace with the actual number of items
                itemBuilder: (BuildContext context, int index) {
                  // replace with your cart card widget
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.network(
                            'https://picsum.photos/100',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Quantity: 1',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(height: 4.0),
                                Text(
                                  'Price: \$10.00',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
                    DropdownButton<String>(
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
                          child: Text(value),
                        );
                      }).toList(),
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
                          Text("For products",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Text("Rs : "+cartModel.getTotal().toString(),
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
                              onPressed: () {},
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
