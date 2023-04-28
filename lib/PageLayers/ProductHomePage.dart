import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meal_it/Models/ColabFoodProduct.dart';
import 'package:meal_it/Models/Customer.dart';
import 'package:meal_it/Models/FoodProduct.dart';
import 'package:meal_it/PageLayers/PackViewPage.dart';
import 'package:meal_it/PageLayers/ProductViewPage.dart';
import 'package:meal_it/PageLayers/ProfilePage.dart';
import 'package:meal_it/view_models/Skeleton.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../Models/BusinessLayer.dart';
import '../Models/SurprisePack.dart';
import '../view_models/AdvertisementCard.dart';
import '../view_models/ColabProductCard.dart';
import '../view_models/PackCard.dart';
import '../view_models/ProductCard.dart';
import 'ColabProductPage.dart';
import 'LocationPickerDialog.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  BusinessLayer businessL = BusinessLayer();
  late Customer customer;

  late Position? position =null;
  List<SurprisePack> surprisePackList =[];
  List<FoodProduct> productsList =[];
  List<ColabFoodProduct> colabProductsList =[];
  String customerName="";
  String customerProfileUrl = "";
  String addressInString = "";


  late GoogleMapController mapController;
  late String searchQuery;
  Set<Marker> markers = {};

  LatLng currentLocation = LatLng(37.7749, -122.4194); // San Francisco


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _moveCamera(LatLng location) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: location,
        zoom: 14.0,
      ),
    ));
  }

  void _addMarker(LatLng location) {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId("selected-location"),
        position: location,
      ),
    );
  }



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
        getCurrentLocation();
        return true;
      } else {
        return false;
      }
    }
  }

  Future<Position> getCurrentLocation() async {
    // Get the current location
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return position!;
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
    await checkLocationPermission();
    position = await getCurrentLocation();

    colabProductsList = await businessL.getNearColabProducts(position!.latitude, position!.longitude);

    setState(() {

    });
  }


  Future<void> setUserData() async {
    customer = await businessL.getCustomerData();
    await checkLocationPermission();
    if(position == null){
      position = await getCurrentLocation();
    }


    List<Placemark> placemarks = await placemarkFromCoordinates(position!.latitude, position!.longitude);
    Placemark placemark = placemarks[0];

    customerProfileUrl = customer.profileImgUrl;
    customerName = customer.name;
    addressInString = "${placemark.street}, ${placemark.locality}";

    await getColabProducts();
    setState(() {

    });
  }

  Future<void> setCurrentLocation(LatLng latLng) async {
    position = Position(longitude: latLng.longitude,
        latitude: latLng.latitude,
        timestamp: null,
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0
    );

    setState(() {

    });
    setUserData();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSurprisePack();
    getMealShipProducts();
    setUserData();
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
                      customerName.trim().isEmpty ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: SkeletonBox(
                          height: 24,
                          width: MediaQuery.of(context).size.width*.7,
                        ),
                      ) : Text(
                        'Welcome, $customerName',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                              context: context, builder: (context) {
                                return LocationPickerDialog(currentLocation: LatLng(position!.latitude, position!.longitude),
                                  setLocation: this.setCurrentLocation,);
                              },
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on, size: 17),
                            SizedBox(width: 4),
                            addressInString.trim().isEmpty ? Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: SkeletonBox(
                                height: 24,
                                width: MediaQuery.of(context).size.width*.7,
                              ),
                            ) : Text(
                              addressInString,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
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
                      child: customerProfileUrl.trim().isEmpty ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container()
                      ): Image.network(customerProfileUrl,fit: BoxFit.cover,),
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
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PackViewPage(pack: surprisePackList[index]),)
                      );
                    },
                    child: PackCard(pack: surprisePackList[index],)
                  );
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
                      child: ColabProductCard(foodProduct: colabProductsList[index],)
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            //Products from mealShip
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'From MealShip',
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductViewPage(foodProduct: productsList[index]),)
                    );
                  },
                  child: ProductCard(foodProduct: productsList[index],)
                );
              },
            ),
          ],
        ),
      ),
    );

  }
  void showLocationPickDialog(){
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for a location",
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
                  zoom: 14.0,
                ),
                onTap: (LatLng location) {
                  setState(() {
                    _addMarker(location);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(markers.first.position);
                },
                child: Text("Select Location"),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
