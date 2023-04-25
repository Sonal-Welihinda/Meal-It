import 'package:cloud_firestore/cloud_firestore.dart';

class Branch{
  late String _uid;
  late String _companyID;
  late String _name;
  late String _phoneNumber;
  late String _address;
  late GeoPoint _location;
  late int _userCount =0;


  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get phoneNumber => _phoneNumber;


  GeoPoint get location => _location;

  set location(GeoPoint value) {
    _location = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  set phoneNumber(String value) {
    _phoneNumber = value;
  }


  int get userCount => _userCount;

  set userCount(int value) {
    _userCount = value;
  }

  Branch({ uID, required String name,
    required String address,required String phoneNumber,
    required GeoPoint location,
    String companyID="", int userCount=0
  }): _name = name,_phoneNumber= phoneNumber,_address = address,
        _location = location, _uid  = uID??="",_companyID = companyID??="", _userCount=userCount;

  Branch.createOne(this._name,this._phoneNumber,this._address,this._location,this._companyID);


  Map<String , dynamic> toJson(){
    return {
      'Name': _name,
      'address': _address,
      'phoneNumber': _phoneNumber,
      'location': _location,
      'companyID': _companyID,
      'userCount':_userCount
    };
  }

  factory Branch.fromSnapshot(DocumentSnapshot snapshot){
    return Branch(
      uID: snapshot.id,
      name: snapshot.get("Name"),
      address: snapshot.get("address"),
      phoneNumber: snapshot.get("phoneNumber"),
        location: snapshot.get("location") ,
      companyID: snapshot.data().toString().contains("companyID") ? snapshot.get("companyID"):"",
      userCount: snapshot.data().toString().contains("userCount") ? snapshot.get("userCount") : 0
    );
  }


}