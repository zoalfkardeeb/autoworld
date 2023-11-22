
import 'model/itemModel.dart';

class ShopHelper{
  Function() notify;
  ItemModel itemModel;
  ShopHelper({required this.notify, required this.itemModel});
  addItem() async{
    itemModel.amount += 1;
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