// To parse this JSON data, do
//
//     final orderRead = orderReadFromJson(jsonString);

import 'dart:convert';
import 'productRead.dart';
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
  int? status;
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
    deliveryEndDate: json["deliveryEndDate"],
    deliveryStartDate: json["deliveryStartDate"],
    codeSerial: json["codeSerial"],
    price: json["price"],
    quantity: json["quantity"],
    score: json["score"],
    scoreNote: json["scoreNote"],
    status: json["status"],
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
    "status": status,
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
