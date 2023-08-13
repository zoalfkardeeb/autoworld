import 'dart:convert';

import 'package:automall/screen/replyScreen.dart';
import 'package:automall/screen/suplierInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyWidget.dart';
import '../api.dart';
import 'package:automall/constant/color/MyColors.dart';

import '../const.dart';
import '../localizations.dart';
import '../helper/boxes.dart';

class SupplierOrdesr extends StatefulWidget {
  @override
  _SupplierOrdesrState createState() => _SupplierOrdesrState();
}

class _SupplierOrdesrState extends State<SupplierOrdesr> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';

  final List _suplierListCheck = [];

  ImageProvider? image;

  var _tapNum = 1;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  var _foundOrders = [];
  bool _conect = false;
  var _offersIndexShow = 10000000000;
  var _detailsIndexShow = 10000000000;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _state = cityController.text;
    /*suplierList.add({"star":3, "name": "Omar", "sub":"New to the list", "image": null});
    suplierList.add({"star":3, "name": "Omar", "sub":"New to the list", "image": null});
    suplierList.add({"star":3, "name": "Omar", "sub":"New to the list", "image": null});
    suplierList.add({"star":3, "name": "Omar", "sub":"New to the list", "image": null});
    */
    animateList(_scrollController);
    _foundOrders.clear();
    for(int i =0; i<ordersListSupplier.length; i++){
      _foundOrders.add(ordersListSupplier[i]);
    }
    _read();
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    _m = MyWidget(context);
    //_foundOrders.clear();
    _foundOrders.clear();
    for(int i =0; i<ordersListSupplier.length; i++){
      _foundOrders.add(ordersListSupplier[i]);
    }
    var br = 0.1;
    _foundOrders.sort((a, b) {
      var adate = a['orders']['insertDate']; //before -> var adate = a.expiry;
      if(a['orders']['lastUpdateDate'] != '0001-01-01T00:00:00') adate = a['orders']['lastUpdateDate'];
      var bdate = b['orders']['insertDate']; //before -> var bdate = b.expiry;
      if(b['orders']['lastUpdateDate'] != '0001-01-01T00:00:00') bdate = b['orders']['lastUpdateDate'];
      return bdate.compareTo(adate);
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      //appBar: _m!.appBar(barHight, _scaffoldKey),
      drawer: _m!.drawer(() => _setState(), ()=> _tap(2), ()=> _tap(1), _scaffoldKey),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: MediaQuery.of(context).size.height*(1-bottomConRatio),
              width: double.infinity,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: 0*MediaQuery.of(context).size.height / 40,
              ),
              child: _tapNum == 1?
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  SizedBox(height: hSpace/4,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: curve/1.2),
                      child: Row(
                        children: [
                          _m!.bodyText1(AppLocalizations.of(context)!.translate("My Orders"), scale: 1.2, padding: 0.0, align: TextAlign.start, color: AppColors.black),
                          const Expanded(child: SizedBox()),
                          IconButton(onPressed: ()=> refresh(), icon: Icon(Icons.refresh_outlined, size: MediaQuery.of(context).size.width/15, color: AppColors.black,)),
                        ],
                      )
                  ),
                  //SizedBox(height: hSpace/2,),
                  Container(
                    height: hSpace/20,
                    margin: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2*0),
                    color: Colors.grey,
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: _foundOrders.length,

                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          child: _orderListContainer(index, curve),
                          //color: MyColors.white,
                          onTap: () => _selectCard(index),
                        )
                        ;
                      },
                      separatorBuilder: (BuildContext context, int index) => SizedBox(),
                    ),
                  ),
                  //SizedBox(height: hSpace/3,),
                ],
              )
                  :
              _m!.userInfoProfile(_topBar(curve), hSpace, curve, () => _setState()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MediaQuery
                .of(context)
                .viewInsets
                .bottom == 0 ?
            _m!.bottomContainer(
                _m!.mainChildrenBottomContainer(curve, () => _tap(1), () => _tap(2), () => _tap(3), _tapNum),
                curve)
                : const SizedBox(height: 0.1,),
          ),
          Align(
            alignment: Alignment.center,
            child: pleaseWait || _conect?
            _m!.progress()
                :
            const SizedBox(),
          ),
        ],
      ),
    );
  }

  _read() async {
    var box = Boxes.getTransactions();
    transactions = box.values.toList();
    if(transactions!.isEmpty) {
      addTransaction();
    } else{
      cities = transactions![0].cities;
      offers = transactions![0].offers;
      brands = transactions![0].brands;
      brandsCountry = transactions![0].brandsCountry;
      suplierList = transactions![0].suplierList;
      ordersList = transactions![0].ordersList;
      userData = transactions![0].userData;
      userInfo = transactions![0].userInfo;
    }
  }

  _setState() {
    setState(() {

    });
  }

  _search() {}

  _topBar(curve) {
    return Container(
      //centerTitle: true,
      //height: barHight,
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: AppColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
          boxShadow: [BoxShadow(
            color: AppColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],  ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/30,),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child:
                  IconButton(
                    icon: Align(
                      alignment: lng==2? Alignment.centerRight:Alignment.centerLeft,
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    onPressed: ()=> Navigator.of(context).pop(),
                  ),
                ),
                /*Expanded(
                  flex: 1,
                  child: _m!.drawerButton(_scaffoldKey),
                ),*/
                Expanded(
                  flex: 1,
                  child: _m!.titleText1(
                      AppLocalizations.of(context)!.translate('name')),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),//_m!.notificationButton(),
                ),
              ],
            ),
            // SizedBox(height: MediaQuery.of(context).size.height/40,),
            /*_tapNum==1?
            _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery.of(context).size.height/40)
                :
            SizedBox()
            ,*/
          ],
        )
    );
  }

  _selectCard(index) {
/*    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  SubSelectScreen(_state, _country, index),
        ));
*/
  }

  _tap(num){
    if(num==2){
      //MyAPI(context: context).updateUserInfo(userData['id']);
    }
    setState(() {
      _tapNum = num;
    });
  }

  String? path ;

  _orderListContainer(index, curve) {
    var _vinNumberController = TextEditingController(text: 'dddd');
    var _carNameController = TextEditingController(text: 'dddd');
    var _modelController = TextEditingController(text: 'dddd');
    var _remarksController = TextEditingController(text: 'dddd');
    var status = _foundOrders[index]['status'];
    _vinNumberController.text = _foundOrders[index]['orders']['vinNumber'];
    _carNameController.text = _foundOrders[index]['orders']['carName'];
    _modelController.text = _foundOrders[index]['orders']['carModel'];
    _remarksController.text = _foundOrders[index]['orders']['remarks'];
    var imageList = [];
    imageList.clear();
    if(_foundOrders[index]['orders']['firstAttachment'].toString()!='') {
      imageList.add(_foundOrders[index]['orders']['firstAttachment'].toString());
    }
    if(_foundOrders[index]['orders']['secondAttachment'].toString()!='') {
      imageList.add(_foundOrders[index]['orders']['secondAttachment'].toString());
    }
    if(_foundOrders[index]['orders']['thirdAttachment'].toString()!='') {
      imageList.add(_foundOrders[index]['orders']['thirdAttachment'].toString());
    }
    if(_foundOrders[index]['orders']['forthAttachment'].toString()!='') {
      imageList.add(_foundOrders[index]['orders']['forthAttachment'].toString());
    }
    if(_foundOrders[index]['orders']['fifthAttachment'].toString()!='') {
      imageList.add(_foundOrders[index]['orders']['fifthAttachment'].toString());
    }
    if(_foundOrders[index]['orders']['sixthAttachment'].toString()!='') {
      imageList.add(_foundOrders[index]['orders']['fifthAttachment'].toString());
    }
    var raduis = MediaQuery.of(context).size.width/7;
    var _subHeader = _m!.getGategoryName(_foundOrders[index]['orders']['categoryId']) + ', ' + _foundOrders[index]['orders']['user']['name'];
    var _date =  _foundOrders[index]['orders']['insertDate'].toString().split('T')[0];
    var _header = 'Num: ' + _foundOrders[index]['orders']['serial'].toString() + ',  ' + _date;
    if(_foundOrders[index]['orders']['lastUpdateDate'].toString() != '0001-01-01T00:00:00') _date = _foundOrders[index]['lastUpdateDate'].toString().split('T')[0];
    curve = MediaQuery.of(context).size.height / 30/2;

    String statue =  AppLocalizations.of(context)!.translate('NEW');
    var offerHieght = MediaQuery.of(context).size.width*0.4;
    var _color = AppColors.mainColor;
    _openOffer() async{
      print(_foundOrders[index]['replyAttachment'].toString());
      if(_foundOrders[index]['replyAttachment'] == '') {
        MyAPI(context: context).flushBar(AppLocalizations.of(context)!.translate('No file is uploaded'));
        return;
      }
      pleaseWait = true;
      _setState();
      await _m!.showNetworkFile(_foundOrders[index]['replyAttachment'].toString());
      pleaseWait = false;
      _setState();
      print(_foundOrders[index]['replyAttachment'].toString());
    }
    replyDetails(){
      if(status !=0 ) {
        return Container(
        //height: offerHieght,
        //margin: EdgeInsets.only(left: raduis),
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_m!.driver(color: MyColors.mainColor),
            _m!.lableValue(AppLocalizations.of(context)!.translate('Reply Date'), _foundOrders[index]['replyDate'].toString().split('T').first),
            _m!.lableValue(AppLocalizations.of(context)!.translate('Remarks'), _foundOrders[index]['supplierNotes']),
            _m!.viewFile(_foundOrders[index]['replyAttachment'].toString()==""?'null':_foundOrders[index]['replyAttachment'].toString()),
            //_m!.raisedButton(curve*2, MediaQuery.of(context).size.width/2, AppLocalizations.of(context)!.translate('Open the Offer'), null, ()=> _openOffer(), color: MyColors.gray, height: curve*3),
            //SizedBox(height: curve/2,),
          ],
        ),
      );
      }
      else return SizedBox();
    }
    var isWiner = false;
    try{
      isWiner = _foundOrders[index]['isWinner'];
    }catch(e){
      isWiner = false;
    }
    orderDetails(){
      var categoryId =  _foundOrders[index]['orders']['categoryId'];
      if (status == 0) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width/10 + curve * 2,
                      width: MediaQuery.of(context).size.width/2.7,
                      padding: EdgeInsets.all(curve),
                      child:_m!.raisedButton(curve, MediaQuery.of(context).size.width/4, AppLocalizations.of(context)!.translate('Details'), 'assets/images/details.svg', ()=> _showDetails(index), height: MediaQuery.of(context).size.width/10,color: index == _detailsIndexShow? AppColors.mainColor: AppColors.card),
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: index == _detailsIndexShow ? AppColors.card: AppColors.white)),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
                      ),
                    ),
                    index == _detailsIndexShow ?Container(
                      //padding: EdgeInsets.symmetric(horizontal: curve),
                      margin: EdgeInsets.only(top: curve*2 + MediaQuery.of(context).size.width/10-1),
                      height: 1,
                      width: MediaQuery.of(context).size.width/2.7-2,
                      color: AppColors.white,
                    ): SizedBox(),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width/2.7,),
                /*Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width/10 + curve * 2,
                      width: MediaQuery.of(context).size.width/2.7,
                      padding: EdgeInsets.all(curve),
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: index == _offersIndexShow ? MyColors.card: MyColors.white)),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
                      ),
                      child: _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Reply'), 'assets/images/reply.svg', ()=> _showOffers(index), height: MediaQuery.of(context).size.width/10,color: index == _offersIndexShow? MyColors.mainColor: MyColors.card),
                    ),
                    index == _offersIndexShow ?Container(
                      //padding: EdgeInsets.symmetric(horizontal: curve),
                      margin: EdgeInsets.only(top: curve*2 + MediaQuery.of(context).size.width/10-1),
                      height: 1,
                      width: MediaQuery.of(context).size.width/2.7-2,
                      color: MyColors.white,
                    ):SizedBox(),
                  ],
                )*/
              ],
            ),
            Stack(
              children: [
                Container(
                  //height: offerHieght,
                  //margin: EdgeInsets.only(left: raduis),
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(BorderSide(color: AppColors.card)),
                    borderRadius: BorderRadius.all(Radius.circular(curve)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
                  margin: EdgeInsets.only(bottom: curve),
                  //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/3*0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //_m!.driver(color: MyColors.mainColor),
                      isWiner?_m!.lableValue(AppLocalizations.of(context)!.translate('Full Name'), _foundOrders[index]['orders']['user']['name'].toString())
                          :SizedBox(height: 0.0,),
                      isWiner?_m!.lableValue(AppLocalizations.of(context)!.translate('Email'), _foundOrders[index]['orders']['user']['email'].toString())
                          :SizedBox(height: 0.0,),
                      isWiner?_m!.lableValue(AppLocalizations.of(context)!.translate('Mobile Number'), _foundOrders[index]['orders']['user']['mobile'].toString())
                          :SizedBox(height: 0.0,),
                      categoryId==0?_m!.lableValue(AppLocalizations.of(context)!.translate('VIN Number'), _vinNumberController.text)
                          :SizedBox(height: 0.0,),
                      categoryId==0?_m!.lableValue(AppLocalizations.of(context)!.translate('Car Name'), _carNameController.text)
                          :SizedBox(height: 0.0,),
                      categoryId==0?_m!.lableValue(AppLocalizations.of(context)!.translate('Model'), _modelController.text)
                          :SizedBox(height: 0.0,),
                      _m!.lableValue(AppLocalizations.of(context)!.translate('Remarks'), _remarksController.text),
                      imageList.isNotEmpty?
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: imageList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2,
                            crossAxisCount: 2
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Container(
                              //height: MediaQuery.of(context).size.width/2.5,
                              //width: MediaQuery.of(context).size.width/2.5,
                              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/80,vertical: MediaQuery.of(context).size.width/40),
                              decoration: BoxDecoration(
                                image: DecorationImage(image: imageList.length == index? const AssetImage("assets/images/background.png") : NetworkImage(imageList[index])as ImageProvider, fit: BoxFit.cover),
                                color: Colors.grey,
                                /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                                border: Border.all(
                                  color: AppColors.card,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(curve/2),
                              ),
                              // child: Icon(Icons.camera_alt, color: MyColors.white,size: MediaQuery.of(context).size.width/10,),
                            ),
                            onTap: () => _m!.showImage(Image.network(imageList[index]).image),
                          )
                          ;
                        },
                      ):
                      const SizedBox(),
                    ],
                  ),
                ),
                Align(
                  alignment: lng==2? Alignment.topRight:Alignment.topLeft,
                  child: Container(
                    //padding: EdgeInsets.symmetric(horizontal: curve),
                    margin: lng==2? EdgeInsets.only(right: MediaQuery.of(context).size.width/108*5) : EdgeInsets.only(left: MediaQuery.of(context).size.width/108*5),
                    height: 1,
                    width: MediaQuery.of(context).size.width/2.7-1,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            /*Container(
              //height: offerHieght,
              //margin: EdgeInsets.only(left: raduis),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _m!.driver(color: MyColors.mainColor),
                  isWiner?_m!.lableValue(AppLocalizations.of(context)!.translate('Full Name'), _foundOrders[index]['orders']['user']['name'].toString())
                      :SizedBox(height: 0.0,),
                  isWiner?_m!.lableValue(AppLocalizations.of(context)!.translate('Email'), _foundOrders[index]['orders']['user']['email'].toString())
                      :SizedBox(height: 0.0,),
                  isWiner?_m!.lableValue(AppLocalizations.of(context)!.translate('Mobile Number'), _foundOrders[index]['orders']['user']['mobile'].toString())
                      :SizedBox(height: 0.0,),
                  categoryId==0?_m!.lableValue(AppLocalizations.of(context)!.translate('VIN Number'), _vinNumberController.text)
                      :SizedBox(height: 0.0,),
                  categoryId==0?_m!.lableValue(AppLocalizations.of(context)!.translate('Car Name'), _carNameController.text)
                      :SizedBox(height: 0.0,),
                  categoryId==0?_m!.lableValue(AppLocalizations.of(context)!.translate('Model'), _modelController.text)
                      :SizedBox(height: 0.0,),
                  _m!.lableValue(AppLocalizations.of(context)!.translate('Remarks'), _remarksController.text),
                  imageList.isNotEmpty?
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: imageList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.2,
                        crossAxisCount: 2
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                          //height: MediaQuery.of(context).size.width/2.5,
                          //width: MediaQuery.of(context).size.width/2.5,
                          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/80,vertical: MediaQuery.of(context).size.width/40),
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imageList.length == index? const AssetImage("assets/images/background.png") : NetworkImage(imageList[index])as ImageProvider, fit: BoxFit.cover),
                            color: Colors.grey,
                            /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                            border: Border.all(
                              color: MyColors.card,
                              width: 1,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(curve/2),
                          ),
                          // child: Icon(Icons.camera_alt, color: MyColors.white,size: MediaQuery.of(context).size.width/10,),
                        ),
                        onTap: () => _m!.showImage(Image.network(imageList[index]).image),
                      )
                      ;
                    },
                  ):
                  const SizedBox(),
                ],
              ),
            )*/
          ],
        );
      }else{
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width/10 + curve * 2,
                      width: MediaQuery.of(context).size.width/2.7,
                      padding: EdgeInsets.all(curve),
                      child:_m!.raisedButton(curve, MediaQuery.of(context).size.width/4, AppLocalizations.of(context)!.translate('Details'), 'assets/images/details.svg', ()=> _showDetails(index), height: MediaQuery.of(context).size.width/10,color: index == _detailsIndexShow? AppColors.mainColor: AppColors.card),
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: index == _detailsIndexShow ? AppColors.card: AppColors.white)),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
                      ),
                    ),
                    index == _detailsIndexShow ?Container(
                      //padding: EdgeInsets.symmetric(horizontal: curve),
                      margin: EdgeInsets.only(top: curve*2 + MediaQuery.of(context).size.width/10-1),
                      height: 1,
                      width: MediaQuery.of(context).size.width/2.7-2,
                      color: AppColors.white,
                    ): SizedBox(),
                  ],
                ),
                //SizedBox(width: MediaQuery.of(context).size.width/20,),
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width/10 + curve * 2,
                      width: MediaQuery.of(context).size.width/2.7,
                      padding: EdgeInsets.all(curve),
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: index == _offersIndexShow ? AppColors.card: AppColors.white)),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
                      ),
                      child: _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Reply'), 'assets/images/reply.svg', ()=> _showOffers(index), height: MediaQuery.of(context).size.width/10,color: index == _offersIndexShow? AppColors.mainColor: AppColors.card),
                    ),
                    index == _offersIndexShow ?Container(
                      //padding: EdgeInsets.symmetric(horizontal: curve),
                      margin: EdgeInsets.only(top: curve*2 + MediaQuery.of(context).size.width/10-1),
                      height: 1,
                      width: MediaQuery.of(context).size.width/2.7-2,
                      color: AppColors.white,
                    ):SizedBox(),
                  ],
                )
              ],
            ),
            index == _detailsIndexShow?
            Stack(
              children: [
                Container(
                  //height: offerHieght,
                  //margin: EdgeInsets.only(left: raduis),
                  decoration: BoxDecoration(
                    border: Border.fromBorderSide(BorderSide(color: AppColors.card)),
                    borderRadius: BorderRadius.all(Radius.circular(curve)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
                  margin: EdgeInsets.only(bottom: curve),
                  //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/3*0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //_m!.driver(color: MyColors.mainColor),
                      isWiner?_m!.lableValue(AppLocalizations.of(context)!.translate('Full Name'), _foundOrders[index]['orders']['user']['name'].toString())
                          :SizedBox(height: 0.0,),
                      isWiner?_m!.lableValue(AppLocalizations.of(context)!.translate('Email'), _foundOrders[index]['orders']['user']['email'].toString())
                          :SizedBox(height: 0.0,),
                      isWiner?_m!.lableValue(AppLocalizations.of(context)!.translate('Mobile Number'), _foundOrders[index]['orders']['user']['mobile'].toString())
                          :SizedBox(height: 0.0,),
                      categoryId==0?_m!.lableValue(AppLocalizations.of(context)!.translate('VIN Number'), _vinNumberController.text)
                          :SizedBox(height: 0.0,),
                      categoryId==0?_m!.lableValue(AppLocalizations.of(context)!.translate('Car Name'), _carNameController.text)
                          :SizedBox(height: 0.0,),
                      categoryId==0?_m!.lableValue(AppLocalizations.of(context)!.translate('Model'), _modelController.text)
                          :SizedBox(height: 0.0,),
                      _m!.lableValue(AppLocalizations.of(context)!.translate('Remarks'), _remarksController.text),
                      imageList.isNotEmpty?
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: imageList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2,
                            crossAxisCount: 2
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: Container(
                              //height: MediaQuery.of(context).size.width/2.5,
                              //width: MediaQuery.of(context).size.width/2.5,
                              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/80,vertical: MediaQuery.of(context).size.width/40),
                              decoration: BoxDecoration(
                                image: DecorationImage(image: imageList.length == index? const AssetImage("assets/images/background.png") : NetworkImage(imageList[index])as ImageProvider, fit: BoxFit.cover),
                                color: Colors.grey,
                                /*boxShadow: [
            BoxShadow(
              color: MyColors.black,
              offset: Offset(0, blurRaduis==0?0:1),
              blurRadius: blurRaduis,
            ),
          ],*/
                                border: Border.all(
                                  color: AppColors.card,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(curve/2),
                              ),
                              // child: Icon(Icons.camera_alt, color: MyColors.white,size: MediaQuery.of(context).size.width/10,),
                            ),
                            onTap: () => _m!.showImage(Image.network(imageList[index]).image),
                          )
                          ;
                        },
                      ):
                      const SizedBox(),
                    ],
                  ),
                ),
                Align(
                  alignment: lng==2?Alignment.topRight:Alignment.topLeft,
                  child: Container(
                    //padding: EdgeInsets.symmetric(horizontal: curve),
                    margin: lng==2?EdgeInsets.only(right: MediaQuery.of(context).size.width/108*5):EdgeInsets.only(left: MediaQuery.of(context).size.width/108*5),
                    height: 1,
                    width: MediaQuery.of(context).size.width/2.7-1,
                    color: AppColors.white,
                  ),
                ),
              ],
            )
            :index == _offersIndexShow?
            Stack(
                children: [
                  Container(
                    //height: offerHieght,
                    //margin: EdgeInsets.only(left: raduis),
                    decoration: BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(color: AppColors.card)),
                      borderRadius: BorderRadius.all(Radius.circular(curve)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
                    margin: EdgeInsets.only(bottom: curve),
                    //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/3*0),
                    child: replyDetails(),
                  ),
                  Align(
                    alignment: lng==2?Alignment.topRight: Alignment.topLeft,
                    child: Container(
                      //padding: EdgeInsets.symmetric(horizontal: curve),
                      margin: lng==2?EdgeInsets.only(right: MediaQuery.of(context).size.width/12*5):EdgeInsets.only(left: MediaQuery.of(context).size.width/12*5),
                      height: 1,
                      width: MediaQuery.of(context).size.width/2.7-1,
                      color: AppColors.white,
                    ),
                  ),
                ],
              )
                : const SizedBox(),
          ],
        );
      }
    }
    //var buttonText = AppLocalizations.of(context)!.translate('NEW');
    if(status == 1) {
      _color = AppColors.gray;
      statue = AppLocalizations.of(context)!.translate('REPLY');
    }
    if(status == 1 && _foundOrders[index]['isWinner']) {
      _color = AppColors.green;
      statue = AppLocalizations.of(context)!.translate('WINNER');
    }
    return Container(
      //height: index == _offersIndexShow? MediaQuery.of(context).size.height/2 : MediaQuery.of(context).size.width/3,
        padding: EdgeInsets.only( bottom: curve*0),
        margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.width/40),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.gray),
          borderRadius: BorderRadius.all(Radius.circular(curve)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: _m!.bodyText1(statue, color: AppColors.white),
              decoration: BoxDecoration(
                color: _color,
                border: Border.all(color: _color),
                borderRadius: lng==2?
                BorderRadius.only(bottomLeft: Radius.circular(curve), topRight:  Radius.circular(curve))
                    :BorderRadius.only(bottomRight: Radius.circular(curve), topLeft:  Radius.circular(curve)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children:[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: ()=> _showOffers(index),
                          child: SvgPicture.asset(/*index == _offersIndexShow?'assets/images/orderMarks.svg':*/'assets/images/orderMarks.svg', height: MediaQuery.of(context).size.width/15, color: _color,),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _m!.headText(_header,scale: 0.7, paddingH: MediaQuery.of(context).size.width/20, paddingV: 0.0, align: TextAlign.start, color: AppColors.bodyText1),
                              _m!.headText(_subHeader,scale: 0.6, paddingH: MediaQuery.of(context).size.width/20, paddingV: MediaQuery.of(context).size.height/200, align: TextAlign.start, color: AppColors.bodyText1),
                              //_m!.iconText(assets, text, color)
                              //_m!.bodyText1(_subHeader,scale: 1, padding: MediaQuery.of(context).size.width/20, padV: MediaQuery.of(context).size.height/200, align: TextAlign.start, color: MyColors.bodyText1),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: ()=> _showDetails(index),
                          child: SvgPicture.asset(index == _detailsIndexShow? 'assets/images/ordeDetailsOpen.svg' : 'assets/images/orderdetails.svg', height: MediaQuery.of(context).size.width/10,),
                        ),
                      ],
                    ),
                    //SizedBox(height: raduis/10,),
                    index == _detailsIndexShow || index == _offersIndexShow?
                    orderDetails()//:
                    /*index == _offersIndexShow?
              SizedBox(
                height: offerHieght * (_supplierSent.length + replyNum)/2,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _supplierSent.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: suplierReply(index),
                      //color: MyColors.white,
                      onTap: () => null,
                    )
                    ;
                  },
                ),
              )*/
                        : const SizedBox(),
                    status == 0? _m!.raisedButton(curve*2, MediaQuery.of(context).size.width/4, AppLocalizations.of(context)!.translate('Reply'), 'assets/images/reply.svg', status == 0? ()=>  _reply(_foundOrders[index]['orders']) : null, height: curve*3):
                    SizedBox(),
                    //_m!.driver(),
                  ]
              ),),
          ],
        )
    );
  }

  _explore(index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  SuplierInfo(index),
        ));
  }

  selectAll() {
    for(int i = 0; i<_suplierListCheck.length; i++){
      _suplierListCheck[i] = true;
    }
    setState(() {});
  }

  clearAll() {
    for (int i = 0; i < _suplierListCheck.length; i++) {
      _suplierListCheck[i] = false;
    }
    setState(() {});
  }

  _check(index) {
    _suplierListCheck[index] = !_suplierListCheck[index];
    setState(() {});
  }

  refresh() async{
    setState(() {
      _conect = true;
    });

    await MyAPI(context: context).getOrders(userInfo['id']);

    _foundOrders.clear();
    for(int i =0; i<ordersListSupplier.length; i++){
      _foundOrders.add(ordersListSupplier[i]['orders']);
    }

    setState(() {
      _conect = false;
    });

  }

  _showOffers(index) async{
    setState(() {
      pleaseWait = true;
    });
    await _m!.getFile(_foundOrders[index]['replyAttachment'].toString());
    if(_offersIndexShow == index){
      _detailsIndexShow = 10000000;
      _offersIndexShow = 10000000;
    }else{
      _detailsIndexShow = 10000000;
      _offersIndexShow = index;
    }
    setState(() {
    pleaseWait = false;
    });
  }

  _showDetails(index) async{

    if(_detailsIndexShow == index){
      _offersIndexShow = 10000000;
      _detailsIndexShow = 10000000;
    }else{
      _offersIndexShow = 10000000;
      _detailsIndexShow = index;
    }
    _setState();

  }

  _reply(foundOrder) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ReplyScreen(foundOrder)));
  }
}

