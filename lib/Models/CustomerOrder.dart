import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meal_it/Models/CartModel.dart';

class CustomerOrder {
  late String orderID;
  late String customerName;
  late String customerEmail;
  late String customerNumber;
  late CartModel orderItems;
  late String address;
  late GeoPoint location;
  late DateTime orderPlaceTime;
  late String status;
  late double deliveryFee;
  late String deliveryType;
  late String deliveryTimeID;
  late String customerID;
  late String paymentID;


  CustomerOrder.empty();

  Map<String, dynamic> toJson() => {
    'orderID': orderID,
    'customerName': customerName,
    'customerEmail': customerEmail,
    'customerNumber': customerNumber,
    'orderItems': orderItems.toJson(),
    'address': address,
    'location': location,
    'orderPlaceTime': Timestamp.fromDate(orderPlaceTime),
    'status': status,
    'deliveryFee': deliveryFee,
    'deliveryType': deliveryType,
    'deliveryTimeID': deliveryTimeID,
    'customerID': customerID,
    'paymentID': paymentID,
  };

  static CustomerOrder fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return CustomerOrder.empty()
      ..orderID = data['orderID']
      ..customerName = data['customerName']
      ..customerEmail = data['customerEmail']
      ..customerNumber = data['customerNumber']
      ..orderItems = CartModel.fromSnapshot(data['orderItems'])
      ..address = data['address']
      ..location = data['location']
      ..orderPlaceTime = (data['orderPlaceTime'] as Timestamp).toDate()
      ..status = data['status']
      ..deliveryFee = data['deliveryFee']
      ..deliveryType = data['deliveryType']
      ..deliveryTimeID = data['deliveryTimeID']
      ..customerID = data['customerID']
      ..paymentID = data['paymentID'];
  }
}
