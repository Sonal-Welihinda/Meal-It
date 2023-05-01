import 'package:cloud_firestore/cloud_firestore.dart';

class SurprisePack{
  late String packName;
  late String packDescription;
  late BigInt quantity;
  late BigInt price;
  late BigInt numberOfItems;
  late String imageUrl;
  late String branchID;
  late String docID;

  SurprisePack.name(
      {
        required this.packName,
        required this.packDescription,
        required this.quantity,
        required this.price,
        required this.numberOfItems,
        required this.branchID,
        required this.imageUrl,
        this.docID = ""
      }
  );


  Map<String, dynamic> toJson() {
    return{
      'PackName': packName,
      'Description': packDescription,
      'Price': price.toString(),
      'Quantity': quantity.toInt(),
      'PackImgUrl': imageUrl,
      'NumOfItems':numberOfItems.toInt(),
      'BranchID':branchID
    };
  }



  factory SurprisePack.fromSnapshot(DocumentSnapshot snapshot){
    return SurprisePack.name(
      packName: snapshot.get("PackName"),
      packDescription: snapshot.get("Description"),
      price: BigInt.parse(snapshot.get("Price")) ,
      quantity: BigInt.parse(snapshot.get("Quantity").toString()) ,
      imageUrl: snapshot.get("PackImgUrl"),
      numberOfItems: BigInt.parse(snapshot.get("NumOfItems").toString()) ,
      branchID: snapshot.get("BranchID"),
      docID: snapshot.id
    );
  }

  factory SurprisePack.fromJson(Map<String,dynamic> snapshot) {
    print(snapshot);
    return SurprisePack.name(
        packName: snapshot["PackName"],
        packDescription: snapshot["Description"],
        price: BigInt.parse(snapshot["Price"]) ,
        quantity: BigInt.parse(snapshot["Quantity"].toString()) ,
        imageUrl: snapshot["PackImgUrl"],
        numberOfItems: BigInt.parse(snapshot["NumOfItems"].toString()) ,
        branchID: snapshot["BranchID"],
        docID: snapshot["id"]
    );
  }
}