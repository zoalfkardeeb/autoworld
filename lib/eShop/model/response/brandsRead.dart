// To parse this JSON data, do
//
//     final brandsRead = brandsReadFromJson(jsonString);

import 'dart:convert';

BrandsRead brandsReadFromJson(String str) => BrandsRead.fromJson(json.decode(str));

String brandsReadToJson(BrandsRead data) => json.encode(data.toJson());

class BrandsRead {
  List<Datum>? data;
  int? total;
  dynamic aggregateResults;
  dynamic errors;

  BrandsRead({
    this.data,
    this.total,
    this.aggregateResults,
    this.errors,
  });

  factory BrandsRead.fromJson(Map<String, dynamic> json) => BrandsRead(
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
  bool? isActive;
  String? name;
  String? logo;
  int? order;
  BrandsCountry? brandsCountry;
  int? brandCountryId;

  Datum({
    this.id,
    this.isActive,
    this.name,
    this.logo,
    this.order,
    this.brandsCountry,
    this.brandCountryId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    isActive: json["isActive"],
    name: json["name"],
    logo: json["logo"],
    order: json["order"],
    brandsCountry: json["brandsCountry"] == null ? null : BrandsCountry.fromJson(json["brandsCountry"]),
    brandCountryId: json["brandCountryId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isActive": isActive,
    "name": name,
    "logo": logo,
    "order": order,
    "brandsCountry": brandsCountry?.toJson(),
    "brandCountryId": brandCountryId,
  };
}

class BrandsCountry {
  int? id;
  Name? name;
  bool? isActive;
  List<dynamic>? brands;
  dynamic arName;
  dynamic logo;
  dynamic order;

  BrandsCountry({
    this.id,
    this.name,
    this.isActive,
    this.brands,
    this.arName,
    this.logo,
    this.order,
  });

  factory BrandsCountry.fromJson(Map<String, dynamic> json) => BrandsCountry(
    id: json["id"],
    name: nameValues.map[json["name"]]!,
    isActive: json["isActive"],
    brands: json["brands"] == null ? [] : List<dynamic>.from(json["brands"]!.map((x) => x)),
    arName: json["arName"],
    logo: json["logo"],
    order: json["order"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": nameValues.reverse[name],
    "isActive": isActive,
    "brands": brands == null ? [] : List<dynamic>.from(brands!.map((x) => x)),
    "arName": arName,
    "logo": logo,
    "order": order,
  };
}

enum Name {
  CHINA,
  EUROPE,
  INDIA,
  JAPAN,
  KOREA,
  USA
}

final nameValues = EnumValues({
  "China": Name.CHINA,
  "Europe": Name.EUROPE,
  "India": Name.INDIA,
  "Japan": Name.JAPAN,
  "Korea": Name.KOREA,
  "USA": Name.USA
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
