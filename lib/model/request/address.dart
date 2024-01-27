// To parse this JSON data, do
//
//     final addressRequest = addressRequestFromJson(jsonString);

import 'dart:convert';

AddressRequest addressRequestFromJson(String str) => AddressRequest.fromJson(json.decode(str));

String addressRequestToJson(AddressRequest data) => json.encode(data.toJson());

class AddressRequest {
  String? id;
  String? userId;
  String? lat;
  String? lng;
  String? title;
  String? notes;
  String? building;
  String? floor;
  String? appartment;
  String? street;

  AddressRequest({
    this.id,
    this.userId,
    this.lat,
    this.lng,
    this.title,
    this.notes,
    this.building,
    this.floor,
    this.appartment,
    this.street,
  });

  factory AddressRequest.fromJson(Map<String, dynamic> json) => AddressRequest(
    id: json["id"],
    userId: json["userId"],
    lat: json["lat"],
    lng: json["lng"],
    title: json["title"],
    notes: json["notes"],
    building: json["building"],
    floor: json["floor"],
    appartment: json["appartment"],
    street: json["street"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "lat": lat,
    "lng": lng,
    "title": title,
    "notes": notes,
    "building": building,
    "floor": floor,
    "appartment": appartment,
    "street": street,
  };
}
