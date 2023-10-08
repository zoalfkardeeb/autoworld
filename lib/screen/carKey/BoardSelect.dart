// ignore_for_file: file_names
import 'package:automall/api.dart';
import 'package:automall/constant/color/MyColors.dart';

import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:automall/screen/carKey/CarBoardDetails.dart';
import 'package:automall/screen/garageCountry.dart';
import 'package:automall/screen/suplierScreen.dart';
import 'package:automall/screen/carSell/AddSellCarScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../MyWidget.dart';
// ignore: camel_case_types
class BoardSelect extends StatefulWidget {
  const BoardSelect({Key? key}) : super(key: key);

  @override
  State<BoardSelect> createState() => _BoardSelectState();
}

class _BoardSelectState extends State<BoardSelect> {
  MyWidget? _m;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey _dropDownKey = GlobalKey();
  bool sortIncrease = false;

  List<String> imageList = [];
  ImageProvider? image;
  List<String> dropDownListString = [];

  List _carBroadKeyList = [];
  List carBroadKeyListBase = [];
  var _tapNum = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    try{
      _carBroadKeyList.clear();
      for(int i = 0; i<carBroadKeyList.length; i++){
        _carBroadKeyList.add({
          'id': carBroadKeyList[i]['id'].toString(),
          'keyNum': carBroadKeyList[i]['carKeyNum'].toString(),
          'user': carBroadKeyList[i]['user'],
          'keyUser': carBroadKeyList[i]['user']['name'],
          'keyPrice': carBroadKeyList[i]['price'].toString() ,
          'isSold': carBroadKeyList[i]['isSold'],
          'keyView': carBroadKeyList[i]['viewCount'].toString(),
        });
      }
      for(var item in _carBroadKeyList) {
        carBroadKeyListBase.add(item);
      }
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
   /* dropDownListString.add(AppLocalizations.of(context)!.translate('Sort By Date From High to Low'));
    dropDownListString.add(AppLocalizations.of(context)!.translate('Sort By Date From Low to High'));
   */
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
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                top: MediaQuery.of(context).size.height / 40*0,
              ),
              child: _tapNum == 1?
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
                  //SizedBox(height: hSpace/2,),
                  _carBroadKeyList.isEmpty?Expanded(
                    child: Center(
                      child: _m!.headText(AppLocalizations.of(context)!.translate("There isn't!")),
                    ),

                  ):
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: curve/2),
                      child: GridView.builder(
                        itemCount: _carBroadKeyList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.2,
                            crossAxisCount: 2),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              child: _carSellCard(index),
                              onTap: () => {
                                MyAPI(context: context).addViewCarBoard(_carBroadKeyList[index]['id']),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>  CarBoardDetails(indexCarBoard: carBroadKeyList.indexWhere((element) => element['id'] == _carBroadKeyList[index]['id'])),
                                    )),
                              }
                          );
                        },
                      ),
                    ),
                  )
                  ,
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
    return MyWidget(context).carBroadKeyCard(
        _carBroadKeyList[index]['keyNum'],
        _carBroadKeyList[index]['keyUser'],
        _carBroadKeyList[index]['keyPrice'],
        _carBroadKeyList[index]['keyView'],
      state: _carBroadKeyList[index]['isSold']
    );
  }

  _setState() {
    setState(() {

    });
  }

  _iconCenter(svgImage, Function() onPressed){
    return IconButton(
      icon: Align(
        alignment: Alignment.center,
        child: SvgPicture.asset(svgImage, height: MediaQuery.of(context).size.width/20, fit: BoxFit.contain, color: MyColors.gray,),),
      onPressed: () => onPressed(),
    );
  }
  _topBar(curve) {
    var padT = MediaQuery.of(context).size.height/30;

    return Container(
      //centerTitle: true,
      //height: MediaQuery.of(context).size.height/10,
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
          boxShadow: [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],    ),
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
                          child: Icon(Icons.arrow_back_ios),
                        ),
                        onPressed: ()=> Navigator.of(context).pop(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: _iconCenter(/*sortIncrease?"assets/images/ic_sort_increase.svg":"assets/images/ic_sort_less.svg"*/"assets/images/ic_sort1.svg", () => _pressSort()),
                    ),
                    /*Expanded(
                      flex: 1,
                      child: _m!.titleText1(
                          AppLocalizations.of(context)!.translate('name')),
                    ),*/
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
            _carBroadKeyList.sort((a, b) => b['keyPrice'].compareTo(a['keyPrice']));
            sortIncrease = false;
          }
          else if(newValue ==  dropDownListString[1]){
            _carBroadKeyList.sort((a, b) => a['keyPrice'].compareTo(b['keyPrice']));
            sortIncrease = true;
          }
          /*else if(newValue ==  dropDownListString[2]){
            _carBroadKeyList.sort((a, b) => b['insertDate'].compareTo(a['insertDate']));
            sortIncrease = false;
          }
          else if(newValue ==  dropDownListString[3]){
            _carBroadKeyList.sort((a, b) => a['insertDate'].compareTo(b['insertDate']));
            sortIncrease = true;
          }*/
          else if(newValue ==  dropDownListString[2]){
            _carBroadKeyList.sort((a, b) => b['keyView'].compareTo(a['keyView']));
            sortIncrease = false;
          }
          else if(newValue ==  dropDownListString[3]){
            _carBroadKeyList.sort((a, b) => a['keyView'].compareTo(b['keyView']));
            sortIncrease = true;
          }
        });
      },
    );
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
}