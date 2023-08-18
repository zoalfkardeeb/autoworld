import 'dart:convert';

import 'package:automall/screen/offerScreen.dart';
import 'package:automall/screen/suplierInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../MyWidget.dart';
import '../api.dart';
import 'package:automall/constant/color/MyColors.dart';

import '../const.dart';
import '../localizations.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
    _foundOrders = ordersList.where((element) => true).toList();

    /*suplierList.add({"star":3, "name": "Omar", "sub":"New to the list", "image": null});
    suplierList.add({"star":3, "name": "Omar", "sub":"New to the list", "image": null});
    suplierList.add({"star":3, "name": "Omar", "sub":"New to the list", "image": null});
    suplierList.add({"star":3, "name": "Omar", "sub":"New to the list", "image": null});
    */
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    _m = MyWidget(context);
    filtersName.clear();
    filtersName.add(AppLocalizations.of(context)!.translate('All'));
    filtersName.add(AppLocalizations.of(context)!.translate('New'));
    filtersName.add(AppLocalizations.of(context)!.translate('Replied'));
    filtersName.add(AppLocalizations.of(context)!.translate('Finished'));
    _foundOrders = ordersList.where((element) => true).toList();
    _foundOrders.sort((a, b) {
      var adate = a['insertDate']; //before -> var adate = a.expiry;
      if(a['lastUpdateDate'] != '0001-01-01T00:00:00') adate = a['lastUpdateDate'];
      var bdate = b['insertDate']; //before -> var bdate = b.expiry;
      if(b['lastUpdateDate'] != '0001-01-01T00:00:00') bdate = b['lastUpdateDate'];
      return bdate.compareTo(adate);
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      key: _scaffoldKey,
      //appBar: _m!.appBar(barHight, _scaffoldKey),
      //drawer: _m!.drawer(() => _setState(), ()=> _tap(2), _scaffoldKey),
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
                      _m!.bodyText1(AppLocalizations.of(context)!.translate("My Orders"), scale: 1.2, padding: 0.0, align: TextAlign.start, color: MyColors.black),
                       const Expanded(child: SizedBox()),
                       IconButton(onPressed: ()=> refresh(), icon: Icon(Icons.refresh_outlined, size: MediaQuery.of(context).size.width/15, color: MyColors.black,)),
                    ],
                  )
                  ),
                  //SizedBox(height: hSpace/2,),
                  Container(
                    height: hSpace/20,
                    margin: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2*0),
                    color: Colors.grey,
                  ),
                  //_selectFromTheList(AppLocalizations.of(context)!.translate('Select the State'), curve, _filtterController, () => _openList()),
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
                      }, separatorBuilder: (BuildContext context, int index) => SizedBox(),
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
            child: pleaseWait?
            _m!.progress()
                :
            const SizedBox(),
          ),
        ],
      ),
    );
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
          color: MyColors.topCon,
          boxShadow: [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
        ),
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
    _vinNumberController.text = _foundOrders[index]['vinNumber'];
    _carNameController.text = _foundOrders[index]['carName'];
    _modelController.text = _foundOrders[index]['carModel'];
    _remarksController.text = _foundOrders[index]['remarks'];
    var imageList = [];
    if(_foundOrders[index]['firstAttachment'].toString()==('')) {;}else imageList.add(_foundOrders[index]['firstAttachment']);
    if(_foundOrders[index]['secondAttachment'].toString().endsWith('string') || _foundOrders[index]['secondAttachment'].toString().endsWith(' ') || _foundOrders[index]['secondAttachment'].toString()==('')){;}else  imageList.add(_foundOrders[index]['secondAttachment']);
    if(_foundOrders[index]['thirdAttachment'].toString().endsWith('string') || _foundOrders[index]['thirdAttachment'].toString().endsWith(' ') || _foundOrders[index]['thirdAttachment'].toString()==('')) {;}else imageList.add(_foundOrders[index]['thirdAttachment']);
    if(_foundOrders[index]['forthAttachment'].toString().endsWith('string') || _foundOrders[index]['forthAttachment'].toString().endsWith(' ') || _foundOrders[index]['forthAttachment'].toString()==('')) {;}else imageList.add(_foundOrders[index]['forthAttachment']);
    if(_foundOrders[index]['fifthAttachment'].toString().endsWith('string') || _foundOrders[index]['fifthAttachment'].toString().endsWith(' ') || _foundOrders[index]['fifthAttachment'].toString()==('')) {;}else imageList.add(_foundOrders[index]['fifthAttachment']);
    if(_foundOrders[index]['sixthAttachment'].toString().endsWith('string') || _foundOrders[index]['sixthAttachment'].toString().endsWith(' ') || _foundOrders[index]['sixthAttachment'].toString()==('')) {;}else imageList.add(_foundOrders[index]['sixthAttachment']);
    var raduis = MediaQuery.of(context).size.width/7;
    var _subHeader = _foundOrders[index]['user']['name'] + ', '+_m!.getGategoryName(_foundOrders[index]['categoryId']);
    var _date =  _foundOrders[index]['insertDate'].toString().split('T')[0];
    var _header = AppLocalizations.of(context)!.translate('Num: ') + _foundOrders[index]['serial'].toString() + ',  ' + _date;
    if(_foundOrders[index]['lastUpdateDate'].toString() != '0001-01-01T00:00:00') _date = _foundOrders[index]['lastUpdateDate'].toString().split('T')[0];
    List _orderSuppliers = _foundOrders[index]['orderSuppliers'];
    List _supplierSent = [{"id":"2" , "name":"Sup2", "city":"Doha", "date":"8/2/2020", "details":"dsbvb asf dgds dsf sd", "logo":null},
      {"id":"1" , "name":"Sup1", "city":"Doha", "date":"8/2/2020", "details":"dsbvb asf dgds dsf sd lj; lkjkl kjlkj kjl", "logo":null}];
    _supplierSent.clear();
    var replyNum = 0;
    for(int i = 0; i<_orderSuppliers.length; i++){
      Map suppleir = _orderSuppliers[i]['supplier'];
      _supplierSent.add({'status':_orderSuppliers[i]['status'],'id': suppleir['id'], 'name': suppleir['fullName'], 'date': _orderSuppliers[i]['replyDate'].toString().split('T')[0], 'city':'Doha', 'logo': suppleir['user']['imagePath'].toString()==''? null : suppleir['user']['imagePath'], 'details':_orderSuppliers[i]['supplierNotes'].toString()});
      if(_orderSuppliers[i]['status'] == 1) replyNum++;
    }
    curve = MediaQuery.of(context).size.width /30;
    var offerHieght = MediaQuery.of(context).size.width*0.2;
    suplierReply(i){
      if(_supplierSent[i]['status'] == 1){
        return Container(
          height: offerHieght + MediaQuery.of(context).size.width/9,
          margin: EdgeInsets.symmetric(horizontal: raduis/2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.width/100,),
                  _m!.logoContainer(_supplierSent[i]['logo'], MediaQuery.of(context).size.width/7, isSupp: true),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _m!.bodyText1(_supplierSent[i]['name'], align: TextAlign.start, scale: 1.1, padding: MediaQuery.of(context).size.width/40),
                      SizedBox(height: MediaQuery.of(context).size.width/100,),
                      Container(
                        child:
                        _m!.bodyText1(_supplierSent[i]['details'],scale: 0.8, maxLine: 2, padding: MediaQuery.of(context).size.width/40,align: TextAlign.start),
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 2
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width/80,),
                      _m!.bodyText1(_supplierSent[i]['city'].toString() + ' date: ' + _supplierSent[i]['date'].toString(), scale: 0.9, padding: MediaQuery.of(context).size.width/40, align: TextAlign.start),
                    ],
                  )
                ],
              ),
              Stack(
                children: [
                  _m!.raisedButton(curve, MediaQuery.of(context).size.width/4, AppLocalizations.of(context)!.translate('Show Offer'), null, ()=> _showSupplierOffer(_foundOrders[index]['orderSuppliers'][i], _foundOrders[index]['id'], _foundOrders[index]['serial'], _foundOrders[index]['status']==2?true:false), height: MediaQuery.of(context).size.width/13),
                  /*Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.width/11),
                    child: _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Offer.pdf'), null, ()=> null, height: MediaQuery.of(context).size.width/13),
                  ),*/
                ],
              ),
              //SizedBox(height: MediaQuery.of(context).size.width/30,),
            ],
          ),
        );
      }
      else{
        return Container(
          height: offerHieght-3,
          margin: EdgeInsets.symmetric(horizontal: raduis/2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.width/100,),
                  _m!.logoContainer(_supplierSent[i]['logo'], MediaQuery.of(context).size.width/7, isSupp: true),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _m!.bodyText1(_supplierSent[i]['name'], align: TextAlign.start, scale: 1.1, padding: MediaQuery.of(context).size.width/40),
                      SizedBox(height: MediaQuery.of(context).size.width/40,),
                      _m!.bodyText1(AppLocalizations.of(context)!.translate('No Offer Yet!'), scale: 0.9, padding: MediaQuery.of(context).size.width/40, align: TextAlign.start),
                    ],
                  )
                ],
              ),
              //SizedBox(height: MediaQuery.of(context).size.width/30,),
            ],
          ),
        );
      }
    }
    orderDetails(){
      var categoryId =  _foundOrders[index]['categoryId'];
      return Stack(
        children: [
          Container(
            //height: offerHieght,
            //margin: EdgeInsets.only(left: raduis),
            decoration: BoxDecoration(
              border: Border.fromBorderSide(BorderSide(color: MyColors.card)),
              borderRadius: BorderRadius.all(Radius.circular(curve)),
            ),
            padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve),
            //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/3*0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //_m!.driver(color: MyColors.mainColor, padH: MediaQuery.of(context).size.width/10),
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
                          image: DecorationImage(image: imageList.length == index? const AssetImage("assets/images/background.png") : NetworkImage(imageList[index]) as ImageProvider, fit: BoxFit.cover),
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
          ),
          Align(
            alignment: lng==2?Alignment.topRight:Alignment.topLeft,
            child: Container(
              //padding: EdgeInsets.symmetric(horizontal: curve),
              margin: lng==2?EdgeInsets.only(right: MediaQuery.of(context).size.width/108*5):EdgeInsets.only(left: MediaQuery.of(context).size.width/108*5),
              height: 1,
              width: MediaQuery.of(context).size.width/2.7-1,
              color: MyColors.white,
            ),
          ),
        ],
      );
    }
    var _color = MyColors.mainColor;
    String statue =  AppLocalizations.of(context)!.translate('NEW');
    if(replyNum>0){
      _color = MyColors.green;
      statue = AppLocalizations.of(context)!.translate('REPLY');
    }
    if(_foundOrders[index]['status'] == 2){
      _color = MyColors.gray;
      statue = AppLocalizations.of(context)!.translate('FINISH');
    }
    return Container(
      //height: index == _offersIndexShow? MediaQuery.of(context).size.height/2 : MediaQuery.of(context).size.width/3,
      padding: EdgeInsets.only(bottom: curve),
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/20, vertical: MediaQuery.of(context).size.width/40),
      decoration: BoxDecoration(
        color: MyColors.white,
        border: Border.all(color: MyColors.gray),
        borderRadius: BorderRadius.all(Radius.circular(curve)),
      ),
        child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          Container(
            child: _m!.bodyText1(statue, color: MyColors.white),
            decoration: BoxDecoration(
              color: _color,
              border: Border.all(color: _color),
              borderRadius: lng==2?
              BorderRadius.only(bottomLeft: Radius.circular(curve), topRight:  Radius.circular(curve))
                  :BorderRadius.only(bottomRight: Radius.circular(curve), topLeft:  Radius.circular(curve)),            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/3),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: ()=> _showOffers(index),
                      child: SvgPicture.asset(index == _offersIndexShow?'assets/images/orderMarks.svg':'assets/images/orderMarksFill.svg', height: MediaQuery.of(context).size.width/15, color: _color,),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _m!.headText(_header,scale: 0.65, paddingH: MediaQuery.of(context).size.width/30, paddingV: 0.0, align: TextAlign.start, color: MyColors.bodyText1),
                          _m!.headText(_subHeader,scale: 0.6, paddingH: MediaQuery.of(context).size.width/20, paddingV: MediaQuery.of(context).size.height/100, align: TextAlign.start, color: MyColors.bodyText1),
                          GestureDetector(
                            onTap: ()=> _showOffers(index),
                            child: _m!.bodyText1( AppLocalizations.of(context)!.translate('offers received') + ' ' + replyNum.toString() + AppLocalizations.of(context)!.translate(' of ')+ _orderSuppliers.length.toString(), color: _color),
                          ),
                          _m!.bodyText1(AppLocalizations.of(context)!.translate('Last Update') + ' ' + _date, scale: 0.8, maxLine: 1, align: TextAlign.start),
                        ],
                      ),
                    ),
                    _foundOrders[index]['status'] != 2?GestureDetector(
                      onTap: ()=> _close(_foundOrders[index]['id']),
                      child: SvgPicture.asset('assets/images/close.svg', height: MediaQuery.of(context).size.width/11,),
                    ):SizedBox(),
                    SizedBox(width: MediaQuery.of(context).size.width/100,),
                    GestureDetector(
                      onTap: ()=> _showDetails(index),
                      child: SvgPicture.asset(index == _detailsIndexShow? 'assets/images/ordeDetailsOpen.svg' : 'assets/images/orderdetails.svg', height: MediaQuery.of(context).size.width/11,),
                    ),
                  ],
                ),
                SizedBox(height: raduis/10,),
                index == _detailsIndexShow || index == _offersIndexShow ?
                Column(
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
                              child:_m!.raisedButton(curve, MediaQuery.of(context).size.width/4, AppLocalizations.of(context)!.translate('Details'), 'assets/images/details.svg', ()=> _showDetails(index), height: MediaQuery.of(context).size.width/10,color: index == _detailsIndexShow? MyColors.mainColor: MyColors.card),
                              decoration: BoxDecoration(
                                border: Border.fromBorderSide(BorderSide(color: index == _detailsIndexShow ? MyColors.card: MyColors.white)),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
                              ),
                            ),
                            index == _detailsIndexShow ?Container(
                              //padding: EdgeInsets.symmetric(horizontal: curve),
                              margin: EdgeInsets.only(top: curve*2 + MediaQuery.of(context).size.width/10-1),
                              height: 1,
                              width: MediaQuery.of(context).size.width/2.7-2,
                              color: MyColors.white,
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
                                border: Border.fromBorderSide(BorderSide(color: index == _offersIndexShow ? MyColors.card: MyColors.white)),
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(curve), topRight: Radius.circular(curve)),
                              ),
                              child: _m!.raisedButton(curve, MediaQuery.of(context).size.width/4, AppLocalizations.of(context)!.translate('Suppliers'), 'assets/images/reply.svg', ()=> _showOffers(index), height: MediaQuery.of(context).size.width/10,color: index == _offersIndexShow? MyColors.mainColor: MyColors.card),
                            ),
                            index == _offersIndexShow ?Container(
                              //padding: EdgeInsets.symmetric(horizontal: curve),
                              margin: EdgeInsets.only(top: curve*2 + MediaQuery.of(context).size.width/10-1),
                              height: 1,
                              width: MediaQuery.of(context).size.width/2.7-2,
                              color: MyColors.white,
                            ):SizedBox(),
                          ],
                        )
                       ],
                    ),
                    //_m!.driver(color: MyColors.mainColor, padH: MediaQuery.of(context).size.width/10),
                  ],
                ) : SizedBox(),
                index == _detailsIndexShow?
                orderDetails():
                index == _offersIndexShow?
                SizedBox(
                height: (offerHieght + MediaQuery.of(context).size.height/400) * _supplierSent.length + curve*2 + replyNum * (MediaQuery.of(context).size.width/9),
                child: Stack(
                  children: [
                    Container(
                      //height: offerHieght,
                      //margin: EdgeInsets.only(left: raduis),
                      decoration: BoxDecoration(
                        border: Border.fromBorderSide(BorderSide(color: MyColors.card)),
                        borderRadius: BorderRadius.all(Radius.circular(curve)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: curve*0, vertical: curve),
                      //padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/15, vertical: curve/3*0),
                      child: ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 0.0),
                        controller: _scrollController,
                        itemCount: _supplierSent.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: suplierReply(index),
                            //color: MyColors.white,
                            onTap: () => null,
                          )
                          ;
                        }, separatorBuilder: (BuildContext context, int index) => _m!.driver(padH: 0.0, padV: 0.0) ,
                      ),
                    ),
                    Align(
                      alignment: lng==2?Alignment.topRight:Alignment.topLeft,
                      child: Container(
                        //padding: EdgeInsets.symmetric(horizontal: curve),
                        margin: lng==2?EdgeInsets.only(right: MediaQuery.of(context).size.width/12*5):EdgeInsets.only(left: MediaQuery.of(context).size.width/12*5),
                        height: 1,
                        width: MediaQuery.of(context).size.width/2.7-1,
                        color: MyColors.white,
                      ),
                    ),
                  ],
                ),

              )
                    : const SizedBox(),
                // _m!.driver(),
              ],
            ),
          )
        ]
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
    //MyAPI(context: context).sendEmail('_body', '_subject', 'www.osh.themyth@gmail.com');
    //return;
    setState(() {
      pleaseWait = true;
    });

    await MyAPI(context: context).getOrders(userInfo['id']);

    _foundOrders = ordersList.where((element) => true).toList();


    setState(() {
      pleaseWait = false;
    });

  }

  _showOffers(index) {
    if(_offersIndexShow == index){
      _detailsIndexShow = 10000000;
      _offersIndexShow = 10000000;
    }else{
      _detailsIndexShow = 10000000;
      _offersIndexShow = index;
    }
    setState(() {
    });
  }

  _showDetails(index) {
    if(_detailsIndexShow == index){
      _offersIndexShow = 10000000;
      _detailsIndexShow = 10000000;
    }else{
      _offersIndexShow = 100000000;
      _detailsIndexShow = index;
    }
    setState(() {
    });
  }

  _selectFromTheList(text, curve, controller, Function() press){
    var width = MediaQuery.of(context).size.width/1.5;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/40*0),
      child: Stack(
        children: [
          Align(
            child: Column(
              children: [
               // _m!.bodyText1(text,scale: 1.1, padding: 0.0),
                Stack(
                  children: [
                    Align(
                      child: _m!.listTextFiled(curve, controller, () => press(), MyColors.black, MyColors.white, AppLocalizations.of(context)!.translate('Filter your orders'), MyColors.white, width: width, withOutValidate: true),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: curve, right: MediaQuery.of(context).size.width/6.5 + MediaQuery.of(context).size.width/50,),
                        child: _dropDown(width, curve/2),
                      ),

                    )
                  ],
                )
                /*    Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _m!.textFiled(curve, MyColors.black, MyColors.white, controller, AppLocalizations.of(context)!.translate('Select from the list'), Icons.search, width: MediaQuery.of(context).size.width/1.6),
              SizedBox(width: MediaQuery.of(context).size.width/40,),
              _m!.iconButton(MediaQuery.of(context).size.height/30, 'assets/images/filter.svg', () => press(), curve: curve),
            ],
          )
*/
              ],
            ),
          ),
        ],
      ),

    );
  }

  final GlobalKey _dropDownKey = GlobalKey();
  var _filtterController= new TextEditingController();

  List<String> filtersName = <String>[];
  _dropDown(width, curve){
    if(filtersName.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKey,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.gray.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: filtersName.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.white,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return filtersName.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _filtterController.text = chosen.toString();
                var index = filtersName.indexWhere((element) => element==chosen);
                _filter(index);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
    /*return
    Container(
      child: EnhancedDropDown.withData(
        dropdownLabelTitle: '',
        dataSource: citiesName,
        defaultOptionText: "Dawha",
        valueReturned: (chosen) {
          _stateController.text = chosen;
          var index = cities.indexWhere((element) => element['name']==chosen);
          cityId = cities[index]['id'];
          print(chosen);
        },

      ),
    );*/
  }

  _openList() {
    _dropDownKey.currentContext?.visitChildElements((element) {
      if (element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, const ActivateIntent());
              //return false;
            });
          }
        });
      }
    });
  }

  _filter(index){
    _foundOrders.clear();
    switch (index){
      case 0:{
        _foundOrders = ordersList.where((element) => true).toList();
        return;
      }
      case 1:{
        _foundOrders = ordersList.where((element) => element['status']==0).toList();
        break;
      }
      case 2:{
        _foundOrders = ordersList.where((element) => element['status']==1).toList();
        break;
      }
      case 3:{
        _foundOrders = ordersList.where((element) => element['status']==2).toList();
        break;
      }

    }
  }

  _showSupplierOffer(order, orderId, serial, finished) async{
    setState((){
      pleaseWait = true;
    });
    await _m!.getFile(order['replyAttachment'].toString());
    setState((){
      pleaseWait = false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => OfferScreen(foundOffer: order, orderId: orderId, finished: finished, orderSerial: serial,)));
  }

  _close(orderId) {
    Widget _no(){
      return IconButton(
          onPressed: ()=> Navigator.of(context).pop(), icon: const Icon(Icons.close_outlined, color: MyColors.mainColor,));
    }
    Widget _ok(){
      return IconButton(
        onPressed: ()async=> {
          Navigator.of(context).pop(),
          pleaseWait = true,
          _setState(),
          await MyAPI(context: context).orderClose(orderId),
          await refresh(),
          pleaseWait = false,
          _setState(),
        }, icon: const Icon(Icons.check, color: MyColors.mainColor,),

      );
    }

    _m!.showSDialog(AppLocalizations.of(context)!.translate('close this order?'), _no(), _ok());

  }

}

