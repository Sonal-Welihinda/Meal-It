import 'package:flutter/material.dart';
import 'package:meal_it/Models/SurprisePack.dart';

import '../Models/BusinessLayer.dart';

class PackViewPage extends StatefulWidget {
  SurprisePack pack;

  PackViewPage({Key? key,required this.pack}) : super(key: key);

  @override
  State<PackViewPage> createState() => _PackViewPageState();
}

class _PackViewPageState extends State<PackViewPage> {

  int quantity=1;
  BusinessLayer _businessL =BusinessLayer();


  void addQuantity(){
    // if(quantity<widget.quantity){
      quantity++;
    // }
    setState(() {

    });
  }

  void removeQuantity(){
    if(quantity>1){
      quantity--;
    }
    setState(() {

    });
  }


  Future<bool> getAvailableStock() async {
    bool canOrder = true;
    widget.pack = await _businessL.getSurprisePackByID(widget.pack.docID);
    BigInt stock = widget.pack.quantity;

    if(stock == BigInt.zero){
      quantity =0;
      canOrder = false;
      setState(() {

      });
    }

    if(stock<BigInt.parse(quantity.toString())){
      quantity = stock.toInt();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Available Stock changed"))
      );
      canOrder = false;
      return canOrder;
    }

    return canOrder;
  }

  Future<void> addToCart() async {
    bool canOrder = await getAvailableStock();
    if(!canOrder){
      return;
    }

    SurprisePack cartProduct = widget.pack;
    cartProduct.quantity = BigInt.parse(quantity.toString());

    String result = await _businessL.addToCart(pack: cartProduct);

    if(result=="Success"){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${widget.pack.packName} Added to the cart"))
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unable to add the product to cart"))
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              child: SingleChildScrollView(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*.5,
                      child: Image.network(
                        widget.pack.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          //Product name
                          Text(
                            'Product Name',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 8.0),

                          //Number of item and price
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Items in pack:',
                                    style: TextStyle(
                                      fontSize:20
                                    ),
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    "${widget.pack.numberOfItems*BigInt.parse(quantity.toString())}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:20
                                    ),
                                  ),
                                ],
                              ),


                              Text(
                                "Rs : ${widget.pack.price*BigInt.parse(quantity.toString())}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          //Quantity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: quantity>1 ? removeQuantity:null,
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
                                    quantity.toString(),
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
                                  onPressed: () {
                                    addQuantity();
                                  },
                                  child: Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),

                          //Description
                          Text(
                            'Description',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 8.0),
                          SingleChildScrollView(
                            child: Text(
                              widget.pack.packDescription,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                          ),


                          SizedBox(height: 8.0),


                        ],
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height*.1,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 1,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10,left: 10,right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          addToCart();
                        },
                        child: Text('Add to Cart'),
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
            ),
          ],
        ),
      ),
    );
  }
}
