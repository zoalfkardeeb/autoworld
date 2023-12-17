// To parse this JSON data, do
//
//     final addressRead = addressReadFromJson(jsonString);

import 'dart:convert';

AddressRead addressReadFromJson(String str) => AddressRead.fromJson(json.decode(str));

String addressReadToJson(AddressRead data) => json.encode(data.toJson());

class AddressRead {
  List<Datum>? data;
  int? total;
  dynamic aggregateResults;
  dynamic errors;

  AddressRead({
    this.data,
    this.total,
    this.aggregateResults,
    this.errors,
  });

  factory AddressRead.fromJson(Map<String, dynamic> json) => AddressRead(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    total: json["total"],
    aggregateResults: json["aggregateResults"],
    errors: json["errors"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total": total,
    "aggregateResults": aggregateResults,
    "errors": errors,
  };
}

class Datum {
  String? id;
  String? userId;
  Users? users;
  String? notes;
  String? building;
  String? floor;
  String? appartment;
  int? lat;
  int? lng;
  String? title;

  Datum({
    this.id,
    this.userId,
    this.users,
    this.notes,
    this.building,
    this.floor,
    this.appartment,
    this.lat,
    this.lng,
    this.title,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["userId"],
    users: json["users"] == null ? null : Users.fromJson(json["users"]),
    notes: json["notes"],
    building: json["building"],
    floor: json["floor"],
    appartment: json["appartment"],
    lat: json["lat"],
    lng: json["lng"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "users": users?.toJson(),
    "notes": notes,
    "building": building,
    "floor": floor,
    "appartment": appartment,
    "lat": lat,
    "lng": lng,
    "title": title,
  };
}

class Users {
  String? id;
  String? name;
  String? lastName;
  String? mobile;
  String? email;
  String? password;
  String? verificationCode;
  bool? isVerified;
  int? type;
  dynamic dob;
  dynamic imagePath;
  dynamic file;
  dynamic eventDate;
  dynamic fbKey;
  dynamic lang;
  dynamic countryId;
  dynamic country;
  dynamic cityId;
  dynamic city;
  dynamic lat;
  dynamic lng;

  Users({
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
    this.imagePath,
    this.file,
    this.eventDate,
    this.fbKey,
    this.lang,
    this.countryId,
    this.country,
    this.cityId,
    this.city,
    this.lat,
    this.lng,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    id: json["id"],
    name: json["name"],
    lastName: json["lastName"],
    mobile: json["mobile"],
    email: json["email"],
    password: json["password"],
    verificationCode: json["verificationCode"],
    isVerified: json["isVerified"],
    type: json["type"],
    dob: json["dob"],
    imagePath: json["imagePath"],
    file: json["file"],
    eventDate: json["eventDate"],
    fbKey: json["fbKey"],
    lang: json["lang"],
    countryId: json["countryId"],
    country: json["country"],
    cityId: json["cityId"],
    city: json["city"],
    lat: json["lat"],
    lng: json["lng"],
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
    "dob": dob,
    "imagePath": imagePath,
    "file": file,
    "eventDate": eventDate,
    "fbKey": fbKey,
    "lang": lang,
    "countryId": countryId,
    "country": country,
    "cityId": cityId,
    "city": city,
    "lat": lat,
    "lng": lng,
  };
}
