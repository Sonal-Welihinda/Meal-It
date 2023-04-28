import 'package:flutter/material.dart';
import 'package:meal_it/Models/SurprisePack.dart';

class PackCard extends StatefulWidget {
  final SurprisePack pack;
  const PackCard({Key? key,required this.pack}) : super(key: key);

  @override
  State<PackCard> createState() => _PackCardState();
}

class _PackCardState extends State<PackCard> {
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
                widget.pack.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pack.packName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    "item in the pack : ${widget.pack.numberOfItems}",
                    style: TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8,bottom: 8),
              child: Text(
                "Rs : ${widget.pack.price}",
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
