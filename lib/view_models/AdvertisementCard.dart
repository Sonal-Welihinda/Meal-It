import 'package:flutter/material.dart';

class AdvertisementCard extends StatefulWidget {
  const AdvertisementCard({Key? key}) : super(key: key);

  @override
  State<AdvertisementCard> createState() => _AdvertisementCardState();
}

class _AdvertisementCardState extends State<AdvertisementCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14)
      ),
      elevation: 4,
      child: Image.network(
          fit: BoxFit.fill,
          "https://freedesignfile.com/upload/2016/11/Poster-fast-food-vector-material-04.jpg"),
    );
  }
}
