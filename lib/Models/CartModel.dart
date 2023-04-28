import 'package:meal_it/Models/SurprisePack.dart';

import 'ColabFoodProduct.dart';
import 'FoodProduct.dart';

class CartModel{
  List<SurprisePack> surpriseList=[];
  List<FoodProduct> foodProduct=[];
  List<ColabFoodProduct> colabFoodProduct=[];

  BigInt getTotal(){
    BigInt total = BigInt.zero;

    surpriseList.forEach((element) {
      total += element.price*element.quantity;
    });

    foodProduct.forEach((element) {
      total += element.price*element.quantity;
    });

    colabFoodProduct.forEach((element) {
      total += element.price*BigInt.from(element.quantity);
    });

    return total;
  }

}