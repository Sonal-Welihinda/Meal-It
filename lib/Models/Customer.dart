class Customer{
  late String _name;
  late String _email;
  late String _phoneNumber;
  late String _gender;
  late String _password;
  late String _uID;


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

  Map<String , dynamic> toJson(){
    return {
      'Name': _name,
      'Email': _email,
      'phoneNumber': _email,
      'gender': _gender,

    };
  }
}