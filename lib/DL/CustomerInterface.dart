import 'package:meal_it/Models/Customer.dart';
import 'package:meal_it/Models/SurprisePack.dart';

import '../Models/Branch.dart';
import '../Models/FoodProduct.dart';

abstract class CustomerInterface {
  Customer login(String email,String password);
  Future<String> registerCustomer(Customer customer) ;


  //Branch
  Future<List<Branch>> getAllBranches();


  //SurprisePack
  Future<List<SurprisePack>> getAllSurprisePacks(String branchID);


  //Meal ship Products
  Future<List<FoodProduct>> getAllFoodProduct(String branchID);

}