import 'package:flutter/material.dart';
import 'package:meal_it/Models/ColabFoodProduct.dart';
import 'package:meal_it/view_models/custom_RadioButton1.dart';

import '../Models/BusinessLayer.dart';

class ColabProductPage extends StatefulWidget {
  ColabFoodProduct foodProduct;

  ColabProductPage({Key? key,required this.foodProduct}) : super(key: key);

  @override
  State<ColabProductPage> createState() => _ColabProductPageState();
}

class _ColabProductPageState extends State<ColabProductPage> {

  String selectedOrderType = "Delivery";
  int quantity=1;
  BusinessLayer _businessL = BusinessLayer();


  void addQuantity(){
    if(quantity<widget.foodProduct.quantity){
      quantity++;
    }
    setState(() {

    });
  }

  void removeQuantity(){
    if(quantity>1){
      quantity--;
    }
    setState(() {

    });
  }

  Future<bool> getAvailableStock() async {
    bool canOrder = true;
    widget.foodProduct = await _businessL.getColabFoodProductById(widget.foodProduct.productId);
    BigInt stock = BigInt.parse(widget.foodProduct.quantity.toString());

    if(stock == BigInt.zero){
      quantity =0;
      canOrder = false;
      setState(() {

      });
    }

    if(stock<BigInt.parse(quantity.toString())){
      quantity = stock.toInt();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Available Stock changed"))
      );
      canOrder = false;
      return canOrder;
    }

    return canOrder;
  }

  Future<void> addToCart() async {
    bool canOrder = await getAvailableStock();
    if(!canOrder){
      return;
    }

    ColabFoodProduct cartProduct = widget.foodProduct;
    cartProduct.quantity = quantity;

    String result = await _businessL.addToCart(colabFoodProduct: cartProduct);

    if(result=="Success"){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${widget.foodProduct.productName} Added to the cart"))
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to add the product to cart"))
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.grey,
                  // Replace this with the actual image widget
                  child: Image.network(widget.foodProduct.productImg,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Product name
                    Text(
                      widget.foodProduct.productName,
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 8),

                    //Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.timer),
                        SizedBox(width: 8),
                        Text(widget.foodProduct.offerEndTime.toDate().hour.toString()+"H",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                        Text(
                          ' left',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),

                    //Discount in Presentage
                    if((((widget.foodProduct.originalPrice - widget.foodProduct.price) / widget.foodProduct.originalPrice) * 100)>=1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          // color: Colors.red,
                          child: Text(
                            "${(((widget.foodProduct.originalPrice - widget.foodProduct.price) / widget.foodProduct.originalPrice) * 100).toDouble().toStringAsFixed(2)} Off",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromRGBO(225, 77, 42, 1),
                            ),
                          ),
                        )
                      ],
                    ),

                    //Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Rs :${widget.foodProduct.price*BigInt.parse(quantity.toString())}.00",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(225, 77, 42, 1),
                          ),
                        ),
                        SizedBox(width: 8),
                        Stack(
                          children: [
                            Text(
                              "Rs :${widget.foodProduct.originalPrice}.00",
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),


                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 8),
                        Text('From Pizza Hut'),
                      ],
                    ),

                    SizedBox(height: 16),
                    //Order Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomRadioButton1(
                            icon: Icons.local_shipping,
                            label: "Delivery",
                            onSelect: (value){
                              selectedOrderType = value;
                              setState(() {

                              });
                            },
                            groupValue: selectedOrderType,
                            value: "Delivery",
                            iconColor: Colors.black,
                            defaultIconColor: Colors.black,
                            backgroundColor: Color.fromRGBO(255, 224, 217, 1),
                            defaultBgColor: Colors.white,
                            axisAlignment: MainAxisAlignment.center,
                            borderRadius: 40,
                            borderColor: Color.fromRGBO(224, 224, 224, 1),

                          ),
                        ),
                        SizedBox(width: 16,),
                        Expanded(
                          child: CustomRadioButton1(
                            icon: Icons.hail,
                            label: "Pickup",
                            onSelect: (value){
                              selectedOrderType = value;
                              setState(() {

                              });
                            },
                            groupValue: selectedOrderType,
                            value: "Pickup",
                            iconColor: Colors.black,
                            defaultIconColor: Colors.black,
                            backgroundColor: Color.fromRGBO(255, 224, 217, 1),
                            defaultBgColor: Colors.white,
                            axisAlignment: MainAxisAlignment.center,
                            borderRadius: 40,
                            borderColor: Color.fromRGBO(224, 224, 224, 1),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),


                    //Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: quantity>1 ? removeQuantity:null,
                            child: Icon(Icons.remove),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(2, 3), // changes position of shadow
                                  ),
                                ]
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                quantity.toString(),
                                style: TextStyle(
                                  color: Color.fromRGBO(225, 77, 42, 1),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              addQuantity();
                            },
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    //Add / place order button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: selectedOrderType=="Delivery" ? addToCart :_showOrderSheet,
                              child: selectedOrderType=="Delivery" ? Text('Add to Cart'):Text('Place order'),
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                                foregroundColor: Color.fromRGBO(225, 77, 42, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)
                                )
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

  void _showOrderSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
        )
      ),
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Your Order",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // Product name and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.foodProduct.productName,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400
                        ),
                      ),
                      Text("Rs :${widget.foodProduct.price*BigInt.parse(quantity.toString())}",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                  // Quantity add and remove buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: quantity>1 ? (){
                            setState.call(() {
                              removeQuantity();
                            },);
                          }:null,
                          child: Icon(Icons.remove),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(2, 3), // changes position of shadow
                                ),
                              ]
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(
                                color: Color.fromRGBO(225, 77, 42, 1),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),


                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            setState.call(() {
                              addQuantity();
                            },);

                          },
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),

                  //Total Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',
                        style: TextStyle(
                            fontSize: 20,
                        ),
                      ),
                      Text("Rs :${widget.foodProduct.price*BigInt.parse(quantity.toString())}",
                        style: TextStyle(
                            fontSize: 20,
                        ),
                      ),
                    ],
                  ),

                  // Place order button
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Color.fromRGBO(225, 77, 42, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)
                            )
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _navigateBottomSheet();
                          },
                          child: Text('Place Order'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  void _navigateBottomSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20)
        )
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Your Order',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*.1),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset("assets/Images/navigateLocation.png"),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Tab on Navigate to get the pickup location',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        backgroundColor: Colors.white,
                        foregroundColor: Color.fromRGBO(225, 77, 42, 1),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)
                        )
                      ),
                      child: Text('Navigation'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

