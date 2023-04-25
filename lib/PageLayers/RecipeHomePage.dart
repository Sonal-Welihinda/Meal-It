import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meal_it/Models/BusinessLayer.dart';

import '../Models/FoodCategory.dart';
import '../Models/Recipe.dart';
import '../view_models/AdvertisementCard.dart';
import '../view_models/RecipeCard.dart';
import 'RecipeViewPage.dart';

class RecipeHomePage extends StatefulWidget {
  const RecipeHomePage({Key? key}) : super(key: key);

  @override
  State<RecipeHomePage> createState() => _RecipeHomePageState();
}

class _RecipeHomePageState extends State<RecipeHomePage> {

  BusinessLayer _businessL = BusinessLayer();
  List<Recipe> popularRecipes = [];

  Future<void> getPopularRecipes() async {
    popularRecipes = await _businessL.getPopularRecipes();
    setState(() {

    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPopularRecipes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Welcome User
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 40,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome, User 1',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.person),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            //ImageSlider
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
            //Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(height: 16),

            //Recommended
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recommended',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            // SizedBox(
            //   height: 300,
            //   child: CustomScrollView(
            //     scrollDirection: Axis.horizontal,
            //     shrinkWrap: true,
            //     slivers: <Widget>[
            //       SliverPrototypeExtentList(
            //         delegate: SliverChildBuilderDelegate(
            //           childCount: 8,
            //               (context, index) => RecipeCard(),
            //         ),
            //         prototypeItem: RecipeCard(),
            //       )],
            //   ),
            // ),

            Container(
              height: 290,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(builder: (context) => RecipeViewPage(recipe: popularRecipes[index],),)
                          // );
                        },
                        child: RecipeCard()
                    );
                  }
              ),
            ),
            SizedBox(height: 16),


            //Popular
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Popular',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 290,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: popularRecipes.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap:() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RecipeViewPage(recipe: popularRecipes[index],),)
                        );
                      },
                      child: RecipeCard(),
                    );
                  }
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Weekly',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 290,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return RecipeCard();
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
