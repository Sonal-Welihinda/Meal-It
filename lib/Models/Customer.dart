import 'package:cloud_firestore/cloud_firestore.dart';

class Customer{
  late String _name;
  late String _email;
  late String _phoneNumber;
  late String _gender;
  late String _password;
  late String _uID;
  late String _profileImgUrl;
  late BigInt _points;


  String get uID => _uID;

  set uID(String value) {
    _uID = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get gender => _gender;

  set gender(String value) {
    _gender = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  set email(String value) {
    _email = value;
  }


  String get profileImgUrl => _profileImgUrl;

  set profileImgUrl(String value) {
    _profileImgUrl = value;
  }


  BigInt get points => _points;

  set points(BigInt value) {
    _points = value;
  }

  Customer();

  Customer.name({
    required String name,
    required String email,
    required String phoneNumber,
    required String gender,
    required String uID,
    required String profileImgUrl,
    required BigInt points
  })  : _name = name,
        _email = email,
        _phoneNumber = phoneNumber,
        _gender = gender,
        _uID = uID,
        _profileImgUrl = profileImgUrl,
        _points = points;



  Map<String , dynamic> toJson(){
    return {
      'Name': _name,
      'Email': _email,
      'phoneNumber': _email,
      'gender': _gender,
      'profileImageUrl':_profileImgUrl,
      'AccountType':"Customer",
      'points':_points.toString()
    };
  }

  factory Customer.fromSnapshot(DocumentSnapshot snapshot) {
    return Customer.name(
      uID: snapshot.id,
      email: snapshot.get("Email"),
      name: snapshot.get("Name"),
      phoneNumber: snapshot.get("phoneNumber"),
      profileImgUrl: snapshot.get("profileImageUrl"),
      gender: snapshot.get("gender"),
      points: BigInt.parse(snapshot.get("points").toString()),
    );
  }

}