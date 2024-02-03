// To parse this JSON data, do
//
//     final orderRead = orderReadFromJson(jsonString);

import 'dart:convert';

import 'package:automall/constant/images/imagePath.dart';
import 'package:automall/eShop/model/response/productRead.dart';

OrderRead orderReadFromJson(String str) => OrderRead.fromJson(json.decode(str));

String orderReadToJson(OrderRead data) => json.encode(data.toJson());

class OrderRead {
  List<Datum>? data;
  int? total;
  dynamic aggregateResults;
  dynamic errors;

  OrderRead({
    this.data,
    this.total,
    this.aggregateResults,
    this.errors,
  });

  factory OrderRead.fromJson(Map<String, dynamic> json) => OrderRead(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        total: json["total"],
        aggregateResults: json["aggregateResults"],
        errors: json["errors"],
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
        "aggregateResults": aggregateResults,
        "errors": errors,
      };
}

class Datum {
  String? id;
  String? deliveryUserId;
  dynamic deliveryNote;
  DateTime? deliveryEndDate;
  DateTime? deliveryStartDate;
  String? codeSerial;
  int? price;
  int? quantity;
  dynamic score;
  dynamic scoreNote;
  int? status;
  PurchaseOrder? purchaseOrder;
  Delivery? delivery;
  List<dynamic>? purchaseOrderProductsAttr;
  ProductDetails? productDetails;

