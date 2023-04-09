import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_it/Interfaces/CustomerInterface.dart';
import 'package:meal_it/Models/Customer.dart';

class FirebaseDBServices extends CustomerInterface {

  final userDocRef = FirebaseFirestore.instance.collection('users');

  @override
  Customer login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
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


      await userDocRef.doc(uid).set(customer.toJson());

      return "Success";


    } on FirebaseAuthException catch (e){
      print(e);
      return "failed";
    }
  }

}