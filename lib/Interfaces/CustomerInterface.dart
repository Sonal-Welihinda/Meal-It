

import 'package:meal_it/Models/Customer.dart';

abstract class CustomerInterface {
  Customer login(String email,String password);
  Future<String> registerCustomer(Customer customer) ;

}