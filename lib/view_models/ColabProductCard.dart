import 'package:flutter/material.dart';
import 'package:meal_it/Models/ColabFoodProduct.dart';

class ColabProductCard extends StatefulWidget {
  ColabFoodProduct foodProduct;
  ColabProductCard({Key? key,required this.foodProduct}) : super(key: key);

  @override
  State<ColabProductCard> createState() => _ColabProductCardState();
}

class _ColabProductCardState extends State<ColabProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:180,
      width: 180,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                widget.foodProduct.productImg,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.foodProduct.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'by Colab CompanyName',
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
                "Rs :${widget.foodProduct.price}",
                textAlign: TextAlign.right,
              ),
            ),

            SizedBox(height: 10,),
          ],
        ),
      ),
    );
    ;
  }
}
