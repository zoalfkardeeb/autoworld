
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/eShop/model/request/addProduct.dart';

import 'model/itemModel.dart';

class ShopHelper{
  Function() notify;
  ItemModel itemModel;
  ShopHelper({required this.notify, required this.itemModel});
  bool checkCartItem(){
    var check = false;
    if(cartProductList != null || cartProductList!.data!.length>0){
      for(var c in cartProductList!.data!){
        List<int> purchaseAttributeValueIds=[];
        for(var i in c.purchaseOrderProductsAttr!){
          purchaseAttributeValueIds.add(i.purchaseAttributeValuesId!);
        }
        if(c.id == itemModel.id.toString() && itemModel.purchaseAttributeValueIds == purchaseAttributeValueIds) check = true;
      }
    }
    return check;
  }
  addItemToBasket() async{
    pleaseWait = true;
    notify();
    var result = true;
    if(checkCartItem()){
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
    pleaseWait = false;
    notify();
  }

  addItem() async{
    pleaseWait = true;
    notify();
    var result = true;
/*    if(itemModel.amount>0){
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
    }*/
    if(result){
      itemModel.amount += 1;
    }
    pleaseWait = false;
    notify();
  }

  removeItem() async{
    if(itemModel.amount>1){
      itemModel.amount -= 1;
    }
    notify();
  }

  addToFavorite(){
      itemModel.isFavorite = !itemModel.isFavorite;
    notify();
  }
}