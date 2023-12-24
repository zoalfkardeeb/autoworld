//import 'boxes.dart';
//import 'model/transaction.dart';

import 'dart:async';
import 'dart:io';

import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/eShop/model/response/category.dart';
import 'package:automall/eShop/model/response/orderRead.dart';
import 'package:automall/eShop/model/response/productRead.dart';
import 'package:automall/helper/launchUrlHelper.dart';
import 'package:automall/model/response/addressRead.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/transaction.dart';
import 'helper/boxes.dart';
OrderRead? purchaseOrderList;
AddressRead? addressList;
ProductRead? productList;
Category? categoryList;
List listCarType = [{'name':'Sedan' , 'id':1},{'name':'Suv(4x4)' , 'id':2},{'name':'coupe' , 'id':3},];
List listCarMotorType = [{'name':'Petrol' , 'id':1},{'name':'Diesel' , 'id':2},{'name':'Hybrid' , 'id':3},{'name':'Electrical1' , 'id':4},];
List listGearBoxCarType = [{'name':'Manual' , 'id':1},{'name':'Automatic' , 'id':2},{'name':'CVT' , 'id':3}];
List cities = [];
List offers = [];
List exhibtions = [];
List brands = [];
List brandsCountry = [];
List suplierList = [];
List ordersListSupplier = [];//بدون تخزين لوكال
List ordersList = [];
List carSellsList = [];
List carBroadKeyList = [];
List carModelList = [];
Map userData = {};
Map userInfo = {'email': '....','name': '.....', 'imagePath': null, 'mobile': '+963 0938025347', 'city' : 'Syria', 'aboutYou': 'aboutYou', 'type':0};
bool isLogin = false;
bool newVersion = false;

ImageProvider? image;
String? path;
var bottomConRatio = 0.0;
PDFDocument doc = PDFDocument();
bool pleaseWait = false;
bool thereNotification = false;
bool loading = false;
bool termsAndConditions = false;

var nameController = TextEditingController();
var mobileController = TextEditingController();
var cityController = TextEditingController();
bool editProfile = false;
var timeDiff = const Duration(seconds: 0);

var token = '';
var lng = 0;
var guestType = false;

var formatter = NumberFormat('###,###,000');
String deviceId = "";
animateList(scrollController) async {
  _scrolTo(){
    return Timer(const Duration(milliseconds: 1000), ()=> scrollController.animateTo(
        scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn),);
  }
  var duration = const Duration(milliseconds: 200);
  return Timer(duration, ()=> {
    scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastOutSlowIn),
    _scrolTo(),
  });
}

getGategoryId(text){
  switch(text){
    case 'spareParts':
      return 0;
    case 'garages':
      return 1;
    case 'batteries':
      return 2;
    case 'mobiles':
      return 3;
    case 'offers':
      return 4;
    case 'scraps':
      return 5;
  }

}
getGategoryName(id){
  switch(id){
    case 0:
      return 'spareParts';
    case 1:
      return 'garages';
    case 2:
      return 'batteries';
    case 3:
      return 'mobiles';
    case 4:
      return 'offers';
    case 5:
      return 'scraps';
    case 6:
      return 'scraps';
    case 7:
      return 'breakdown';
    case 8:
      return 'scraps';
    case 9:
      return 'accessoires';
    case 10:
      return 'garagCustomization';
  }

}
List<Transaction>? transactions;

void launchWhatsApp({required var phone, required String message, context}) async {
  if(guestType){
    MyWidget(context).guestDialog();
    return;
  }
  if(phone.toString() == null.toString()){
    MyAPI(context: context).flushBar('No whatsApp number!');
    return;
  }
  var phone1 = int.parse(phone.toString());
  String url() {
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/$phone1/?text=${Uri.parse(message)}"; // new line
      //return 'https://flutter.dev'; // new line
    } else {
      // add the [https]
      return "https://wa.me/${phone1.toString().replaceAll('+', '')}";//=${Uri.parse(message)}"; // new line
    }
  }

  if (await canLaunch(url())) {
    await LaunchUrlHelper.launchInBrowser(Uri.parse(url()));
  } else {
    throw 'Could not launch ${url()}';
  }
}

void launchPhone({required var phone, context}) async {
  if(guestType){
    MyWidget(context).guestDialog();
    return;
  }
  //phone = 0938025347;
  if(phone.toString() == null.toString()){
    MyAPI(context: context).flushBar('No phone number!');
    return;
  }
  var url = Uri.parse("tel:$phone");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    MyAPI(context: context).flushBar('No phone number!');
    throw 'Could not launch $url';
  }
}

Future addTransaction() async {
  final transaction = Transaction()
    ..userInfo = userInfo
    ..offers = offers
    ..ordersList = ordersList
    ..brands = brands
    ..brandsCountry = brandsCountry
    ..cities = cities
    ..suplierList = suplierList
    ..userData = userData
   ;

  final box = Boxes.getTransactions();
  box.add(transaction);
  var box1 = Boxes.getTransactions();
  transactions = box1.values.toList();
  //box.put('mykey', transaction);

  // final mybox = Boxes.getTransactions();
  // final myTransaction = mybox.get('key');
  // mybox.values;
  // mybox.keys;
}

void editTransactionUserData() async{
  try{
    transactions![0].userData = userData;
  }catch(e){
    await addTransaction();
    transactions![0].userData = userData;
  }
  transactions![0].save();
}

editTransactionUserInfo() async{
  try{
    transactions![0].userInfo = userInfo;
  }catch(e){
    await addTransaction();
    transactions![0].userInfo = userInfo;
  }
  transactions![0].save();
}

void editTransactionSuplierList() async{
  try{
    transactions![0].suplierList = suplierList;
  }catch(e){
    await addTransaction();
    transactions![0].suplierList = suplierList;
  }
  transactions![0].save();
}

void editTransactionCities() async{
  try{
    transactions![0].cities = cities;
  }catch(e){
    await addTransaction();
    transactions![0].cities = cities;
  }
  transactions![0].save();
}

void editTransactionBrandsCountry() async{
  try{
    transactions![0].brandsCountry = brandsCountry;
  }catch(e){
    await addTransaction();
    transactions![0].brandsCountry = brandsCountry;
  }
  transactions![0].save();
}

void editTransactionBrands() async{
  try{
    transactions![0].brands = brands;
  }catch(e){
    await addTransaction();
    transactions![0].brands = brands;
  }
  transactions![0].save();
}

void editTransactionOffers() async{
  try{
    transactions![0].offers = offers;
  }catch(e){
    await addTransaction();
    transactions![0].offers = offers;
  }
  transactions![0].save();
}

void editTransactionOrdersList() async{
  try{
    transactions![0].ordersList = ordersList;
  }catch(e){
    await addTransaction();
    transactions![0].ordersList = ordersList;
  }
  transactions![0].save();
}

void deleteTransaction(Transaction transaction) {
  // final box = Boxes.getTransactions();
  // box.delete(transaction.key);
  transaction.delete();
  //setState(() => transactions.remove(transaction));
}

intParse(text){
  var rrr = 0.0;
  try{
    rrr = double.parse(text);
  }catch(e){
    rrr = 0.0;
  }
  return rrr;
}
