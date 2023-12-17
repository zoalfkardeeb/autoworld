// To parse this JSON data, do
//
//     final addProduct = addProductFromJson(jsonString);

import 'dart:convert';

AddProduct addProductFromJson(String str) => AddProduct.fromJson(json.decode(str));

String addProductToJson(AddProduct data) => json.encode(data.toJson());

class AddProduct {
  String? purchaseOrderId;
  String? purchaseOrderProductId;
  String? customerId;
  String? addressId;
  int? price;
  List<int>? purchaseAttributeValuesIds;
  int? productDetailsId;
  int? operationType;

  AddProduct({
    this.purchaseOrderId,
    this.purchaseOrderProductId,
    this.customerId,
    this.addressId,
    this.price,
    this.purchaseAttributeValuesIds,
    this.productDetailsId,
    this.operationType,
  });

  factory AddProduct.fromJson(Map<String, dynamic> json) => AddProduct(
    purchaseOrderId: json["purchaseOrderId"],
    purchaseOrderProductId: json["purchaseOrderProductId"],
    customerId: json["customerId"],
    addressId: json["addressId"],
    price: json["price"],
    purchaseAttributeValuesIds: json["purchaseAttributeValuesIds"] == null ? [] : List<int>.from(json["purchaseAttributeValuesIds"]!.map((x) => x)),
    productDetailsId: json["productDetailsId"],
    operationType: json["operationType"],
  );

  Map<String, dynamic> toJson() => {
    "purchaseOrderId": purchaseOrderId,
    "purchaseOrderProductId": purchaseOrderProductId,
    "customerId": customerId,
    "addressId": addressId,
    "price": price,
    "purchaseAttributeValuesIds": purchaseAttributeValuesIds == null ? [] : List<dynamic>.from(purchaseAttributeValuesIds!.map((x) => x)),
    "productDetailsId": productDetailsId,
    "operationType": operationType,
  };
}
