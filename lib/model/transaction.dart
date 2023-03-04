import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  late List cities;

  @HiveField(1)
  late List offers = [];

  @HiveField(2)
  late List brands = [];

  @HiveField(3)
  late List brandsCountry = [];

  @HiveField(4)
  late List suplierList = [];

  @HiveField(5)
  late List ordersList = [];

  @HiveField(6)
  late Map userData = {};

  @HiveField(7)
  late Map userInfo = {'email': 'omar.suhail.hasan@gmail.com','name': 'Omar Hasan', 'image': 'assets/images/Logo1.png', 'mobile': '+963 0938025347', 'city' : 'Syria', 'aboutYou': 'aboutYou'};
}