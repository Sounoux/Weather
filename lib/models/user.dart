import 'dart:convert';

import 'package:appflutterweather2/datatypes/nametype.dart';
import 'package:appflutterweather2/datatypes/phonetype.dart';

class User {
  final int id;
  final String email;
  final PhoneType phone;
  final NameType name;

  User(
      {required this.id,
      required this.email,
      required this.phone,
      required this.name});

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return User(
        id: json['id'],
        email: json['email'],
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
