// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? id;
  String? name;
  String? lastName;
  String? mobile;
  String? email;
  String? password;
  String? verificationCode;
  bool? isVerified;
  int? type;
  DateTime? dob;
  String? fbKey;
  String? imagePath;
  int? lang;
  dynamic lng;
  dynamic lat;
  Country? country;
  City? city;

  User({
    this.id,
    this.name,
    this.lastName,
    this.mobile,
    this.email,
    this.password,
    this.verificationCode,
    this.isVerified,
    this.type,
    this.dob,
    this.fbKey,
    this.imagePath,
    this.lang,
    this.lng,
    this.lat,
    this.country,
    this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    lastName: json["lastName"],
    mobile: json["mobile"],
    email: json["email"],
    password: json["password"],
    verificationCode: json["verificationCode"],
    isVerified: json["isVerified"],
    type: json["type"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    fbKey: json["fbKey"],
    imagePath: json["imagePath"],
    lang: json["lang"],
    lng: json["lng"],
    lat: json["lat"],
    country: json["country"] == null ? null : Country.fromJson(json["country"]),
    city: json["city"] == null ? null : City.fromJson(json["city"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "lastName": lastName,
    "mobile": mobile,
    "email": email,
    "password": password,
    "verificationCode": verificationCode,
    "isVerified": isVerified,
    "type": type,
    "dob": dob?.toIso8601String(),
    "fbKey": fbKey,
    "imagePath": imagePath,
    "lang": lang,
    "lng": lng,
    "lat": lat,
    "country": country?.toJson(),
    "city": city?.toJson(),
  };
}

class City {
  int? id;
  String? name;
  int? countryId;
  bool? isActive;
  dynamic arName;
  dynamic country;
  List<dynamic>? users;

  City({
    this.id,
    this.name,
    this.countryId,
    this.isActive,
    this.arName,
    this.country,
    this.users,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
    countryId: json["countryId"],
    isActive: json["isActive"],
    arName: json["arName"],
    country: json["country"],
    users: json["users"] == null ? [] : List<dynamic>.from(json["users"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "countryId": countryId,
    "isActive": isActive,
    "arName": arName,
    "country": country,
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
  };
}

class Country {
  int? id;
  String? name;
  bool? isActive;
  List<dynamic>? city;
  List<dynamic>? users;

  Country({
    this.id,
    this.name,
    this.isActive,
    this.city,
    this.users,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    isActive: json["isActive"],
    city: json["city"] == null ? [] : List<dynamic>.from(json["city"]!.map((x) => x)),
    users: json["users"] == null ? [] : List<dynamic>.from(json["users"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "isActive": isActive,
    "city": city == null ? [] : List<dynamic>.from(city!.map((x) => x)),
    "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
  };
}
