import 'package:flutter/material.dart';

class PrimaryColor {
  final String name;
  final Color color;

  const PrimaryColor(this.name, this.color);

  static const values = [
    PrimaryColor('Pink', Colors.pink),
    PrimaryColor('Green', Colors.green),
    PrimaryColor('Blue', Colors.blue),
    PrimaryColor('Yellow ', Colors.yellow),
    PrimaryColor('Red', Colors.red),
    PrimaryColor('Orange', Colors.orange),
    PrimaryColor('Deep Orange', Colors.deepOrange),

    // PrimaryColor('Pink Accent', Colors.pinkAccent),
    // PrimaryColor('Green Accent', Colors.greenAccent),
    // PrimaryColor('Blue Accent', Colors.blueAccent),
    // PrimaryColor('Yello Accent ', Colors.yellowAccent),
    // PrimaryColor('Red Accent', Colors.redAccent),
    // PrimaryColor('Orange Accent', Colors.orangeAccent),
    // PrimaryColor('Deep Orange Accent', Colors.deepOrangeAccent),
  ];

  Map<String, String> toJson() {
    return {'name': name};
  }

  factory PrimaryColor.fromJson(dynamic json) {
    return values
        .firstWhere((element) => element.name == json['name'].toString());
  }
}
