import 'dart:convert';
import 'package:appflutterweather2/datatypes/emailtype.dart';
import 'package:appflutterweather2/datatypes/nametype.dart';
import 'package:appflutterweather2/datatypes/passwordtype.dart';
import 'package:appflutterweather2/datatypes/phonetype.dart';

class UserLogin {
  final int id;
  final EmailType email;
  final PasswordType password;
  final PhoneType phone;
  final NameType name;

  UserLogin(
      {required this.id,
      required this.email,
      required this.password,
      required this.phone,
      required this.name});

  factory UserLogin.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return UserLogin(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        name: json['name'],
        phone: json['phone']);
  }

  void printAttributes() {
    ("id: $id\n");
    ("email: $email\n");
    ("phone: $phone\n");
    ("name: $name\n");
  }
}
