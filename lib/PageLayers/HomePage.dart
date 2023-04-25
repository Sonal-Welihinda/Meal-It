import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meal_it/Models/FoodCategory.dart';
import 'package:meal_it/PageLayers/RecipeViewPage.dart';

import 'package:meal_it/view_models/ColabProductCard.dart';
import 'package:meal_it/view_models/RecipeCard.dart';

import '../Models/Recipe.dart';
import '../view_models/AdvertisementCard.dart';
import '../view_models/PackCard.dart';
import '../view_models/ProductCard.dart';
import 'ProductPage.dart';
import 'RecipeHomePage.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [    ProductPage(),    RecipeHomePage(), ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Page 1',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Page 2',
            ),
          ],
        ),

    );
  }
}

// class PageOne extends StatelessWidget {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             //Welcome message and profile
//             Container(
//               padding: EdgeInsets.only(left: 16, top: 48, right: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Welcome, User1',
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         children: [
//                           Icon(Icons.location_on, size: 16),
//                           SizedBox(width: 4),
//                           Text(
//                             '123 Road Name, City',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey[600],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Container(
//                     height: 48,
//                     width: 48,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.grey[300],
//                     ),
//                     child: Icon(Icons.person),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//
//             //Advertisement
//             CarouselSlider(
//                 options: CarouselOptions(
//                   height: 200,
//                   enlargeCenterPage: true,
//                   autoPlay: true,
//                   aspectRatio: 20 / 8,
//                   autoPlayCurve: Curves.fastOutSlowIn,
//                   enableInfiniteScroll: true,
//                   autoPlayAnimationDuration: Duration(milliseconds: 700),
//                   viewportFraction: 0.85,
//                   pageSnapping: true,
//                   enlargeFactor: .2
//
//
//                 ),
//                 items: [
//                   AdvertisementCard(),
//                 ]
//             ),
//             SizedBox(height: 16),
//
//             //Surprise Pack
//             Padding(
//               padding: EdgeInsets.only(left: 16),
//               child: Text(
//                 'Packs',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
//             Container(
//               height: 180,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 4,
//                 itemBuilder: (BuildContext context, int index) {
//                   return PackCard();
//                 },
//               ),
//             ),
//             SizedBox(height: 16),
//
//             //Colab Items
//             Padding(
//               padding: EdgeInsets.only(left: 16),
//               child: Text(
//                 'Stores',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
//             Container(
//               height: 180,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 5,
//                 itemBuilder: (BuildContext context, int index) {
//                   return ColabProductCard();
//                 },
//               ),
//             ),
//             SizedBox(height: 16),
//
//             //Products from mealShip
//             Padding(
//               padding: EdgeInsets.only(left: 16),
//               child: Text(
//                 'From Us',
//                 style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             SizedBox(height: 8),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 1/1,
//                 crossAxisSpacing: 1,
//                 mainAxisSpacing: 4,
//                 mainAxisExtent: 190
//               ),
//               itemCount: 6,
//               itemBuilder: (BuildContext context, int index) {
//                 return ProductCard();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



