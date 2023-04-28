import 'package:flutter/material.dart';
import 'package:meal_it/Models/FoodProduct.dart';

class ProductCard extends StatefulWidget {
  FoodProduct foodProduct;
  ProductCard({Key? key,required this.foodProduct}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            height: 100,
            widget.foodProduct.imgUrl,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.foodProduct.foodName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  widget.foodProduct.foodRecipe.recipeName,
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              widget.foodProduct.price.toString(),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
    ;
  }
}
