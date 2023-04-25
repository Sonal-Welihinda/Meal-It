import 'package:flutter/material.dart';
import 'package:meal_it/Models/ColabFoodProduct.dart';
import 'package:meal_it/view_models/custom_RadioButton1.dart';

class ColabProductPage extends StatefulWidget {
  ColabFoodProduct foodProduct;

  ColabProductPage({Key? key,required this.foodProduct}) : super(key: key);

  @override
  State<ColabProductPage> createState() => _ColabProductPageState();
}

class _ColabProductPageState extends State<ColabProductPage> {

  String selectedOrderType = "Delivery";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  color: Colors.grey,
                  // Replace this with the actual image widget
                  child: Image.network(widget.foodProduct.productImg),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Product name
                    Text(
                      widget.foodProduct.productName,
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 8),

                    //Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.timer),
                        SizedBox(width: 8),
                        Text(widget.foodProduct.offerEndTime.toDate().hour.toString()+"H",
                          style: TextStyle(
                              fontSize: 18
                          ),
                        ),
                        Text(
                          ' left',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),

                    //Discount in Presentage
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          // color: Colors.red,
                          child: Text(
                            '5% off',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromRGBO(225, 77, 42, 1),
                            ),
                          ),
                        )
                      ],
                    ),

                    //Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          widget.foodProduct.price.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(225, 77, 42, 1),
                          ),
                        ),
                        SizedBox(width: 8),
                        Stack(
                          children: [
                            Text(
                              widget.foodProduct.originalPrice.toString(),
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    //Order Type
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: CustomRadioButton1(
                            icon: Icons.local_shipping,
                            label: "Delivery",
                            onSelect: (value){
                              selectedOrderType = value;
                              setState(() {

                              });
                            },
                            groupValue: selectedOrderType,
                            value: "Delivery",
                            iconColor: Colors.black,
                            defaultIconColor: Colors.black,
                            backgroundColor: Color.fromRGBO(255, 224, 217, 1),
                            defaultBgColor: Colors.white,
                            axisAlignment: MainAxisAlignment.center,
                            borderRadius: 40,
                            borderColor: Color.fromRGBO(224, 224, 224, 1),

                          ),
                        ),
                        SizedBox(width: 16,),
                        Expanded(
                          child: CustomRadioButton1(
                            icon: Icons.hail,
                            label: "Pickup",
                            onSelect: (value){
                              selectedOrderType = value;
                              setState(() {

                              });
                            },
                            groupValue: selectedOrderType,
                            value: "Pickup",
                            iconColor: Colors.black,
                            defaultIconColor: Colors.black,
                            backgroundColor: Color.fromRGBO(255, 224, 217, 1),
                            defaultBgColor: Colors.white,
                            axisAlignment: MainAxisAlignment.center,
                            borderRadius: 40,
                            borderColor: Color.fromRGBO(224, 224, 224, 1),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    //Description
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This is a sample product description. It can be up to five lines long. This is a sample product description. It can be up to five lines long.',
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 8),
                        Text('From Pizza Hut'),
                      ],
                    ),
                    SizedBox(height: 16),


                    //Quantity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              primary: Colors.white,
                              onPrimary: Colors.black,
                            ),
                            onPressed: () {},
                            child: Icon(Icons.remove),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(2, 3), // changes position of shadow
                                  ),
                                ]
                              ),
                              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              child: Text(
                                '1',
                                style: TextStyle(
                                  color: Color.fromRGBO(225, 77, 42, 1),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {},
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    //Add / place order button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: selectedOrderType=="Delivery" ? Text('Add to Cart'):Text('Place order'),
                              style: ElevatedButton.styleFrom(
                                elevation: 4,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                backgroundColor: Colors.white,
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                                foregroundColor: Color.fromRGBO(225, 77, 42, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40)
                                )
                              ),


                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

