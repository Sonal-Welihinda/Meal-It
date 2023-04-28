import 'package:flutter/material.dart';
import 'package:meal_it/Models/ColabFoodProduct.dart';
import 'package:meal_it/Models/FoodProduct.dart';
import 'package:meal_it/Models/SurprisePack.dart';

class CartCard extends StatefulWidget {

  FoodProduct? foodProduct;
  ColabFoodProduct? colabFoodProduct;
  SurprisePack? surprisePack;

  CartCard({Key? key,this.surprisePack,this.colabFoodProduct,this.foodProduct}) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  String name="";
  String imageUrl="";
  String qua="0";
  String price="0.00";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.surprisePack != null){
      name = widget.surprisePack!.packName;
      imageUrl = widget.surprisePack!.imageUrl;
      qua = widget.surprisePack!.quantity.toString();
      price = widget.surprisePack!.price.toString();
      setState(() {

      });
    }

    if(widget.colabFoodProduct != null){
      name = widget.colabFoodProduct!.productName;
      imageUrl = widget.colabFoodProduct!.productImg;
      qua = widget.colabFoodProduct!.quantity.toString();
      price = widget.colabFoodProduct!.price.toString();

      setState(() {

      });
    }

    if(widget.foodProduct != null){
      name = widget.foodProduct!.foodName;
      imageUrl = widget.foodProduct!.imgUrl;
      qua = widget.foodProduct!.quantity.toString();
      price = widget.foodProduct!.price.toString();

      setState(() {

      });
    }



  }

  @override
  Widget build(BuildContext context) {
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
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.network(
              imageUrl,
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
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    qua,
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Price: $price',
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
  }
}
