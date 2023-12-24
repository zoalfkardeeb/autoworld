// To parse this JSON data, do
//
//     final orderRead = orderReadFromJson(jsonString);

import 'dart:convert';
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
  dynamic deliveryUserId;
  dynamic deliveryNote;
  dynamic deliveryEndDate;
  dynamic deliveryStartDate;
  String? codeSerial;
  int? price;
  int? quantity;
  dynamic score;
  dynamic scoreNote;
  PurchaseOrder? purchaseOrder;
  dynamic delivery;
  List<PurchaseOrderProductsAttr>? purchaseOrderProductsAttr;
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
    this.purchaseOrder,
    this.delivery,
    this.purchaseOrderProductsAttr,
    this.productDetails,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    deliveryUserId: json["deliveryUserId"],
    deliveryNote: json["deliveryNote"],
    deliveryEndDate: json["deliveryEndDate"],
    deliveryStartDate: json["deliveryStartDate"],
    codeSerial: json["codeSerial"],
    price: json["price"],
    quantity: json["quantity"],
    score: json["score"],
    scoreNote: json["scoreNote"],
    purchaseOrder: json["purchaseOrder"] == null ? null : PurchaseOrder.fromJson(json["purchaseOrder"]),
    delivery: json["delivery"],
    purchaseOrderProductsAttr: json["purchaseOrderProductsAttr"] == null ? [] : List<PurchaseOrderProductsAttr>.from(json["purchaseOrderProductsAttr"]!.map((x) => PurchaseOrderProductsAttr.fromJson(x))),
    productDetails: json["productDetails"] == null ? null : ProductDetails.fromJson(json["productDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "deliveryUserId": deliveryUserId,
    "deliveryNote": deliveryNote,
    "deliveryEndDate": deliveryEndDate,
    "deliveryStartDate": deliveryStartDate,
    "codeSerial": codeSerial,
    "price": price,
    "quantity": quantity,
    "score": score,
    "scoreNote": scoreNote,
    "purchaseOrder": purchaseOrder?.toJson(),
    "delivery": delivery,
    "purchaseOrderProductsAttr": purchaseOrderProductsAttr == null ? [] : List<dynamic>.from(purchaseOrderProductsAttr!.map((x) => x.toJson())),
    "productDetails": productDetails?.toJson(),
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
    this.productDetailsPics,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
    id: json["id"],
    productId: json["productId"],
    products: json["products"] == null ? null : Products.fromJson(json["products"]),
    supplierId: json["supplierId"],
    suppliers: json["suppliers"] == null ? null : Suppliers.fromJson(json["suppliers"]),
    price: json["price"],
    code: json["code"],
    isActive: json["isActive"],
    productDetailsPics: json["productDetailsPics"] == null ? [] : List<ProductDetailsPic>.from(json["productDetailsPics"]!.map((x) => ProductDetailsPic.fromJson(x))),
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
    "productDetailsPics": productDetailsPics == null ? [] : List<dynamic>.from(productDetailsPics!.map((x) => x.toJson())),
  };
}


class Products {
  int? id;
  String? name;
  String? arName;
  String? description;
  String? arDescription;
  int? productCategoryId;
  ProductCategory? productCategory;

  Products({
    this.id,
    this.name,
    this.arName,
    this.description,
    this.arDescription,
    this.productCategoryId,
    this.productCategory,
  });

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    id: json["id"],
    name: json["name"],
    arName: json["arName"],
    description: json["description"],
    arDescription: json["arDescription"],
    productCategoryId: json["productCategoryId"],
    productCategory: json["productCategory"] == null ? null : ProductCategory.fromJson(json["productCategory"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "arName": arName,
    "description": description,
    "arDescription": arDescription,
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

class PurchaseOrder {
  String? id;
  String? customerId;
  int? amount;
  DateTime? insertDate;
  int? serial;
  int? payType;
  dynamic addressId;
  DateTime? orderDate;
  dynamic notes;
  dynamic endDate;
  dynamic user;
  dynamic profileAddress;

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
    insertDate: json["insertDate"] == null ? null : DateTime.parse(json["insertDate"]),
    serial: json["serial"],
    payType: json["payType"],
    addressId: json["addressId"],
    orderDate: json["orderDate"] == null ? null : DateTime.parse(json["orderDate"]),
    notes: json["notes"],
    endDate: json["endDate"],
    user: json["user"],
    profileAddress: json["profileAddress"],
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
    "user": user,
    "profileAddress": profileAddress,
  };
}

class PurchaseOrderProductsAttr {
  String? id;
  String? purchaseOrderProductsId;
  dynamic purchaseOrderProducts;
  int? purchaseAttributeValuesId;
  PurchaseAttributeValues? purchaseAttributeValues;

  PurchaseOrderProductsAttr({
    this.id,
    this.purchaseOrderProductsId,
    this.purchaseOrderProducts,
    this.purchaseAttributeValuesId,
    this.purchaseAttributeValues,
  });

  factory PurchaseOrderProductsAttr.fromJson(Map<String, dynamic> json) => PurchaseOrderProductsAttr(
    id: json["id"],
    purchaseOrderProductsId: json["purchaseOrderProductsId"],
    purchaseOrderProducts: json["purchaseOrderProducts"],
    purchaseAttributeValuesId: json["purchaseAttributeValuesId"],
    purchaseAttributeValues: json["purchaseAttributeValues"] == null ? null : PurchaseAttributeValues.fromJson(json["purchaseAttributeValues"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "purchaseOrderProductsId": purchaseOrderProductsId,
    "purchaseOrderProducts": purchaseOrderProducts,
    "purchaseAttributeValuesId": purchaseAttributeValuesId,
    "purchaseAttributeValues": purchaseAttributeValues?.toJson(),
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
