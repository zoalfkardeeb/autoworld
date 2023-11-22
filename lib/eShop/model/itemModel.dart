import 'package:automall/photoView.dart';

class ItemModel{
  String id, name, networkImage, category, price, brand, model, year;
  String? description;
  int amount;
  bool isFavorite;
  List<GalarryItems> imageListGallery = [];
  ItemModel({required this.id, required this.networkImage, required this.isFavorite, required this.amount, required this.name, required this.category, required this.price, required this.imageListGallery, required this.brand, required this.model, required this.year, this.description});
}