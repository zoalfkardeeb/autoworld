
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/eShop/model/request/addProduct.dart';
import 'package:collection/collection.dart';
import 'model/itemModel.dart';

class ShopHelper{
  Function() notify;
  ItemModel itemModel;
  ShopHelper({required this.notify, required this.itemModel}) {
    itemModel.amount = checkCartItem();
  }
  int checkCartItem(){
    int quantity = 0;
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
    if(cartProductList != null || cartProductList!.data!.length>0){
      for(var c in cartProductList!.data!){
        List<int> purchaseAttributeValueIds=[];
        for(var i in c.purchaseOrderProductsAttr!){
          purchaseAttributeValueIds.add(i.purchaseAttributeValuesId!);
        }
        if(c.productDetails!.id.toString() == itemModel.id.toString() && unOrdDeepEq(itemModel.purchaseAttributeValueIds, purchaseAttributeValueIds)) quantity = c.quantity!;
      }
    }
    return quantity;
  }
  addItemToBasket() async{
    pleaseWait = true;
    notify();
    var result = true;
    result = await MyAPI.createOrderProduct(product:
    CreateProduct(
        price: double.parse(itemModel.price),
        customerId:userInfo['id'],
        purchaseAttributeValuesIds: itemModel.purchaseAttributeValueIds,
        operationType: 1,
        productDetailsId: int.parse(itemModel.id),
    )
    );
    if(result){
      itemModel.amount += 1;
    }
    pleaseWait = false;
    notify();
  }

  addItem() async{
    pleaseWait = true;
    notify();
    var result = true;
    result = await MyAPI.addOrderProduct(product:
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
    if(result){
      itemModel.amount += 1;
    }
    pleaseWait = false;
    notify();
  }

  removeItem() async{

    pleaseWait = true;
    notify();
    var result = true;
    result = await MyAPI.addOrderProduct(product:
    AddProduct(
      purchaseOrderId: itemModel.purchaseOrderId,
      price: double.parse(itemModel.price),
      purchaseOrderProductId: itemModel.purchaseOrderProductId,
      customerId:userInfo['id'],
      purchaseAttributeValuesIds: itemModel.purchaseAttributeValueIds,
      operationType: -1,
      productDetailsId: int.parse(itemModel.id),
    )
    );
    if(result){
      itemModel.amount -= 1;
    }
    pleaseWait = false;
    notify();
  }

  addToFavorite(){
      itemModel.isFavorite = !itemModel.isFavorite;
    notify();
  }
}