import 'package:automall/eShop/model/categoryModel.dart';
import 'package:automall/eShop/model/response/productRead.dart';
import 'package:automall/photoView.dart';

class ItemModel{
  String? purchaseOrderId;
  String? purchaseOrderProductId;
  String? code;
  DateTime? orderDate;
  String? orderSerial;
  String id, name, networkImage, price, attributeValues;
  List<int> purchaseAttributeValueIds;
  List<List<PurchaseAttributeValue>>? purchaseAttributeValues;
  Brands? brands;
  CategoryModel category;
  String? description;
  int amount;
  bool isFavorite;
  bool isSelect = true;
  int? status;
  Suppliers suppliers;
  bool outOfStock = false;
  int? storeQuantity;
  List<GalarryItems> imageListGallery = [];
  ItemModel({this.storeQuantity ,this.code ,this.status ,this.orderSerial, this.orderDate, this.brands, this.purchaseAttributeValues ,required this.suppliers ,this.purchaseOrderId, this.purchaseOrderProductId, required this.purchaseAttributeValueIds, required this.id, required this.networkImage, required this.isFavorite, required this.amount, required this.name, required this.category, required this.price, required this.imageListGallery, required this.attributeValues, this.description}) {
    if(storeQuantity==0){
      outOfStock = true;
    }
  }
}