import 'package:cloud_firestore/cloud_firestore.dart';

class ColabFoodProduct{
  late String _productId;
  late String _productImg;
  late String _productName;
  late int _quantity;
  late Timestamp _offerEndTime;
  late BigInt _originalPrice;
  late BigInt _price;
  late String _branchID;


  ColabFoodProduct.empty();




  Map<String , dynamic> toJson(){
    return {
      'ProductName': _productName,
      'Quantity': _quantity,
      'Time':_offerEndTime,
      'Original-Price':_originalPrice.toString(),
      'Price':_price.toString(),
      'BranchID' : _branchID,
      'ProductImg' : _productImg,

    };
  }

  factory ColabFoodProduct.fromSnapshot(DocumentSnapshot snapshot){
    ColabFoodProduct foodProduct = ColabFoodProduct.empty();
    foodProduct.productName = snapshot.get("ProductName");
    foodProduct.quantity = snapshot.get("Quantity");
    foodProduct.offerEndTime = snapshot.get("Time");
    foodProduct.price = BigInt.parse(snapshot.get("Price"));
    foodProduct.productImg = snapshot.get("ProductImg");
    foodProduct.branchID = snapshot.get("BranchID");
    foodProduct.originalPrice = BigInt.parse(snapshot.get("Original-Price"));
    foodProduct.productId = snapshot.id;

    return foodProduct;
  }


  String get productImg => _productImg;

  set productImg(String value) {
    _productImg = value;
  }

  BigInt get originalPrice => _originalPrice;

  set originalPrice(BigInt value) {
    _originalPrice = value;
  }

  String get productName => _productName;

  set productName(String value) {
    _productName = value;
  }

  int get quantity => _quantity;

  set quantity(int value) {
    _quantity = value;
  }

  Timestamp get offerEndTime => _offerEndTime;

  set offerEndTime(Timestamp value) {
    _offerEndTime = value;
  }

  BigInt get price => _price;

  set price(BigInt value) {
    _price = value;
  }

  String get branchID => _branchID;

  set branchID(String value) {
    _branchID = value;
  }

  String get productId => _productId;

  set productId(String value) {
    _productId = value;
  }
}