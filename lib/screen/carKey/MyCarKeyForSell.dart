import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
class MyCarKeyForSell extends StatefulWidget {
  const MyCarKeyForSell({Key? key}) : super(key: key);

  @override
  State<MyCarKeyForSell> createState() => _MyCarKeyForSellState();
}

class _MyCarKeyForSellState extends State<MyCarKeyForSell> {
  List _carBroadKeyList = [];

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
    }catch(e){}
  }

  var _m;
  @override
  Widget build(BuildContext context) {
    var hSpace = MediaQuery.of(context).size.height / 17;
    var curve = MediaQuery.of(context).size.height / 30;
    var width = MediaQuery.of(context).size.width / 1.2;
    _m = MyWidget(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: MyColors.topCon,
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
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(curve),
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
                              }
                          );
                        },
                      ),
                    ),
                  )
                  ,
                ],
              )
            ),
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

}
