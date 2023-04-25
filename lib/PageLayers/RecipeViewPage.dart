import 'package:flutter/material.dart';
import 'package:meal_it/Models/IngredientItem.dart';
import 'package:meal_it/Models/Recipe.dart';
import 'package:shimmer/shimmer.dart';

class RecipeViewPage extends StatefulWidget {
  Recipe recipe;

  RecipeViewPage({Key? key,required this.recipe}) : super(key: key);

  @override
  _RecipeViewPageState createState() => _RecipeViewPageState();
}

class _RecipeViewPageState extends State<RecipeViewPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(
          children: [

            //Image holder
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(

                  image:
                      NetworkImage(widget.recipe.recipeImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Shimmer.fromColors(
            //   baseColor: Colors.grey[300]!,
            //   highlightColor: Colors.grey[100]!,
            //   child: Container(
            //     height: MediaQuery.of(context).size.height * 0.4,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(12.0),
            //       color: Colors.grey[300],
            //     ),
            //     child: Image.network(
            //       widget.recipe.recipeImage,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),

            //Recipe name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.recipe.recipeName,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            //Recipe description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    widget.recipe.recipeDescription,
                    textAlign: TextAlign.start,
                    maxLines: 4,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            //two cards time and servings
            Row(
              children: [
                //time
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //First line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timer),
                          SizedBox(width: 5,),
                          Text(
                            widget.recipe.time,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    //Second line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cookng Time',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      )

                    ],
                  ),
                ),

                //Servings
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //First line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.groups),
                          SizedBox(width: 5,),
                          Text(
                            widget.recipe.servings.toString(),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      //Second line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Serving',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          )
                        ],
                      )

                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            //Ingredients and steps
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [

                      //two buttons ingredients and steps
                      Container(
                        margin: const EdgeInsets.only(left: 16.0,right: 16.0,bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: TabBar(

                          indicator: BoxDecoration(
                            color: const Color.fromRGBO(255, 147, 116, 1.0),
                            borderRadius: BorderRadius.circular(40),

                          ),
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black,
                            tabs: [
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ImageIcon(Image.asset("assets/Images/ingredients.png").image),
                                    SizedBox(width: 8), // add some spacing between the icon and text
                                    Text("Ingredients"),
                                  ],
                                ),
                              ),
                              Tab(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Instructions"),
                                    SizedBox(width: 8),
                                    ImageIcon(Image.asset("assets/Images/instruction.png").image),

                                  ],
                                ),

                              ),
                            ]
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TabBarView(
                            children: [
                              //Ingredients
                              ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                // physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.recipe.ingredientList.length,
                                itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(40),
                                                color: Colors.white
                                              ),
                                              child: Text(
                                                widget.recipe.ingredientList[index].amount.text,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              padding: EdgeInsets.only(top: 10,bottom: 10,right: 10,left: 15),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(40),
                                                  color: Colors.white
                                              ),
                                              child: Text(
                                                widget.recipe.ingredientList[index].name.text,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    ;
                                  },
                              ),

                              //Instructions
                              ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                // physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.recipe.steps.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (index+1).toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text("       "),
                                        Expanded(
                                          child: Text(
                                            widget.recipe.steps[index],
                                            textAlign: TextAlign.start,
                                            maxLines: null,
                                            softWrap: true,
                                            style: TextStyle(
                                              overflow: TextOverflow.visible,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )

              ),
            ),

          ],
        ),
      ),
    );
  }
}
