class ItemModel{
  String id, name, networkImage, category, price;
  int amount;
  bool isFavorite;
  ItemModel({required this.id, required this.networkImage, required this.isFavorite, required this.amount, required this.name, required this.category, required this.price,});
}