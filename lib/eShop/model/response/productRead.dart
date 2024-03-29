// To parse this JSON data, do
//
//     final productRead = productReadFromJson(jsonString);

// To parse this JSON data, do
//
//     final productRead = productReadFromJson(jsonString);

import 'dart:convert';

import 'package:automall/constant/images/imagePath.dart';

ProductRead productReadFromJson(String str) => ProductRead.fromJson(json.decode(str));

String productReadToJson(ProductRead data) => json.encode(data.toJson());

class ProductRead {
  List<Datum>? data;
  int? total;
  dynamic aggregateResults;
  dynamic errors;

  ProductRead({
    this.data,
    this.total,
    this.aggregateResults,
    this.errors,
  });

  factory ProductRead.fromJson(Map<String, dynamic> json) => ProductRead(
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
  String? code;
  int? productId;
  String? description;
  String? arDescription;
  int? brandId;
  int? storeQuantity;
  Brands? brands;
  List<ProductDetailsPic>? productDetailsPics;
  int? price;
  Products? products;
  Suppliers? suppliers;
  List<List<PurchaseAttributeValue>>? purchaseAttributeValues;
  String attributeValues = "";

  Datum({
    this.id,
    this.isActive,
    this.code,
    this.productId,
    this.description,
    this.arDescription,
    this.brandId,
    this.brands,
    this.productDetailsPics,
    this.price,
    this.products,
    this.suppliers,
    this.storeQuantity,
    this.purchaseAttributeValues,
  }){
    if(productDetailsPics!.length==0){
      productDetailsPics!.add(ProductDetailsPic(attachment: ImagePath.networkLogo, id: 1, productDetailsId: 1));
    }
    if(purchaseAttributeValues!=null){
      for( var att in purchaseAttributeValues!){
        for(var a in att){
          attributeValues += " ${a.purchaseAttributeValues!.val},";
        }
      }
    }
  }

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    isActive: json["isActive"],
    code: json["code"],
    productId: json["productId"],
    description: json["description"],
    storeQuantity: json["storeQuantity"],
    arDescription: json["arDescription"],
    brandId: json["brandId"],
    brands: json["brands"] == null ? null : Brands.fromJson(json["brands"]),
    productDetailsPics: json["productDetailsPics"] == null ? [] : List<ProductDetailsPic>.from(json["productDetailsPics"]!.map((x) => ProductDetailsPic.fromJson(x))),
    price: json["price"],
    products: json["products"] == null ? null : Products.fromJson(json["products"]),
    suppliers: json["suppliers"] == null ? null : Suppliers.fromJson(json["suppliers"]),
    purchaseAttributeValues: json["purchaseAttributeValues"] == null ? [] : List<List<PurchaseAttributeValue>>.from(json["purchaseAttributeValues"]!.map((x) => List<PurchaseAttributeValue>.from(x.map((x) => PurchaseAttributeValue.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "isActive": isActive,
    "code": code,
    "productId": productId,
    "description": description,
    "storeQuantity": storeQuantity,
    "arDescription": arDescription,
    "brandId": brandId,
    "brands": brands?.toJson(),
    "productDetailsPics": productDetailsPics == null ? [] : List<dynamic>.from(productDetailsPics!.map((x) => x.toJson())),
    "price": price,
    "products": products?.toJson(),
    "suppliers": suppliers?.toJson(),
    "purchaseAttributeValues": purchaseAttributeValues == null ? [] : List<dynamic>.from(purchaseAttributeValues!.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class Brands {
  int? id;
  String? name;
  int? order;
  int? brandCountryId;
  dynamic brandsCountry;
  String? logo;
  bool? isActive;
  dynamic arName;

  Brands({
    this.id,
    this.name,
    this.order,
    this.brandCountryId,
    this.brandsCountry,
    this.logo,
    this.isActive,
    this.arName,
  });

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
    id: json["id"],
    name: json["name"],
    order: json["order"],
    brandCountryId: json["brandCountryId"],
    brandsCountry: json["brandsCountry"],
    logo: json["logo"],
    isActive: json["isActive"],
    arName: json["arName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "order": order,
    "brandCountryId": brandCountryId,
    "brandsCountry": brandsCountry,
    "logo": logo,
    "isActive": isActive,
    "arName": arName,
  };
}

class ProductDetailsPic {
  int? id;
  int? productDetailsId;
  dynamic productDetails;
  String? attachment;

  ProductDetailsPic({
    this.id,
    this.productDetailsId,
    this.productDetails,
    this.attachment,
  });

  factory ProductDetailsPic.fromJson(Map<String, dynamic> json) => ProductDetailsPic(
    id: json["id"],
    productDetailsId: json["productDetailsId"],
    productDetails: json["productDetails"],
    attachment: json["attachment"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "productDetailsId": productDetailsId,
    "productDetails": productDetails,
    "attachment": attachment,
  };
}

class Products {
  int? id;
  String? name;
  String? arName;
  int? productCategoryId;
  ProductCategory? productCategory;

  Products({
    this.id,
    this.name,
    this.arName,
    this.productCategoryId,
    this.productCategory,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    name: json["name"],
    arName: json["arName"],
    productCategoryId: json["productCategoryId"],
    productCategory: json["productCategory"] == null ? null : ProductCategory.fromJson(json["productCategory"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "arName": arName,
    "productCategoryId": productCategoryId,
    "productCategory": productCategory?.toJson(),
  };
}

class ProductCategory {
  int? id;
  String? name;
  String? arName;

  ProductCategory({
    this.id,
    this.name,
    this.arName,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
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

class PurchaseAttributeValue {
  int? purchaseAttributeValuesId;
  PurchaseAttributeValues? purchaseAttributeValues;
  int? productDetailsId;
  dynamic productDetails;

  PurchaseAttributeValue({
    this.purchaseAttributeValuesId,
    this.purchaseAttributeValues,
    this.productDetailsId,
    this.productDetails,
  });

  factory PurchaseAttributeValue.fromJson(Map<String, dynamic> json) => PurchaseAttributeValue(
    purchaseAttributeValuesId: json["purchaseAttributeValuesId"],
    purchaseAttributeValues: json["purchaseAttributeValues"] == null ? null : PurchaseAttributeValues.fromJson(json["purchaseAttributeValues"]),
    productDetailsId: json["productDetailsId"],
    productDetails: json["productDetails"],
  );

  Map<String, dynamic> toJson() => {
    "purchaseAttributeValuesId": purchaseAttributeValuesId,
    "purchaseAttributeValues": purchaseAttributeValues?.toJson(),
    "productDetailsId": productDetailsId,
    "productDetails": productDetails,
  };
}

class PurchaseAttributeValues {
  int? id;
  String? val;
  String? arVal;
  int? purchaseAttributeId;
  ProductCategory? purchaseAttribute;

  PurchaseAttributeValues({
    this.id,
    this.val,
    this.arVal,
    this.purchaseAttributeId,
    this.purchaseAttribute,
  });

  factory PurchaseAttributeValues.fromJson(Map<String, dynamic> json) => PurchaseAttributeValues(
    id: json["id"],
    val: json["val"],
    arVal: json["arVal"],
    purchaseAttributeId: json["purchaseAttributeId"],
    purchaseAttribute: json["purchaseAttribute"] == null ? null : ProductCategory.fromJson(json["purchaseAttribute"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "val": val,
    "arVal": arVal,
    "purchaseAttributeId": purchaseAttributeId,
    "purchaseAttribute": purchaseAttribute?.toJson(),
  };
}

class Suppliers {
  int? id;
  String? fullName;
  String? arFullName;
  dynamic arDetails;
  dynamic details;
  int? order;
  dynamic spareParts;
  dynamic garages;
  dynamic scraps;
  dynamic batteries;
  dynamic mobiles;
  bool? orginal;
  bool? aftermarket;
  dynamic urgentBattery;
  dynamic garagBody;
  dynamic garagMechanical;
  dynamic garagElectrical;
  dynamic garagCustomization;
  dynamic rating;
  dynamic logo;
  dynamic customerId;
  dynamic user;
  dynamic accessoires;
  dynamic breakdown;
  dynamic whatsappNumber;
  dynamic carRents;
  dynamic carCare;
  List<dynamic>? supplierBrands;
  dynamic supplierGaragBrands;

  Suppliers({
    this.id,
    this.fullName,
    this.arFullName,
    this.arDetails,
    this.details,
    this.order,
    this.spareParts,
    this.garages,
    this.scraps,
    this.batteries,
    this.mobiles,
    this.orginal,
    this.aftermarket,
    this.urgentBattery,
    this.garagBody,
    this.garagMechanical,
    this.garagElectrical,
    this.garagCustomization,
    this.rating,
    this.logo,
    this.customerId,
    this.user,
    this.accessoires,
    this.breakdown,
    this.whatsappNumber,
    this.carRents,
    this.carCare,
    this.supplierBrands,
    this.supplierGaragBrands,
  });

  factory Suppliers.fromJson(Map<String, dynamic> json) => Suppliers(
    id: json["id"],
    fullName: json["fullName"],
    arFullName: json["arFullName"],
    arDetails: json["arDetails"],
    details: json["details"],
    order: json["order"],
    spareParts: json["spareParts"],
    garages: json["garages"],
    scraps: json["scraps"],
    batteries: json["batteries"],
    mobiles: json["mobiles"],
    orginal: json["orginal"],
    aftermarket: json["aftermarket"],
    urgentBattery: json["urgentBattery"],
    garagBody: json["garagBody"],
    garagMechanical: json["garagMechanical"],
    garagElectrical: json["garagElectrical"],
    garagCustomization: json["garagCustomization"],
    rating: json["rating"],
    logo: json["logo"],
    customerId: json["customerId"],
    user: json["user"],
    accessoires: json["accessoires"],
    breakdown: json["breakdown"],
    whatsappNumber: json["whatsappNumber"],
    carRents: json["carRents"],
    carCare: json["carCare"],
    supplierBrands: json["supplierBrands"] == null ? [] : List<dynamic>.from(json["supplierBrands"]!.map((x) => x)),
    supplierGaragBrands: json["supplierGaragBrands"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "arFullName": arFullName,
    "arDetails": arDetails,
    "details": details,
    "order": order,
    "spareParts": spareParts,
    "garages": garages,
    "scraps": scraps,
    "batteries": batteries,
    "mobiles": mobiles,
    "orginal": orginal,
    "aftermarket": aftermarket,
    "urgentBattery": urgentBattery,
    "garagBody": garagBody,
    "garagMechanical": garagMechanical,
    "garagElectrical": garagElectrical,
    "garagCustomization": garagCustomization,
    "rating": rating,
    "logo": logo,
    "customerId": customerId,
    "user": user,
    "accessoires": accessoires,
    "breakdown": breakdown,
    "whatsappNumber": whatsappNumber,
    "carRents": carRents,
    "carCare": carCare,
    "supplierBrands": supplierBrands == null ? [] : List<dynamic>.from(supplierBrands!.map((x) => x)),
    "supplierGaragBrands": supplierGaragBrands,
  };
}