  Datum({
    this.id,
    this.deliveryUserId,
    this.deliveryNote,
    this.deliveryEndDate,
    this.deliveryStartDate,
    this.codeSerial,
    this.price,
    this.quantity,
    this.score,
    this.scoreNote,
    this.status,
    this.purchaseOrder,
    this.delivery,
    this.purchaseOrderProductsAttr,
    this.productDetails,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        deliveryUserId: json["deliveryUserId"],
        deliveryNote: json["deliveryNote"],
        deliveryEndDate: json["deliveryEndDate"] == null
            ? null
            : DateTime.parse(json["deliveryEndDate"]),
        deliveryStartDate: json["deliveryStartDate"] == null
            ? null
            : DateTime.parse(json["deliveryStartDate"]),
        codeSerial: json["codeSerial"],
        price: json["price"],
        quantity: json["quantity"],
        score: json["score"],
        scoreNote: json["scoreNote"],
        status: json["status"],
        purchaseOrder: json["purchaseOrder"] == null
            ? null
            : PurchaseOrder.fromJson(json["purchaseOrder"]),
        delivery: json["delivery"] == null
            ? null
            : Delivery.fromJson(json["delivery"]),
        purchaseOrderProductsAttr: json["purchaseOrderProductsAttr"] == null
            ? []
            : List<dynamic>.from(
                json["purchaseOrderProductsAttr"]!.map((x) => x)),
        productDetails: json["productDetails"] == null
            ? null
            : ProductDetails.fromJson(json["productDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "deliveryUserId": deliveryUserId,
        "deliveryNote": deliveryNote,
        "deliveryEndDate": deliveryEndDate?.toIso8601String(),
        "deliveryStartDate": deliveryStartDate?.toIso8601String(),
        "codeSerial": codeSerial,
        "price": price,
        "quantity": quantity,
        "score": score,
        "scoreNote": scoreNote,
        "status": status,
        "purchaseOrder": purchaseOrder?.toJson(),
        "delivery": delivery?.toJson(),
        "purchaseOrderProductsAttr": purchaseOrderProductsAttr == null
            ? []
            : List<dynamic>.from(purchaseOrderProductsAttr!.map((x) => x)),
        "productDetails": productDetails?.toJson(),
      };
}

class Delivery {
  String? id;
  String? name;
  String? lastName;
  String? mobile;
  String? email;
  dynamic password;
  dynamic verificationCode;
  bool? isVerified;
  int? type;
  dynamic dob;
  String? imagePath;
  dynamic file;
  dynamic eventDate;
  String? fbKey;
  dynamic lang;
  int? countryId;
  dynamic country;
  int? cityId;
  dynamic city;
  dynamic lat;
  dynamic lng;

  Delivery({
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

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
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

class ProductDetails {
  int? id;
  int? productId;
  Products? products;
  int? supplierId;
  Suppliers? suppliers;
  int? price;
  String? code;
  bool? isActive;
  int? brandId;
  Brands? brands;
  String? description;
  String? arDescription;
  int? storeQuantity;
  List<ProductDetailsPic>? productDetailsPics;

  ProductDetails({
    this.id,
    this.productId,
    this.products,
    this.supplierId,
    this.suppliers,
    this.price,
    this.code,
    this.isActive,
    this.brandId,
    this.brands,
    this.description,
    this.arDescription,
    this.storeQuantity,
    this.productDetailsPics,
  }) {
    if (productDetailsPics!.isEmpty) {
      productDetailsPics!.add(
          ProductDetailsPic(attachment: ImagePath.networkLogo, id: 123456));
    }
  }

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        id: json["id"],
        productId: json["productId"],
        products: json["products"] == null
            ? null
            : Products.fromJson(json["products"]),
        supplierId: json["supplierId"],
        suppliers: json["suppliers"] == null
            ? null
            : Suppliers.fromJson(json["suppliers"]),
        price: json["price"],
        code: json["code"],
        isActive: json["isActive"],
        brandId: json["brandId"],
        brands: json["brands"] == null ? null : Brands.fromJson(json["brands"]),
        description: json["description"],
        arDescription: json["arDescription"],
        storeQuantity: json["storeQuantity"],
        productDetailsPics: json["productDetailsPics"] == null
            ? []
            : List<ProductDetailsPic>.from(json["productDetailsPics"]!
                .map((x) => ProductDetailsPic.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "productId": productId,
        "products": products?.toJson(),
        "supplierId": supplierId,
        "suppliers": suppliers?.toJson(),
        "price": price,
        "code": code,
        "isActive": isActive,
        "brandId": brandId,
        "brands": brands?.toJson(),
        "description": description,
        "arDescription": arDescription,
        "storeQuantity": storeQuantity,
        "productDetailsPics": productDetailsPics == null
            ? []
            : List<dynamic>.from(productDetailsPics!.map((x) => x.toJson())),
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
        productCategory: json["productCategory"] == null
            ? null
            : ProductCategory.fromJson(json["productCategory"]),
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

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
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

class PurchaseOrder {
  String? id;
  String? customerId;
  int? amount;
  DateTime? insertDate;
  int? serial;
  int? payType;
  String? addressId;
  DateTime? orderDate;
  dynamic notes;
  dynamic endDate;
  Delivery? user;
  ProfileAddress? profileAddress;

  PurchaseOrder({
    this.id,
    this.customerId,
    this.amount,
    this.insertDate,
    this.serial,
    this.payType,
    this.addressId,
    this.orderDate,
    this.notes,
    this.endDate,
    this.user,
    this.profileAddress,
  });

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
        id: json["id"],
        customerId: json["customerId"],
        amount: json["amount"],
        insertDate: json["insertDate"] == null
            ? null
            : DateTime.parse(json["insertDate"]),
        serial: json["serial"],
        payType: json["payType"],
        addressId: json["addressId"],
        orderDate: json["orderDate"] == null
            ? null
            : DateTime.parse(json["orderDate"]),
        notes: json["notes"],
        endDate: json["endDate"],
        user: json["user"] == null ? null : Delivery.fromJson(json["user"]),
        profileAddress: json["profileAddress"] == null
            ? null
            : ProfileAddress.fromJson(json["profileAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerId": customerId,
        "amount": amount,
        "insertDate": insertDate?.toIso8601String(),
        "serial": serial,
        "payType": payType,
        "addressId": addressId,
        "orderDate": orderDate?.toIso8601String(),
        "notes": notes,
        "endDate": endDate,
        "user": user?.toJson(),
        "profileAddress": profileAddress?.toJson(),
      };
}

class ProfileAddress {
  String? id;
  String? userId;
  double? lat;
  double? lng;
  String? title;
  String? notes;
  String? building;
  String? floor;
  String? appartment;
  dynamic user;

  ProfileAddress({
    this.id,
    this.userId,
    this.lat,
    this.lng,
    this.title,
    this.notes,
    this.building,
    this.floor,
    this.appartment,
    this.user,
  });

  factory ProfileAddress.fromJson(Map<String, dynamic> json) => ProfileAddress(
        id: json["id"],
        userId: json["userId"],
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
        title: json["title"],
        notes: json["notes"],
        building: json["building"],
        floor: json["floor"],
        appartment: json["appartment"],
        user: json["user"],
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
        "user": user,
      };
}
