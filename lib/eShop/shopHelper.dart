
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/eShop/model/request/addProduct.dart';

import 'model/itemModel.dart';

class ShopHelper{
  Function() notify;
  ItemModel itemModel;
  ShopHelper({required this.notify, required this.itemModel});
  addItem() async{
    pleaseWait = true;
    notify();
    var result = false;
    if(itemModel.amount>0){
      result = await MyAPI.addProduct(product:
      AddProduct(
        purchaseOrderId: itemModel.purchaseOrderId,
        price: double.parse(itemModel.price),
        purchaseOrderProductId: itemModel.purchaseOrderProductId,
        customerId:userInfo['id'],
        purchaseAttributeValuesIds: itemModel.purchaseAttributeValueIds,
        operationType: 1,
        productDetailsId: int.parse(itemModel.id),
      )
      );
    }else{
      result = await MyAPI.createProduct(product:
      CreateProduct(
        price: double.parse(itemModel.price),
        customerId:userInfo['id'],
        purchaseAttributeValuesIds: itemModel.purchaseAttributeValueIds,
        operationType: 1,
        productDetailsId: int.parse(itemModel.id),
      )
      );
    }
    if(result){
      itemModel.amount += 1;
    }
    pleaseWait = false;
    notify();
  }
  removeItem() async{
    if(itemModel.amount>0){
      itemModel.amount -= 1;
    }
    notify();
  }
  addToFavorite(){
      itemModel.isFavorite = !itemModel.isFavorite;
    notify();
  }
}