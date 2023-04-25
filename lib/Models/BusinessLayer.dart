import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meal_it/Models/Branch.dart';
import 'package:meal_it/Models/Customer.dart';
import 'package:meal_it/Models/Recipe.dart';
import 'package:meal_it/Models/SurprisePack.dart';
import 'package:meal_it/Services/FirebaseDBServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ColabFoodProduct.dart';
import 'FoodProduct.dart';

class BusinessLayer{
  final FirebaseDBServices _dbServices = FirebaseDBServices();
  static SharedPreferences? prefs;
  late Branch branch;

  //Command functions
  Future<String> updateImage(String url, File img) async {
    String? result = await _dbServices.UpdateImage(url,img);
    if(result == null){
      return "failed";
    }else{
      return "Success";
    }
  }

  Future<void> _saveValue(String field,String value) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs!.setString(field, value);
  }

  Future<String> loadSavedValue(field) async {
    prefs ??= await SharedPreferences.getInstance();
    String  userType = prefs!.getString(field) ?? '';

    return userType;
  }




  double distanceBetween(GeoPoint p1, GeoPoint p2) {
    const p = 0.017453292519943295;
    var a = 0.5 - cos((p2.latitude - p1.latitude) * p) / 2 +
        cos(p1.latitude * p) *
            cos(p2.latitude * p) *
            (1 - cos((p2.longitude - p1.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }


  //Login and reg functions
  Future<bool> emailsAvailability(String email){
    return _dbServices.emailsAvailability(email);
  }

  Future<String> loginUser(String email,String password) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    DocumentSnapshot<Object?>? snapshot = await _dbServices.getUserData(userCredential.user!.uid);
    Map<String,dynamic> data = snapshot?.data() as Map<String,dynamic>;

    if(data["AccountType"] == "Customer"){
      await _saveValue("UserID",snapshot!.id);
      return "Success";
    }else{
      return "failed";
    }

  }

  Future<Customer> getCustomerData() async {
    String customerID = await loadSavedValue("UserID");
    DocumentSnapshot<Object?>? snapshot = await _dbServices.getUserData(customerID);

    Customer customer = Customer.fromSnapshot(snapshot!);

    return customer;
  }

  Future<String> updateCustomerData(Customer customer , File? img) async {
    if(img!=null){
      String imageUpdated = await updateImage(customer.profileImgUrl, img);
      if(imageUpdated !="Success"){
        return "failed";
      }
    }

    return _dbServices.updateCustomer(customer);
  }



  //colab closest branch
  Future<List<Branch>> getClosestBranch(double latitude,double longitude,String city) async {
    double radius = 5.0;

    QuerySnapshot querySnapshot = await _dbServices.getClosestColabBranch(latitude, longitude,city);
    final targetGeoPoint = GeoPoint(latitude, longitude);
    querySnapshot.docs.sort((a, b) {
      final aGeoPoint = a.get('location') as GeoPoint;
      final bGeoPoint = b.get('location') as GeoPoint;
      final aDistance = distanceBetween(aGeoPoint,targetGeoPoint);
      final bDistance = distanceBetween(bGeoPoint,targetGeoPoint);
      return aDistance.compareTo(bDistance);
    });

    final closestBranches = [];
    for (final doc in querySnapshot.docs) {
      final geoPoint = doc.get('location') as GeoPoint;
      final distance = distanceBetween(targetGeoPoint, geoPoint);
      if (doc.get('geoInfo.city') == city || distance <= radius) {
        closestBranches.add(doc);
      }
    }

    List<Branch> branches =  closestBranches.map((doc) => Branch.fromSnapshot(doc)).toList();

    return branches;
  }

  Future<List<ColabFoodProduct>> getNearColabProducts(double latitude,double longitude) async {
    List<ColabFoodProduct> products=[];

    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark placemark = placemarks[0];
    String? city = placemark.locality;

    List<Branch> branches = await getClosestBranch(latitude, longitude, city!);

    for (var i = 0; i < branches.length; i++) {
      branches[i];
      List<ColabFoodProduct> branchProducts = await _dbServices.getAllBranchFoodProducts(branches[i].uid);
      if(branchProducts.length>0){
        products.addAll(branchProducts);
      }

    }

    return products;
  }



  //Surprise pack
  Future<List<SurprisePack>> getSurprisePack() async {
    Branch branch = (await _dbServices.getAllBranches()).last;
    List<SurprisePack> surprisePacks = await _dbServices.getAllSurprisePacks(branch.uid);
    print(surprisePacks.length);
    return surprisePacks;
  }

  //MealShip Product
  Future<List<FoodProduct>> getAllFoodProduct() async {
    Branch branch = (await _dbServices.getAllBranches()).last;
    List<FoodProduct> productList = await _dbServices.getAllFoodProduct(branch.uid);

    return productList;
  }


//
//  Recipes
//

  Future<List<Recipe>> getPopularRecipes() async {

    //TODO : get and filter the recipes to get popular recipes
    List<Recipe> list = await _dbServices.getPopularRecipe();

    return list;
  }
}