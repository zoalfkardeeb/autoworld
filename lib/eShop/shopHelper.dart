
import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/eShop/model/request/addProduct.dart';
import 'package:automall/main.dart';
import 'package:collection/collection.dart';
import 'model/itemModel.dart';
import 'package:automall/eShop/model/response/orderRead.dart' as orderRead;

class ShopHelper{
  Function() notify;
  ItemModel itemModel;
  ShopHelper({required this.notify, required this.itemModel}) {
    itemModel.storeQuantity = productList!.data!.where((element) => element.id.toString() == itemModel.id).toList()[0].storeQuantity;
    if(itemModel.storeQuantity == 0)itemModel.outOfStock = true; else itemModel.outOfStock = false;
    itemModel.amount = checkCartItem();
  }
  orderRead.Datum? _cartItem;
  int checkCartItem(){
    int quantity = 0;
    Function unOrdDeepEq = const DeepCollectionEquality.unordered().equals;
    if(cartProductList != null && cartProductList!.data!.length>0){
      itemModel.purchaseOrderId ??= cartProductList!.data![0].purchaseOrder!.id;
      for(var c in cartProductList!.data!){
        List<int> purchaseAttributeValueIds=[];
        for(var i in c.purchaseOrderProductsAttr!){
          purchaseAttributeValueIds.add(i.purchaseAttributeValuesId!);
        }
        if(c.productDetails!.id.toString() == itemModel.id.toString() && unOrdDeepEq(itemModel.purchaseAttributeValueIds, purchaseAttributeValueIds)) {
          quantity = c.quantity!;
          itemModel.purchaseOrderId = c.purchaseOrder!.id;
          itemModel.purchaseOrderProductId = c.id;
          _cartItem = c;
        }
      }
    }
    return quantity;
  }
  addItemToBasket() async{
    if(guestType){
      MyWidget(navigatorKey.currentContext!).guestDialog();
      return;
    }
    pleaseWait = true;
    notify();
    var result = false;
    if(checkStoreAvailable())
    {
      result = await MyAPI.createOrderProduct(product:
      CreateProduct(
        price: double.parse(itemModel.price),
        customerId:userInfo['id'],
        purchaseAttributeValuesIds: itemModel.purchaseAttributeValueIds,
        operationType: 1,
        productDetailsId: int.parse(itemModel.id),
    ),purchaseOrderId: itemModel.purchaseOrderId
      );
    }
    if(result){
      checkCartItem();
      increaseQuantity();
    }
    pleaseWait = false;
    notify();
  }

  addItem() async{
    if(guestType){
      MyWidget(navigatorKey.currentContext!).guestDialog();
      return;
    }
    pleaseWait = true;
    notify();
    var result = false;
    if(checkStoreAvailable()) {
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
    }
    if(result){
      increaseQuantity();
    }
    pleaseWait = false;
    notify();
  }

  removeItem() async{
    if(guestType){
      MyWidget(navigatorKey.currentContext!).guestDialog();
      return;
    }
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
      reduceQuantity();
    }
    pleaseWait = false;
    notify();
  }

  addToFavorite(){
      itemModel.isFavorite = !itemModel.isFavorite;
    notify();
  }

  bool checkStoreAvailable(){
    bool avilable = true;
    if(itemModel.outOfStock){
      MyWidget.showInfoDialog(text: 'Out Of Stock');
      avilable = false;
    }
/*    if(itemModel.amount >= (itemModel.storeQuantity??100000)){
      MyWidget.showInfoDialog(text: 'available in store only: ${itemModel.storeQuantity}');
      avilable = false;
    }*/
    return avilable;
  }

  void increaseQuantity(){
    itemModel.amount += 1;
    itemModel.storeQuantity = itemModel.storeQuantity! - 1;
    productList!.data!.where((element) => element.id.toString() == itemModel.id).toList()[0].storeQuantity = itemModel.storeQuantity;
    if(itemModel.storeQuantity==0)itemModel.outOfStock=true;
  }

  void reduceQuantity(){
    itemModel.amount -= 1;
    itemModel.storeQuantity = itemModel.storeQuantity! + 1;
    productList!.data!.where((element) => element.id.toString() == itemModel.id).toList()[0].storeQuantity = itemModel.storeQuantity;
    if(itemModel.storeQuantity!=0)itemModel.outOfStock=false;
  }

}