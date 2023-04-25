import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:meal_it/Models/ColabFoodProduct.dart';
import 'package:meal_it/Models/Customer.dart';
import 'package:meal_it/Models/SurprisePack.dart';

import '../DL/CustomerInterface.dart';
import '../Models/Branch.dart';
import '../Models/FoodProduct.dart';
import '../Models/Recipe.dart';

class FirebaseDBServices extends CustomerInterface {

  final userDocRef = FirebaseFirestore.instance.collection('users');
  final branchDocRef = FirebaseFirestore.instance.collection('Meal Ship-Branches');
  final companyFood = FirebaseFirestore.instance.collection('Colab-FoodProduct');
  final surprisePackDocRef = FirebaseFirestore.instance.collection('Surprise-Pack');
  final foodProductDocRef = FirebaseFirestore.instance.collection('Food-Product');
  final companyDocRef = FirebaseFirestore.instance.collection('Collab-Branches');
  final recipeDocRef = FirebaseFirestore.instance.collection('Recipes');

  Future<bool> emailsAvailability (String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    List<String> methods = await auth.fetchSignInMethodsForEmail(email);
    if (methods.isNotEmpty) {
      // Email is already in use
      return false;
    }


    return true;
  }


  @override
  Customer login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<String?> UpdateImage(String url, File img) async {
    // final storageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now()}.png');

    try{
      final storageRef = FirebaseStorage.instance.refFromURL(url);
      final uploadTask = storageRef.putFile(img!,SettableMetadata(
        contentType: "image/jpeg",
      ));
      await uploadTask.whenComplete(() => null);


      return "Success";
    } on FirebaseException catch (e){
      return null;
    }
  }

  @override
  Future<String> registerCustomer(Customer customer) async {
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: customer.email,
        password: customer.password,
      );

      final user = FirebaseAuth.instance.currentUser;
      final uid = user?.uid;

      var fileName = "assets/Images/userProfile.png";
      ByteData bytes = await rootBundle.load(fileName); //load sound from assets
      Uint8List rawData = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      final storageRef = FirebaseStorage.instance.ref().child('Customer/${DateTime.now()}.png');
      final uploadTask = storageRef.putData(rawData!,SettableMetadata(
        contentType: "image/jpeg",
      ));
      final snapshot = await uploadTask.whenComplete(() => null);
      String imgUrl = await snapshot.ref.getDownloadURL();
      customer.profileImgUrl = imgUrl;

      await userDocRef.doc(uid).set(customer.toJson());

      return "Success";


    } on FirebaseAuthException catch (e){
      print(e);
      return "failed";
    }
  }

  @override
  Future<String> updateCustomer(Customer customer) async {
    try{
      userDocRef.doc(customer.uID).update(customer.toJson());

      return "Success";
    } on FirebaseAuthException catch (e){
      print(e);
      return "failed";
    }
  }

  //load and save kiyala method dekka copyk ganna ona  , Save user id and name in share pref and when registering add acctype and default image ;

  @override
  Future<DocumentSnapshot?> getUserData(String uid) async {
    if(uid == null){
      return null;
    }
    DocumentSnapshot documentSnapshot = await userDocRef.doc(uid).get();
    if (documentSnapshot.exists) {
      return documentSnapshot;
    }
    return null;
  }


  //Branches
  @override
  Future<List<Branch>> getAllBranches() async {
    QuerySnapshot querySnapshot = await branchDocRef.get();
    List<Branch> Branches = querySnapshot.docs.map((doc) => Branch.fromSnapshot(doc)).toList();

    return Branches;
  }


  //Colab branch
  Future<List<Branch>> getColabBranchByCity(String city) async {
    QuerySnapshot querySnapshot = await companyDocRef.where("city",isEqualTo: city).get();
    List<Branch> branches = querySnapshot.docs.map((doc) => Branch.fromSnapshot(doc)).toList();

    return branches;
  }

  Future<QuerySnapshot> getClosestColabBranch(double latitude,double longitude,String city) async {
    // QuerySnapshot querySnapshot = await companyDocRef.where(Filter.and(
    //   Filter("geoInfo.city",isEqualTo: city),
    //
    // )).get();

    QuerySnapshot querySnapshot = await companyDocRef.where('geoInfo.city', isEqualTo: city).get();

    if(querySnapshot.docs.isEmpty){
      querySnapshot = await companyDocRef
          .where('location', isGreaterThan: GeoPoint(latitude - 0.1, longitude - 0.1))
          .where('location', isLessThan: GeoPoint(latitude + 0.1, longitude + 0.1)).get();
    }


    return querySnapshot;
  }


  //SurprisePack
  @override
  Future<List<SurprisePack>> getAllSurprisePacks(String branchID) async {
    QuerySnapshot querySnapshot = await surprisePackDocRef.where("BranchID" , isEqualTo: branchID).get();
    List<SurprisePack> foodPackList = querySnapshot.docs.map((doc) => SurprisePack.fromSnapshot(doc)).toList();

    return foodPackList;
  }


  //MealShip Product
  @override
  Future<List<FoodProduct>> getAllFoodProduct(String branchID) async {

    QuerySnapshot querySnapshot = await foodProductDocRef.where("BranchID" , isEqualTo: branchID).get();
    List<FoodProduct> foodProductList = querySnapshot.docs.map((doc) => FoodProduct.fromSnapshot(doc)).toList();

    return foodProductList;
  }


  //Colab products
  @override
  Future<List<ColabFoodProduct>> getAllBranchFoodProducts(String branchID) async {
    QuerySnapshot querySnapshot = await companyFood.where('BranchID', isEqualTo: branchID).get();
    List<ColabFoodProduct> foodList = querySnapshot.docs.map((doc) => ColabFoodProduct.fromSnapshot(doc)).toList();

    return foodList;
  }



//  Recipe
  @override
  Future<List<Recipe>> getPopularRecipe() async {
    //TODO : get and filter the recipes to get popular recipes
    QuerySnapshot querySnapshot = await recipeDocRef.get();
    List<Recipe> foodCategoryList = querySnapshot.docs.map((doc) => Recipe.fromSnapshot(doc)).toList();

    return foodCategoryList;
  }
}