import 'package:cloud_firestore/cloud_firestore.dart';
import 'FoodCategory.dart';
import 'Recipe.dart';

class FoodProduct{
  late String docID;
  late String foodName;
  late String foodDescription;
  late Recipe foodRecipe;
  late FoodCategory foodTypes;
  late BigInt price;
  late BigInt quantity;
  late String imgUrl;
  late String branchID;

  FoodProduct.create(
      {
        required this.foodName,
        required this.foodDescription,
        required this.foodRecipe,
        required this.foodTypes,
        required this.price,
        required this.quantity,
        this.imgUrl ="",
        this.docID = "",
        this.branchID=""
      }
      );

  Map<String, dynamic> toJson() {
    return{
      'FoodName': foodName,
      'FoodDescription': foodDescription,
      'FoodRecipe': foodRecipe.productToJson(),
      'Type': foodTypes.toJson2(),
      'Price': price.toString(),
      'Quantity': quantity.toString(),
      'ImgUrl': imgUrl,
      'BranchID':branchID
    };
  }

  factory FoodProduct.fromSnapshot(DocumentSnapshot snapshot){
    return FoodProduct.create(
        foodName: snapshot.get("FoodName"),
        foodDescription: snapshot.get("FoodDescription"),
        quantity: BigInt.parse(snapshot.get("Quantity")) ,
        foodRecipe: Recipe.productFromSnapshot(snapshot.get("FoodRecipe")) ,
        price: BigInt.parse(snapshot.get("Price")) ,
        foodTypes: FoodCategory.fromSnapshot3(snapshot.get("Type")) ,
        imgUrl: snapshot.get("ImgUrl"),
        branchID: snapshot.get("BranchID"),
        docID: snapshot.id
    );
  }
}