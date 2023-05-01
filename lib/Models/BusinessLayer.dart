import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meal_it/Models/Branch.dart';
import 'package:meal_it/Models/CartModel.dart';
import 'package:meal_it/Models/Customer.dart';
import 'package:meal_it/Models/Recipe.dart';
import 'package:meal_it/Models/SaveCustomerDataStatic.dart';
import 'package:meal_it/Models/SurprisePack.dart';
import 'package:meal_it/Services/FirebaseDBServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ColabFoodProduct.dart';
import 'CustomerOrder.dart';
import 'DispatchTimes.dart';
import 'FoodCategory.dart';
import 'FoodProduct.dart';
import 'IngredientItem.dart';

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


  //Colab products
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

  Future<ColabFoodProduct?> getColabFoodProductById(String foodID) async {
    ColabFoodProduct? colabFoodProduct = await _dbServices.getColabFoodProductById(foodID);

    return colabFoodProduct;
  }



  //Surprise pack
  Future<List<SurprisePack>> getSurprisePack() async {
    //TODO get correct branch
    Branch branch = (await _dbServices.getAllBranches()).last;
    List<SurprisePack> surprisePacks = await _dbServices.getAllSurprisePacks(branch.uid);
    print(surprisePacks.length);
    return surprisePacks;
  }

  Future<SurprisePack?> getSurprisePackByID(String surprisePackID) async {
    SurprisePack? surprisePacks = await _dbServices.getSurprisePackByID(surprisePackID);
    return surprisePacks;
  }

  //MealShip Product
  Future<List<FoodProduct>> getAllFoodProduct() async {
    //TODO get correct branch
    Branch branch = (await _dbServices.getAllBranches()).last;
    List<FoodProduct> productList = await _dbServices.getAllFoodProduct(branch.uid);

    return productList;
  }

  Future<FoodProduct?> getFoodProductByID(String foodID) async {
    FoodProduct? foodProduct = await _dbServices.getFoodProductByID(foodID);

    return foodProduct;
  }

//
//  Recipes
//

  Future<List<Recipe>> getPopularRecipes() async {

    //TODO : get and filter the recipes to get popular recipes
    List<Recipe> list = await _dbServices.getPopularRecipe();

    return list;
  }


