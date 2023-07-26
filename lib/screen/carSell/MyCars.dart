import 'package:automall/MyWidget.dart';
import 'package:automall/color/MyColors.dart';
import 'package:automall/const.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
class MyCarsForSell extends StatefulWidget {
  const MyCarsForSell({Key? key}) : super(key: key);
  @override
  State<MyCarsForSell> createState() => _MyCarsForSellState();
}

class _MyCarsForSellState extends State<MyCarsForSell> {
  List _carSellList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 0; i<carSellsList.length; i++) {
      _carSellList.add({
        'id': carSellsList[i]['id'].toString(),
        'type': carSellsList[i]['type'].toString(),
        'carModel': carModelList[carModelList.indexWhere((
            element) => carSellsList[i]['carModelId'] == element['id'])]['name']
            .toString(),
        'image': carSellsList[i]['mainAttachment'].toString(),
        'brandLogo': brands[brands.indexWhere((
            element) => carSellsList[i]['brandId'] == element['id'])]['logo']
            .toString(),
        'brandName': brands[brands.indexWhere((
            element) => carSellsList[i]['brandId'] == element['id'])]['name']
            .toString(),
        'kelometrage': formatter.format(carSellsList[i]['kelometrage'])
            .toString(),
        'price': formatter.format(carSellsList[i]['price']).toString(),
        'productionYear': carSellsList[i]['productionYear'].toString(),
        'gearBoxType': carSellsList[i]['gearBoxType'].toString(),
        'view': carSellsList[i]['viewCount'].toString(),
        'numberOfCylindes': carSellsList[i]['numberOfCylindes'].toString(),
        'fromUser': carSellsList[i]['user']['type'] == 0 ? true : false,
        'isNew': true
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var curve = MediaQuery.of(context).size.height / 30;
    return Scaffold(
      body: Column(
        children: [
          _topBar(curve),
          _carSellList.isEmpty?Expanded(
            child: Center(
              child: MyWidget(context).headText(AppLocalizations.of(context)!.translate("There isn't!")),
            ),
          ): Expanded(
              child: ListView(
                children: _carSellList.map((e) => _carSellCard(e)).toList(),
              ),
          ),
        ],
      ),
    );
  }

  _topBar(curve) {
    return Container(
      //centerTitle: true,
      //height: barHight,
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
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
                  child: MyWidget(context).titleText1(
                      AppLocalizations.of(context)!.translate('name')),
                ),
                Expanded(
                  flex: 1,
                  child: MyWidget(context).notificationButton(),
                ),
              ],
            ),
            const SizedBox()
            ,
          ],
        )
    );
  }

  Widget _carSellCard(carSell){
    //index = 0;
      return MyWidget(context).carSellerHCard(
          carSell['image'],
          carSell['brandLogo'],
          listCarType[listCarType.indexWhere((element) => element['id'].toString()==carSell['type'])]['name'],
          carSell['carModel'],
          carSell['kelometrage']+  AppLocalizations.of(context)!.translate('Km'),
          AppLocalizations.of(context)!.translate('Engine') + ": " +  carSell['numberOfCylindes'] + AppLocalizations.of(context)!.translate("Cylinders"),
          AppLocalizations.of(context)!.translate('Price') + ": " + carSell['price'],
          AppLocalizations.of(context)!.translate('Gear') + ": " +
              listGearBoxCarType[listGearBoxCarType.indexWhere((element) => carSell['gearBoxType'] == element['id'].toString())]['name'],
          AppLocalizations.of(context)!.translate('Man. Date: ') + carSell['productionYear'],
          carSell['view'] + " " + AppLocalizations.of(context)!.translate('View'),
          carSell['fromUser'],
          carSell['isNew']
      );

  }

}
