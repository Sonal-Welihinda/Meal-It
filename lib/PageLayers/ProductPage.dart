import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meal_it/Models/ColabFoodProduct.dart';
import 'package:meal_it/Models/FoodProduct.dart';
import 'package:meal_it/PageLayers/ProfilePage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Models/BusinessLayer.dart';
import '../Models/SurprisePack.dart';
import '../view_models/AdvertisementCard.dart';
import '../view_models/ColabProductCard.dart';
import '../view_models/PackCard.dart';
import '../view_models/ProductCard.dart';
import 'ColabProductPage.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  BusinessLayer businessL = BusinessLayer();
  List<SurprisePack> surprisePackList =[];
  List<FoodProduct> productsList =[];
  List<ColabFoodProduct> colabProductsList =[];


  Future<bool> checkLocationPermission() async {
    // Check if location permission is granted
    PermissionStatus status = await Permission.locationWhenInUse.status;

    if (status == PermissionStatus.granted) {
      getCurrentLocation();
      return true;
    } else {
      // If not granted, request location permission
      status = await Permission.locationWhenInUse.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<Position> getCurrentLocation() async {
    // Get the current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<void> getSurprisePack() async {
    surprisePackList = await businessL.getSurprisePack();
    setState(() {

    });
  }

  Future<void> getMealShipProducts() async {
    productsList = await businessL.getAllFoodProduct();

    setState(() {

    });
  }

  Future<void> getColabProducts() async {
    Position position = await getCurrentLocation();
    colabProductsList = await businessL.getNearColabProducts(position.latitude, position.longitude);

    setState(() {

    });
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSurprisePack();
    getMealShipProducts();
    checkLocationPermission();
    getColabProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Welcome message and profile
            Container(
              padding: EdgeInsets.only(left: 16, top: 48, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, User1',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16),
                          SizedBox(width: 4),
                          Text(
                            '123 Road Name, City',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ProfilePage(),),
                        );
                      },
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            //Advertisement
            CarouselSlider(
                options: CarouselOptions(
                    height: 200,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 20 / 8,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 700),
                    viewportFraction: 0.85,
                    pageSnapping: true,
                    enlargeFactor: .2


                ),
                items: [
                  AdvertisementCard(),
                ]
            ),
            SizedBox(height: 16),

            //Surprise Pack
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Packs',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: surprisePackList.length,
                itemBuilder: (BuildContext context, int index) {
                  return PackCard();
                },
              ),
            ),
            SizedBox(height: 16),

            //Colab Items
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'Stores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 180,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colabProductsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ColabProductPage(foodProduct: colabProductsList[index]),)
                      );
                    },
                      child: ColabProductCard()
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            //Products from mealShip
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'From Us',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1/1,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 4,
                  mainAxisExtent: 190
              ),
              itemCount: productsList.length,
              itemBuilder: (BuildContext context, int index) {
                return ProductCard();
              },
            ),
          ],
        ),
      ),
    );
  }


}