//
// Save Recipes
//

  Future<String> addSaveRecipe(Recipe recipe) async {
    prefs ??= await SharedPreferences.getInstance();
    String userID = await loadSavedValue("UserID");

    if(userID.trim().isEmpty){
      return "failed";
    }
    String result = await _dbServices.addSaveRecipe(userID,recipe);

    // Add item to SharedPreference
    List<String>? wishlist = [];
    String? wishlistString = prefs?.getString('wishlist');
    if (wishlistString != null) {

      wishlist = (json.decode(wishlistString)).toList();
    }
    wishlist?.add(recipe.docID!);
    prefs?.setString('wishlist', json.encode(wishlist));



    return result;
  }


  List<String>getWishlist() {
    List<String>? wishlist = [];
    String? wishlistString = prefs?.getString('wishlist');
    if (wishlistString != null) {
      wishlist = (json.decode(wishlistString) as List).map((i) => i.toString()).toList();
    }

    return wishlist!;
  }

  bool isItAlreadyInSavedList(String recipeID){
    List<String> recipesID = getWishlist();
    List<String> result1 = recipesID.where((element) => element ==recipeID).toList();

    // Recipe result = recipes.firstWhere((element) => element.docID ==recipeID);

    return result1.isNotEmpty;
  }


  // Function to load the list of wishlist items from Firebase
  void loadWishlistFromFirebase() async {
    String userID = await loadSavedValue("UserID");
    List<String>? saveRecipeIds =[];
    List<Recipe> saveRecipes = await _dbServices.getSavedRecipes(userID);
    saveRecipeIds = saveRecipes.map((e) => e.docID.toString()).toList();

    // Compare the Firebase list with the SharedPreference list to ensure they are in sync
    // List<Recipe> localWishlist = getWishlist();

    prefs?.setString('wishlist', json.encode(saveRecipeIds));

  }


  // Function to remove an item from the wishlist
  Future<String> removeFromWishlist(Recipe recipe) async {
    // Remove item from Firebase
    String userID = await loadSavedValue("UserID");
    String result = await  _dbServices.removeSaveRecipe(userID, recipe.docID!);

    // Remove item from SharedPreference
    List<String> wishlist = [];
    String? wishlistString = prefs?.getString('wishlist');
    if (wishlistString != null) {
      wishlist = (json.decode(wishlistString) as List).map((i) => i.toString()).toList();
    }
    wishlist.removeWhere((i) => i.toString() == recipe.docID!);
    prefs?.setString('wishlist', json.encode(wishlist));

    return result;
  }


  Future<String> addToCart({SurprisePack? pack,ColabFoodProduct? colabFoodProduct,FoodProduct? mealShipProduct}) async{

    Map<String,dynamic> productData;

    String userID = await loadSavedValue("UserID");
    String productID;

    if (pack != null && colabFoodProduct == null && mealShipProduct == null) {
      productData = pack.toJson();
      productID = pack.docID;
      productData["ProductType"]="Pack";
    } else if (pack == null && colabFoodProduct != null && mealShipProduct == null) {
      productID = colabFoodProduct.productId;
      productData = colabFoodProduct.toJson();
      productData["ProductType"]="ColabProduct";

    } else if (pack == null && colabFoodProduct == null && mealShipProduct != null) {
      productID = mealShipProduct.docID;
      productData = mealShipProduct.toJson();
      productData["ProductType"]="MealShipProduct";
    } else {
      return "failed";
    }

    String result = await _dbServices.addToCart(userID, productData,productID);


    return result;
  }

  Future<String> updateToCart({SurprisePack? pack,ColabFoodProduct? colabFoodProduct,FoodProduct? mealShipProduct}) async{

    Map<String,dynamic> productData;

    String userID = await loadSavedValue("UserID");
    String productID;

    if (pack != null && colabFoodProduct == null && mealShipProduct == null) {
      productData = pack.toJson();
      productID = pack.docID;
      productData["ProductType"]="Pack";
    } else if (pack == null && colabFoodProduct != null && mealShipProduct == null) {
      productID = colabFoodProduct.productId;
      productData = colabFoodProduct.toJson();
      productData["ProductType"]="ColabProduct";

    } else if (pack == null && colabFoodProduct == null && mealShipProduct != null) {
      productID = mealShipProduct.docID;
      productData = mealShipProduct.toJson();
      productData["ProductType"]="MealShipProduct";
    } else {
      return "failed";
    }

    String result = await _dbServices.updateToCart(userID, productData,productID);


    return result;
  }

  Future<CartModel> getCart() async {
    CartModel cartModel =CartModel();
    String userID = await loadSavedValue("UserID");

    List<DocumentSnapshot> docus = await _dbServices.getCartList(userID);

    for (DocumentSnapshot document in docus) {
      // access individual document fields
      String type = document.get("ProductType");

      if(type== "Pack"){
        cartModel.surpriseList.add(SurprisePack.fromSnapshot(document));
      }

      if(type=="ColabProduct"){
        cartModel.colabFoodProduct.add(ColabFoodProduct.fromSnapshot(document));
      }

      if(type == "MealShipProduct"){
        cartModel.foodProduct.add(FoodProduct.fromSnapshot(document));
      }
    }

    return cartModel;

  }


  Future<List<DispatchTimes>> getAllActiveDispatchTimes() async{
    return _dbServices.getAllActiveDeliveryDispatch();
  }

  // Calculate distance between two locations
  double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distanceInMeters / 1000; // Convert to kilometers
  }

