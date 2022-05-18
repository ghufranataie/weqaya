import 'dart:convert';

MenuModel medicalTestModelFromJson(String str) => MenuModel.fromJson(json.decode(str));
String medicalTestModelToJson(MenuModel data) => json.encode(data.toJson());

class MenuModel {
  MenuModel({
    required this.title,
    required this.slogan,
    required this.icon,
    required this.verify,
    required this.color,
    required this.short,
    //required this.dateTime,
  });

  String title;
  String slogan;
  String icon;
  bool verify;
  String color;
  String short;
  //String dateTime;

  factory MenuModel.fromJson( json) => MenuModel(
    title: json["title"],
    slogan: json["slogan"],
    icon: json["icon"],
    verify: json["verify"],
    color: json["color"],
    short: json["short"],
    //dateTime: json["dateTime"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "slogan": slogan,
    "icon": icon,
    "verify": verify,
    "color": color,
    "short": short,
    //"dateTime": dateTime,
  };
}
