import 'package:cloud_firestore/cloud_firestore.dart';

class FoodCategory{
  late String categoryName;
  late String docID;

  FoodCategory.name({this.categoryName = '', this.docID = ''});

  Map<String , dynamic> toJson(){
    return {
      'FoodCategoryName': categoryName,
    };
  }

  Map<String , dynamic> toJson2(){
    return {
      'FoodCategoryID': docID,
      'FoodCategoryName': categoryName,
    };
  }

  factory FoodCategory.fromSnapshot(DocumentSnapshot snapshot){
    return FoodCategory.name(
      categoryName: snapshot.get("FoodCategoryName"),
      docID: snapshot.id,
    );
  }

  factory FoodCategory.fromSnapshot2(DocumentSnapshot snapshot){
    return FoodCategory.name(
      categoryName: snapshot.get("Type.FoodCategoryName"),
      docID: snapshot.get("Type.FoodCategoryID"),
    );
  }

  factory FoodCategory.fromSnapshot3(Map<String, dynamic> snapshot){
    return FoodCategory.name(
      categoryName: snapshot["FoodCategoryName"],
      docID: snapshot["FoodCategoryID"],
    );
  }

}