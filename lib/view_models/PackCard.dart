import 'package:flutter/material.dart';

class PackCard extends StatefulWidget {
  const PackCard({Key? key}) : super(key: key);

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
            Image.network(
              'https://freedesignfile.com/upload/2016/11/Poster-fast-food-vector-material-04.jpg',
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Some smaller text',
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
                'Right-aligned text',
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
