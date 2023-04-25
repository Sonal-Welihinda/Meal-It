import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class IngredientItem{
  late TextEditingController name;
  late TextEditingController amount;

  IngredientItem.name({required this.name, required this.amount});

  Map<String, dynamic> toJson() {
    return {
      'IngredientName': name.text,
      'amount':amount.text,
    };

  }

  factory IngredientItem.fromSnapshot(Map<String,dynamic> snapshot){
    return IngredientItem.name(
      amount: TextEditingController(text: snapshot["amount"]),
      name: TextEditingController(text: snapshot["IngredientName"])
    );
  }

  static List<IngredientItem> toIngredientList(DocumentSnapshot snapshot){
    List<dynamic> data = snapshot.get("IngredientList");

    return data.map((e) => IngredientItem.fromSnapshot(e)).toList();
  }
}