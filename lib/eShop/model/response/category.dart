// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  List<Datum>? data;
  int? total;
  dynamic aggregateResults;
  dynamic errors;

  Category({
    this.data,
    this.total,
    this.aggregateResults,
    this.errors,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
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
  int? id;
  String? name;
  String? arName;

  Datum({
    this.id,
    this.name,
    this.arName,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    arName: json["arName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "arName": arName,
  };
}
