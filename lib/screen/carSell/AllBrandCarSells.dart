// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../MyWidget.dart';
import 'CarSellDetails.dart';
// ignore: camel_case_types

class AllBrandCarSells extends StatefulWidget {
  const AllBrandCarSells({Key? key}) : super(key: key);

  @override
  _AllBrandCarSellsState createState() => _AllBrandCarSellsState();
}

class _AllBrandCarSellsState extends State<AllBrandCarSells> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final _country = 'Qatar';
  var _state = 'state';

  bool hOrietation = false;

  bool filterShow = false;
  bool filterApply = false;
  List<String> imageList = [];
  //List<DropdownMenuItem<String>> dropDownList = [];
  List<String> dropDownListString = [];
  ImageProvider? image;

  final List<String> _listNumOfCyl = <String>[];
  final List<String> _listCarType = <String>[];
  final List<String> _brands = <String>[];
  final List<String> _priceFrom = <String>[];
  final List<String> _priceTo = <String>[];
  final List<String> _dateFrom = <String>[];
  final List<String> _dateTo = <String>[];
  final List<String> _carModelList = <String>[];

  final List _carSellList = [];
  List carSellListBase = [];
  var _tapNum = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      _carSellList.clear();
      for(int i = 0; i<carSellsList.length; i++){
        _carSellList.add({
          'id': carSellsList[i]['id'].toString(),
          'type': carSellsList[i]['type'].toString(),
          'carModel': carModelList[carModelList.indexWhere((element) => carSellsList[i]['carModelId'] == element['id'])]['name'].toString() ,
          'image': carSellsList[i]['mainAttachment'].toString(),
          'brandLogo': brands[brands.indexWhere((element) => carSellsList[i]['brandId'] == element['id'])]['logo'].toString(),
          'brandName': brands[brands.indexWhere((element) => carSellsList[i]['brandId'] == element['id'])]['name'].toString(),
          'kelometrage': formatter.format(carSellsList[i]['kelometrage']).toString(),
          'price': formatter.format(carSellsList[i]['price']).toString(),
          'productionYear': carSellsList[i]['productionYear'].toString(),
          'gearBoxType': carSellsList[i]['gearBoxType'].toString(),
          'insertDate': carSellsList[i]['insertDate'].toString(),
          'view': carSellsList[i]['viewCount'].toString(),
          'numberOfCylindes': carSellsList[i]['numberOfCylindes'].toString(),
          'fromUser': carSellsList[i]['user']['type'] ==0 ? true : false,
          'isNew': !carSellsList[i]['isPaid']
        });
        var exist = false;
        for(String item in _listNumOfCyl) {if(item == carSellsList[i]['numberOfCylindes'].toString())exist = true;}
        if(!exist) _listNumOfCyl.add(carSellsList[i]['numberOfCylindes'].toString());
        exist = false;
        for(String item in _listCarType) {if(item == carSellsList[i]['type'].toString())exist = true;}
        if(!exist) _listCarType.add(carSellsList[i]['type'].toString());
        exist = false;
        for(String item in _carModelList) {if(item == carModelList[carModelList.indexWhere((element) => carSellsList[i]['carModelId'] == element['id'])]['name'].toString())exist = true;}
        if(!exist) _carModelList.add(carModelList[carModelList.indexWhere((element) => carSellsList[i]['carModelId'] == element['id'])]['name'].toString() );
        exist = false;
        for(String item in _brands) {if(item == brands[brands.indexWhere((element) => carSellsList[i]['brandId'] == element['id'])]['name'].toString())exist = true;}
        if(!exist) _brands.add(brands[brands.indexWhere((element) => carSellsList[i]['brandId'] == element['id'])]['name'].toString());
        exist = false;
        for(String item in _priceFrom) {if(item == carSellsList[i]['price'].toString())exist = true;}
        if(!exist) {
          _priceFrom.add(carSellsList[i]['price'].toString());
          _priceTo.add(carSellsList[i]['price'].toString());
        }
        exist = false;
        for(String item in _dateTo) {if(item == carSellsList[i]['productionYear'].toString())exist = true;}
        if(!exist) {
          _dateTo.add(carSellsList[i]['productionYear'].toString());
          _dateFrom.add(carSellsList[i]['productionYear'].toString());
        }
      }
      _dateTo.sort();
      _dateFrom.sort();
      _priceTo.sort();
      _priceFrom.sort();
      for(var item in _carSellList) {
        carSellListBase.add(item);
      }
      _state = cityController.text;
    }catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    var width = MediaQuery.of(context).size.width / 1.2;
    _m = MyWidget(context);
    dropDownListString.clear();
    dropDownListString.add(AppLocalizations.of(context)!.translate('Sort By Price From High to Low'));
    dropDownListString.add(AppLocalizations.of(context)!.translate('Sort By Price From Low to High'));
    dropDownListString.add(AppLocalizations.of(context)!.translate('Sort By Date From High to Low'));
    dropDownListString.add(AppLocalizations.of(context)!.translate('Sort By Date From Low to High'));
    dropDownListString.add(AppLocalizations.of(context)!.translate('Sort By Views From High to Low'));
    dropDownListString.add(AppLocalizations.of(context)!.translate('Sort By Views From Low to High'));
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.topCon,
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
                top: MediaQuery.of(context).size.height / 40*0,
              ),
              child: _tapNum == 1?
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  //SizedBox(height: hSpace/2,),
                  filterShow?
                  Container(
                    height:  MediaQuery.of(context).size.height/1.2 - MediaQuery.of(context).viewInsets.bottom,
                    padding: EdgeInsets.symmetric(horizontal: curve),
                    margin: EdgeInsets.symmetric(horizontal: curve/1.5),
                    decoration: BoxDecoration(
                      color: MyColors.white,
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
                    ),
                    child:  SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _m!.selectFromTheListDrop(curve, _typeController, () => _openList(_dropDownKeyType), AppLocalizations.of(context)!.translate('Type'), true, _dropDownType(width,curve)),
                            _m!.selectFromTheListDrop(curve, _brandController, () => _openList(_dropDownKeyBrand), AppLocalizations.of(context)!.translate('Brand'), true, _dropDownBrand(width,curve)),
                            _m!.selectFromTheListDrop(curve, _modelController, () => _openList(_dropDownKeyModel), AppLocalizations.of(context)!.translate('Model'), true, _dropDownModel(width,curve)),
                            _m!.selectFromTheListDrop(curve, _numOfCylYearController, () => _openList(_dropDownKeyNumOfCyl), AppLocalizations.of(context)!.translate('Number of cylinders'), true, _dropDownNumOfSyl(width,curve)),
                            SizedBox(height: hSpace/2,),
                            _m!.bodyText1(AppLocalizations.of(context)!.translate('Manufacture Year')),
                            Row(
                              children: [
                                Flexible(
                                  flex : 1,
                                  child: _m!.textFiled(curve/2, MyColors.white, MyColors.black, _dateFromController, AppLocalizations.of(context)!.translate('From'), Icons.keyboard_arrow_down_outlined, withoutValidator: true, readOnly: true, click: () => _yearPicker(1), fontSize: MediaQuery.of(context).size.width/25, height: MediaQuery.of(context).size.width/8,),
                                  /*Padding(
                                    padding: EdgeInsets.only(top: curve/2),
                                    child: _m!.selectFromTheListDrop(curve, _dateFromController, () => _yearPicker(1), AppLocalizations.of(context)!.translate('From'), true, _dropDownDateFrom(width/2,curve/2)),
                                  )*/
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/50,),
                                Flexible(
                                    flex : 1,
                                    child: _m!.textFiled(curve/2, MyColors.white, MyColors.black, _dateToController, AppLocalizations.of(context)!.translate('To'), Icons.keyboard_arrow_down_outlined, withoutValidator: true, readOnly: true, click: () => _yearPicker(2), fontSize: MediaQuery.of(context).size.width/25, height: MediaQuery.of(context).size.width/8,)
                                  // child: _m!.selectFromTheListDrop(curve, _dateToController, () => _yearPicker(2), AppLocalizations.of(context)!.translate('To'), true, _dropDownDateTo(width/2,curve/2)),
                                ),
                              ],
                            ),
                            SizedBox(height: hSpace/2,),
                            _m!.bodyText1(AppLocalizations.of(context)!.translate('Price')),
                            Row(
                              children: [
                                Flexible(
                                  flex : 1,
                                  child: _m!.textFiled(curve, MyColors.white, MyColors.bodyText1, _priceFromController,  AppLocalizations.of(context)!.translate('From'), null, withoutValidator: true, number: true),

//                                    child: _m!.selectFromTheListDrop(curve, _priceFromController, () => _openList(_dropDownKeyPriceFrom), AppLocalizations.of(context)!.translate('From'), true, _dropDownPriceFrom(width/2,curve/2), fontSize: MediaQuery.of(context).size.width/35),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/50,),
                                Flexible(
                                  flex : 1,
                                  child: _m!.textFiled(curve, MyColors.white, MyColors.bodyText1, _priceToController,  AppLocalizations.of(context)!.translate('To'), null, withoutValidator: true, number: true),
                                  //child: _m!.selectFromTheListDrop(curve, _priceToController, () => _openList(_dropDownKeyPriceTo), AppLocalizations.of(context)!.translate('To'), true, _dropDownPriceTo(width/2,curve/2), fontSize: MediaQuery.of(context).size.width/35),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: curve),
                              child: Row(
                                children: [
                                  _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Apply'), null, ()=> applyFilter(),),
                                  const Expanded(child: SizedBox()),
                                  _m!.raisedButton(curve, MediaQuery.of(context).size.width/3, AppLocalizations.of(context)!.translate('Cancel'), null, ()=> cancleFilter(), color: MyColors.card),

                                ],
                              ),
                            )
                          ],
                        ),
                    ),
                  ):
                  _carSellList.isEmpty?Expanded(
                    child: Center(
                      child: _m!.headText(AppLocalizations.of(context)!.translate("There isn't!")),
                    ),

                  ):
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: curve/2),
                      child: GridView.builder(
                        itemCount: _carSellList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: !hOrietation?2.08:0.6,
                            crossAxisCount: !hOrietation?1:2),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: _carSellCard(index),
                            onTap: () => {
                              MyAPI(context: context).addViewCar(_carSellList[index]['id']),
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  CarSellDetails(indexCarSell: carSellsList.indexWhere((element) => element['id'] == _carSellList[index]['id'])),
                                )),
                            }
                          );
                        },
                      ),
                    ),
                  ),
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
          )
        ],
      ),
    );
  }

  _carSellCard(index){
    //index = 0;
    if(!hOrietation) {
      return MyWidget(context).carSellerHCard(
        _carSellList[index]['image'],
        _carSellList[index]['brandLogo'],
        listCarType[listCarType.indexWhere((element) => element['id'].toString()==_carSellList[index]['type'])]['name'],
        _carSellList[index]['carModel'],
        _carSellList[index]['kelometrage'] + AppLocalizations.of(context)!.translate('Km'),
        "${AppLocalizations.of(context)!.translate('Engine')}: " +  _carSellList[index]['numberOfCylindes'] + AppLocalizations.of(context)!.translate("Cylinders"),
        "${AppLocalizations.of(context)!.translate('Price')}: " + _carSellList[index]['price'],
        "${AppLocalizations.of(context)!.translate('Gear')}: ${AppLocalizations.of(context)!.translate(listGearBoxCarType[listGearBoxCarType.indexWhere((element) => _carSellList[index]['gearBoxType'] == element['id'].toString())]['name'])}",
        AppLocalizations.of(context)!.translate('Man. Date: ') + _carSellList[index]['productionYear'],
        _carSellList[index]['view'] + " " + AppLocalizations.of(context)!.translate('View'),
        _carSellList[index]['fromUser'],
        _carSellList[index]['isNew']
        );
    } else{
      return MyWidget(context).carSellerVCard(
        _carSellList[index]['image'],
        _carSellList[index]['brandLogo'],
        listCarType[listCarType.indexWhere((element) => element['id'].toString()==_carSellList[index]['type'])]['name'],
        _carSellList[index]['carModel'],
        _carSellList[index]['kelometrage']+  AppLocalizations.of(context)!.translate('Km'),
        AppLocalizations.of(context)!.translate('Engine') + _carSellList[index]['numberOfCylindes'] + AppLocalizations.of(context)!.translate("Cylinders"),
        "${AppLocalizations.of(context)!.translate('Price')}: " + _carSellList[index]['price'],
        "${AppLocalizations.of(context)!.translate('Gear')}: ${AppLocalizations.of(context)!.translate( listGearBoxCarType[listGearBoxCarType.indexWhere((element) => _carSellList[index]['gearBoxType'] == element['id'].toString())]['name'])}",
        AppLocalizations.of(context)!.translate('Man. Date: ') + _carSellList[index]['productionYear'],
          _carSellList[index]['view'] + " " + AppLocalizations.of(context)!.translate('View'),
          _carSellList[index]['fromUser'],
          _carSellList[index]['isNew']
      );
    }
  }

  _setState() {
    setState(() {

    });
  }

  _search() {}

  _topBar(curve) {
    var padT = MediaQuery.of(context).size.height/30;

    return Container(
      //centerTitle: true,
      //height: MediaQuery.of(context).size.height/10,
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
          boxShadow: const [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )], ),
        child: Stack(
          children: [
            Align(alignment: Alignment.center,
              child: Padding(padding: EdgeInsets.only(top: padT),
                child: _dropDown(),),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: padT,),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Align(
                          alignment: lng==2?Alignment.centerRight:Alignment.centerLeft,
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                        onPressed: ()=> Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _iconCenter("assets/images/ic_grouped.svg", () => _pressGrouped()),
                    ),
                    Expanded(
                      flex: 1,
                      child: _iconCenter(/*sortIncrease?"assets/images/ic_sort_increase.svg":"assets/images/ic_sort_less.svg"*/"assets/images/ic_sort1.svg", () => _pressSort()),
                    ),
                    Expanded(
                      flex: 1,
                      child: _iconCenter("assets/images/ic_filter.svg", () => _pressFilter()),
                    ),
                    Expanded(
                      flex: 1,
                      child: _m!.notificationButton(),
                    ),
                  ],
                ),
                // SizedBox(height: MediaQuery.of(context).size.height/40,),
                /*_tapNum==1?
            _m!.headText('$_country, $_state', scale: 0.8, paddingV: MediaQuery.of(context).size.height/120)
                :
            const SizedBox()
            ,*/
              ],
            ),


          ],
        )
    );
  }

  _iconCenter(svgImage, Function() onPressed){
    return IconButton(
      icon: Align(
        alignment: Alignment.center,
        child: SvgPicture.asset(svgImage, height: MediaQuery.of(context).size.width/20, fit: BoxFit.contain, color: MyColors.gray,),),
      onPressed: () => onPressed(),
    );

  }

  _tap(num) async{
    if(num == _tapNum) return;
    setState(() {
      _tapNum = num;
    });
    if(num == 2){
      await MyAPI(context: context).readUserInfo(userData['id']);
    }
    setState(() {});
  }

  String? path ;

  _pressGrouped() {
    setState(() {
      hOrietation = !hOrietation;
    });
  }

  _pressSort() {
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

  _pressFilter() {
    setState(() {
       _typeController.text = "";
       _modelController.text = "";
       _brandController.text = "";
      _numOfCylYearController.text = "";
      _priceFromController.text = "";
       _priceToController.text = "";
       _dateFromController.text = "";
      _dateToController.text = "";
      filterShow= !filterShow;

    });
  }

  final GlobalKey _dropDownKey = GlobalKey();
  bool sortIncrease = false;

  _dropDown(){
    return DropdownButton<String>(
        key: _dropDownKey,
        underline: DropdownButtonHideUnderline(child: Container(),),
        icon:  SvgPicture.asset('assets/images/ic_sort_less.svg', height: 0.0000001, fit: BoxFit.contain,),
        dropdownColor: MyColors.white.withOpacity(0.9),
        //value: cityName,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.width/25,
            color: MyColors.bodyText1,
            fontFamily: 'Gotham'),
        items: dropDownListString.map((e) => DropdownMenuItem(
            value: e,
            child: SizedBox(width: MediaQuery.of(context).size.width/1.2,
              child: Text(e.toString(),
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width/25,
                    color: MyColors.bodyText1,
                    fontFamily: 'Gotham'),
              ),

            )
            )).toList(),
        selectedItemBuilder: (BuildContext context){
          return dropDownListString.map((e) => Text(e.toString())).toList();
        },

      onChanged: (String? newValue){
        setState(() {
          if(newValue ==  dropDownListString[0]){
            _carSellList.sort((a, b) => b['price'].compareTo(a['price']));
            sortIncrease = false;
          }
          else if(newValue ==  dropDownListString[1]){
            _carSellList.sort((a, b) => a['price'].compareTo(b['price']));
            sortIncrease = true;
          }
          else if(newValue ==  dropDownListString[2]){
            _carSellList.sort((a, b) => b['insertDate'].compareTo(a['insertDate']));
            sortIncrease = false;
          }
          else if(newValue ==  dropDownListString[3]){
            _carSellList.sort((a, b) => a['insertDate'].compareTo(b['insertDate']));
            sortIncrease = true;
          }
          else if(newValue ==  dropDownListString[4]){
            _carSellList.sort((a, b) => b['view'].compareTo(a['view']));
            sortIncrease = false;
          }
          else if(newValue ==  dropDownListString[5]){
            _carSellList.sort((a, b) => a['view'].compareTo(b['view']));
            sortIncrease = true;
          }
        });
      },
    );
  }

  final _typeController = TextEditingController();
  final _modelController = TextEditingController();
  final _brandController = TextEditingController();
  final _numOfCylYearController = TextEditingController();
  final _priceFromController = TextEditingController();
  final _priceToController = TextEditingController();
  final _dateFromController = TextEditingController();
  final _dateToController = TextEditingController();

  final GlobalKey _dropDownKeyType = GlobalKey();
  final GlobalKey _dropDownKeyBrand = GlobalKey();
  final GlobalKey _dropDownKeyModel = GlobalKey();
  final GlobalKey _dropDownKeyNumOfCyl = GlobalKey();
  final GlobalKey _dropDownKeyPriceFrom = GlobalKey();
  final GlobalKey _dropDownKeyPriceTo = GlobalKey();
  final GlobalKey _dropDownKeyDateFrom = GlobalKey();
  final GlobalKey _dropDownKeyDateTo = GlobalKey();


  _dropDownType(width, curve){
    List<String> listType = [];
    for(int i=0; i<_listCarType.length; i++){
      listType.add(listCarType[listCarType.indexWhere((element) => element['id'].toString()==_listCarType[i].toString())]['name']);
    }
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyType,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _typeController.text = chosen.toString();
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }

  _dropDownBrand(width, curve){
    List<String> listType = [];
    for(int i=0; i<_brands.length; i++){
      listType.add(_brands[i]);
    }
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyBrand,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _brandController.text = chosen.toString();
                _modelController.text = '';
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }

  _dropDownModel(width, curve){
    List<String> listType = [];
    for(int i=0; i<_carModelList.length; i++){
      listType.add(_carModelList[i]);
    }
    if(listType.isEmpty) {
     // if(_brandController.text.isEmpty) MyAPI(context: context).flushBar('select Brand before Model');
      //else MyAPI(context: context).flushBar("there isn't model assign selected Brand!");
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyModel,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _modelController.text = chosen.toString();
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }

  _dropDownNumOfSyl(width, curve){
    List<String> listType = [];
    for(int i=0; i<_listNumOfCyl.length; i++){
      listType.add(_listNumOfCyl[i]);
    }
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyNumOfCyl,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _numOfCylYearController.text = chosen.toString();
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }

  _dropDownPriceFrom(width, curve){
    List<String> listType = [];
    for(int i=0; i<_priceFrom.length; i++){
      listType.add(_priceFrom[i]);
    }
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyPriceFrom,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/35,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/35,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _priceFromController.text = chosen.toString();
                if(_priceFromController.text.compareTo(_priceToController.text) >= 0){
                  int i = _priceFrom.indexWhere((element) => element == chosen)+1;
                  if(i>_priceFrom.length-1) i = _priceFrom.length-1;
                  _priceToController.text = _priceFrom[i];
                }
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }

  _dropDownPriceTo(width, curve){
    List<String> listType = [];
    for(int i=0; i<_priceTo.length; i++){
      listType.add(_priceTo[i]);
    }
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyPriceTo,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/35,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/35,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _priceToController.text = chosen.toString();
                if(_priceToController.text.compareTo(_priceFromController.text) <= 0){
                  int i = _priceFrom.indexWhere((element) => element == chosen)-1;
                  if(i<0) i = 0;
                  _priceFromController.text = _priceFrom[i];
                }
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }

  _dropDownDateFrom(width, curve){
    /*List<String> listType = [];
    for(int i=0; i<_dateFrom.length; i++){
      listType.add(_dateFrom[i]);
    }*/
    List<String> listType = [];
    for(int i = 1990; i<DateTime.now().year; i++){
      listType.add(i.toString());
    }

    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyDateFrom,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _dateFromController.text = chosen.toString();
                if(_dateFromController.text.compareTo(_dateToController.text) >= 0){
                  int i = _dateFrom.indexWhere((element) => element == chosen)+1;
                  if(i>_dateFrom.length-1) i = _dateFrom.length-1;
                  _dateToController.text = _dateFrom[i];
                }
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }

  _dropDownDateTo(width, curve){
    /*List<String> listType = [];
    for(int i=0; i<_dateTo.length; i++){
      listType.add(_dateTo[i]);
    }*/
    List<String> listType = [];
    for(int i = 1990; i<DateTime.now().year; i++){
      listType.add(i.toString());
    }
    if(listType.isEmpty) {
      return;
    } else{
      return SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width/6.5,
        child: DropdownButton<String>(
            key: _dropDownKeyDateTo,
            underline: DropdownButtonHideUnderline(child: Container(),),
            icon: const Icon(Icons.search, size: 0.000001,),
            dropdownColor: MyColors.white.withOpacity(0.9),
            //value: cityName,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width/25,
                color: MyColors.black,
                fontFamily: 'Gotham'),
            items: listType.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width/25,
                      color: MyColors.black,
                      fontFamily: 'Gotham'),
                ))).toList(),
            selectedItemBuilder: (BuildContext context){
              return listType.map((e) => Text(e.toString())).toList();
            },
            onChanged: (chosen){
              setState(() {
                _dateToController.text = chosen.toString();
                if(_dateToController.text.compareTo(_dateFromController.text) <= 0){
                  int i = _dateFrom.indexWhere((element) => element == chosen)-1;
                  if(i<0) i = 0;
                  _dateFromController.text = _dateFrom[i];
                }
                //var index = cities.indexWhere((element) => element['name']==chosen);
                //cityId = cities[index]['id'];
                //print(chosen.toString() + cityId.toString());
              });
            }
        ),
      )
      ;
    }
  }

  _yearPicker(id){
    //1 -> from
    //2 -> to
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('Select Year')),
        content: SizedBox( // Need to use container to add size constraint.
          width: MediaQuery.of(context).size.height/4,
          height: MediaQuery.of(context).size.width/1.2,
          child: YearPicker(
            firstDate: DateTime(1940, 1),
            lastDate: DateTime(DateTime.now().year, 1),
            initialDate: DateTime.now(),
            // save the selected date to _selectedDate DateTime variable.
            // It's used to set the previous selected date when
            // re-showing the dialog.
            selectedDate: DateTime.now(),
            onChanged: (DateTime dateTime) {
              // close the dialog when year is selected.
              if(id == 1) {
                _dateFromController.text = dateTime.year.toString();
                if(DateFormat('yyyy').parse(_dateToController.text).compareTo(dateTime) < 0){
                  _dateToController.text = dateTime.year.toString();
                }
              } else if(id == 2) {
                _dateToController.text = dateTime.year.toString();
                if(DateFormat('yyyy').parse(_dateFromController.text).compareTo(dateTime) > 0){
                  _dateFromController.text = dateTime.year.toString();
                }
              }
              Navigator.pop(context);
              // Do something with the dateTime selected.
              // Remember that you need to use dateTime.year to get the year
            },
          ),
        ),
      );
    });
  }
  _openList(dropDownKey) {
    /*if(cities.isEmpty){
      myAPI!.getCities();
      return;
    }*/
    dropDownKey.currentContext?.visitChildElements((element) {
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

  applyFilter() {
    _carSellList.clear();
    for(var item in carSellListBase){
      if(_typeController.text.isEmpty || listCarType[listCarType.indexWhere((element) => element['name'].toString() == _typeController.text)]['id'].toString() == item['type']){
        if(_modelController.text.isEmpty || _modelController.text == item['carModel']){
          if(_numOfCylYearController.text.isEmpty || '${_numOfCylYearController.text} CD' == item['numberOfCylindes']){
            if(_brandController.text.isEmpty || _brandController.text == item['brandName']){
              if(_priceFromController.text.isEmpty || _priceToController.text.isEmpty){
                if(_dateFromController.text.isEmpty || _dateToController.text.isEmpty){
                  _carSellList.add(item);
                }else if(_dateFromController.text.compareTo(item['productionYear'])<=0 && _dateToController.text.compareTo(item['productionYear'])>=0){
                  _carSellList.add(item);
                }
              }
              else if(double.parse(_priceFromController.text)<= double.parse(item['price'].toString().replaceAll(",", "")) && double.parse(_priceToController.text)>=double.parse(item['price'].toString().replaceAll(",", ""))){
              //else if(_priceFromController.text.compareTo(item['price'].toString().replaceAll(",", ""))<=0 && _priceToController.text.compareTo(item['price'].toString().replaceAll(",", ""))>=0){
                if(_dateFromController.text.isEmpty || _dateToController.text.isEmpty){
                  _carSellList.add(item);
                }else if(_dateFromController.text.compareTo(item['productionYear'])<=0 && _dateToController.text.compareTo(item['productionYear'])>=0){
                  _carSellList.add(item);
                }
              }


            }
          }
        }
      }
    }
    setState(() {
      filterShow = false;

    });
  }

  cancleFilter() {
    _carSellList.clear();
    setState(() {
      filterShow = false;

      for(var item in carSellListBase) {
        _carSellList.add(item);
      }

    });

  }

}