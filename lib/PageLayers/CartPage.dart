import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:meal_it/Models/BusinessLayer.dart';
import 'package:meal_it/Models/CartModel.dart';
import 'package:meal_it/view_models/CartCard.dart';

import 'OrderPage.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  BusinessLayer _businessL = BusinessLayer();
  late CartModel cartModel = CartModel();

  Future<void> getCartDetails() async {
    cartModel = await _businessL.getCart();

    setState(() {

    });
  }

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
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Cart",
                    style: TextStyle(

                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: cartModel.surpriseList.length+cartModel.foodProduct.length+cartModel.colabFoodProduct.length, // Replace with actual number of items in cart
                itemBuilder: (BuildContext context, int index) {
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
            ),

            Container(
              width: double.infinity, // set the width to the maximum available space
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 24), // add some padding for spacing
              color: Colors.grey[200], // set a background color for the container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // align the elements to the left and right edges
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // align the text to the left
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ), // add some spacing between the text and the amount
                      Text(
                        'Rs : ${cartModel.getTotal()}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                      backgroundColor: Color.fromRGBO(225, 77, 42, 1)
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OrderPage(),)
                      );
                    },
                    child: Text('Place order',
                      style: TextStyle(
                        fontSize: 20
                      ),
                    ),
                  ),
                ],
              ),
            )


      ],
        ),
      ),
    );
  }
}
