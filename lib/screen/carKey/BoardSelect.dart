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

  List<String> imageList = [];
  ImageProvider? image;

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
                            childAspectRatio: 1,
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
        _carBroadKeyList[index]['keyView']);
  }


  _setState() {
    setState(() {

    });
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
                      child: _m!.titleText1(
                          AppLocalizations.of(context)!.translate('name')),
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

}