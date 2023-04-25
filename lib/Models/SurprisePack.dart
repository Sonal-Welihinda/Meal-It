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
      'Price': price,
      'Quantity': quantity,
      'PackImgUrl': imageUrl,
      'NumOfItems':numberOfItems,
      'BranchID':branchID
    };
  }

  factory SurprisePack.fromSnapshot(DocumentSnapshot snapshot){
    return SurprisePack.name(
      packName: snapshot.get("PackName"),
      packDescription: snapshot.get("Description"),
      price: BigInt.parse(snapshot.get("Price")) ,
      quantity: BigInt.parse(snapshot.get("Quantity")) ,
      imageUrl: snapshot.get("PackImgUrl"),
      numberOfItems: BigInt.parse(snapshot.get("NumOfItems")) ,
      branchID: snapshot.get("BranchID"),
      docID: snapshot.id
    );
  }
}