// Calculate delivery fee based on distance
  double calculateDeliveryFee(double distance) {
    const double firstKmFee = 150.0; // Fixed fee for the first kilometer
    const double additionalKmFee = 120.0; // Fixed fee for each additional kilometer
    const int firstKm = 1000; // Number of meters in the first kilometer

    // Calculate the number of additional kilometers beyond the first kilometer
    double additionalKms = (distance - firstKm) / 1000;

    // Calculate the delivery fee
    double deliveryFee = firstKmFee + (additionalKms * additionalKmFee);

    return deliveryFee;
  }




  Future<double> getCalculateDeliveryPrice(GeoPoint userLocation) async {
    double totalDistance = 0;
    double totalDeliveryFee = 0;
    List<GeoPoint> locations = [];
    List<String> colabBranchIDs=[];
    List<Branch> colabBranches=[];
    Branch branches;
    CartModel cart = await getCart();

    branch = (await _dbServices.getAllBranches()).last;

    locations.add(branch.location);

    for(var colabFood in cart.colabFoodProduct){
      colabBranchIDs.add(colabFood.branchID);
    }

    for(var colabBranchID in colabBranchIDs){
      Branch branch = await _dbServices.getColabBranchByID(colabBranchID);
      colabBranches.add(branch);
    }

    for(var branch in colabBranches){
      locations.add(branch.location);
    }

    locations.add(userLocation);

    for (int i = 0; i < locations.length - 1; i++) {
      final currentLocation = locations[i];
      final nextLocation = i < locations.length - 1 ? locations[i + 1] : null;

      if(nextLocation==null){
        break;
      }

      double segmentDistance = calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        nextLocation.latitude,
        nextLocation.longitude,
      );
      double segmentDeliveryFee = calculateDeliveryFee(segmentDistance);

      totalDistance += segmentDistance;
      totalDeliveryFee += segmentDeliveryFee;
    }

    // if (totalDistance > 0) {
    //   totalDeliveryFee += 500;
    // }

    return totalDeliveryFee;

  }


  Future<String> addOrder(String address,GeoPoint location) async {
    //TODO check if there is available stocks
    CustomerOrder order = CustomerOrder.empty();
    Customer customer = await getCustomerData();

    order.customerID = customer.uID;
    order.customerName = customer.name;
    order.customerEmail = customer.email;
    order.customerNumber = customer.phoneNumber;
    order.orderItems = await getCart();
    order.address = address;
    order.deliveryFee = await getCalculateDeliveryPrice(location);
    order.location = location;
    order.orderPlaceTime = DateTime.now();
    order.status = "Waiting for driver";
    //SDelivery = standard , TDelivery = Time Delivery
    order.deliveryType = order.orderItems.colabFoodProduct.isEmpty ? "SDelivery":"TDelivery";


    List<bool> notEnoughQuantity = [];
    List<bool> productRemoveFromCart=[];

    List<FoodProduct> products = order.orderItems.foodProduct;
    for(var product in products){
      FoodProduct? productInfo = await _dbServices.getFoodProductByID(product.docID);

      if(productInfo == null){
        await _dbServices.removeCartItem(customer.uID, product.docID);
        productRemoveFromCart.add(true);
      }

      //null check
      if(product.quantity<productInfo!.quantity){

      }else{
        //Remove the product from the cart
        if(productInfo.quantity == BigInt.zero){
          await _dbServices.removeCartItem(customer.uID, product.docID);
          productRemoveFromCart.add(true);
        }
        product.quantity = productInfo.quantity;
        if(productInfo.quantity> BigInt.zero){
          await updateToCart(mealShipProduct: product);
          notEnoughQuantity.add(true);
        }

      //  update the product quantity
      //  return
      }
    }

    List<ColabFoodProduct> colabProducts = order.orderItems.colabFoodProduct;
    for(var product in colabProducts){
      ColabFoodProduct? productInfo = await _dbServices.getColabFoodProductById(product.productId);
      //null check
      if(productInfo == null){
        await _dbServices.removeCartItem(customer.uID, product.productId);
        productRemoveFromCart.add(true);
      }

      //Check if it within the time range

      //TODO need to remove product if time is expired
      if(product.offerEndTime.toDate().isBefore(DateTime.now())){
        await _dbServices.removeCartItem(customer.uID, product.productId);
      }

      if(product.quantity<productInfo!.quantity){

      }else{
        //Remove the product from the cart
        if(productInfo.quantity == 0){
          await _dbServices.removeCartItem(customer.uID, product.productId);
          productRemoveFromCart.add(true);
        }
        product.quantity = productInfo.quantity;
        if(productInfo.quantity> 0){
          await updateToCart(colabFoodProduct: product);
          notEnoughQuantity.add(true);
        }
      }



    }

    List<SurprisePack> surprisePacks = order.orderItems.surpriseList;
    for(var pack in surprisePacks){
      SurprisePack? productInfo = await _dbServices.getSurprisePackByID(pack.docID);

      //Null Check - checking if the product exist on the database
      if(productInfo == null){
        await _dbServices.removeCartItem(customer.uID, pack.docID);
        productRemoveFromCart.add(true);

      }

      if(pack.quantity<productInfo!.quantity){

      }else{
        //Remove the product from the cart
        if(productInfo.quantity == BigInt.zero){
          await _dbServices.removeCartItem(customer.uID, pack.docID);
          productRemoveFromCart.add(true);
        }
        pack.quantity = productInfo.quantity;
        if(productInfo.quantity> BigInt.zero){
          await updateToCart(pack: pack);
          notEnoughQuantity.add(true);
        }

        //  update the product quantity
        //  return
      }
    }


    if(notEnoughQuantity.isNotEmpty || productRemoveFromCart.isNotEmpty){
      String msg = "failed,${notEnoughQuantity.isNotEmpty ? ",Quantity have change according to availble stocks":""}"
          " ${ productRemoveFromCart.isNotEmpty ? ",None existing products are removes":""} ";

      return msg;
    }


    return "";
  }


}