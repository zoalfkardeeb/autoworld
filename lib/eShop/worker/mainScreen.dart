import 'package:automall/MyWidget.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
class MainWorkerScreen extends StatefulWidget {
  const MainWorkerScreen({Key? key,}) : super(key: key);

  @override
  State<MainWorkerScreen> createState() => _MainWorkerScreenState();
}

class _MainWorkerScreenState extends State<MainWorkerScreen> {
  List order = ['',''];
  MyWidget? _m;
  bool _currentOrder = true;

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.only(
                //left: MediaQuery.of(context).size.width/20,
                //right: MediaQuery.of(context).size.width/20,
                //top: MediaQuery.of(context).size.height / 40,
              ),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _topBar(AppWidth.w8),
                  SizedBox(height: AppHeight.h1,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppWidth.w4),
                    child: Row(
                      children: [
                        Flexible(
                          child: GestureDetector(
                            child: MyWidget.shadowContainer(
                                child: MyWidget(context).headText(
                                    AppLocalizations.of(context)!.translate('Current Order'), scale: 0.7,
                                    color: _currentOrder? MyColors.mainColor : MyColors.black),
                              color: _currentOrder? MyColors.mainColor: MyColors.black,
                            ),
                            onTap: ()=> _changeCurrentOrder(),
                          ),
                        ),
                        SizedBox(width: AppWidth.w4,),
                        Flexible(
                          child: GestureDetector(
                            child: MyWidget.shadowContainer(
                              child: MyWidget(context).headText(
                                  AppLocalizations.of(context)!.translate('Delivered Order'), scale: 0.7,
                                  color: _currentOrder? MyColors.black : MyColors.mainColor),
                              color: _currentOrder? MyColors.black : MyColors.mainColor,
                            ),
                              onTap: ()=> _changeCurrentOrder()),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 0.0),
                      children: order.map((e) => MyWidget.shadowContainer(
                        padding: AppWidth.w4,
                        margin: AppWidth.w4,
                        child: _orderContainer(),
                       // color: MyColors.mainColor
                      ),).toList(),
                    )
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MediaQuery
                .of(context)
                .viewInsets
                .bottom == 0 ?
            _m!.bottomContainer(
                SizedBox(),
                AppWidth.w4)
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

  _orderContainer(){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _m!.headText('Serial'),
                _m!.headText('Serial'),
              ],
            ),
            const VerticalDivider(color: MyColors.mainColor),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _m!.bodyText1('Serial', padding: 0.0, padV: 0.0),
                _m!.bodyText1('Serial', padding: 0.0, padV: 0.0),
              ],
            ),
            const VerticalDivider(color: MyColors.mainColor),
            Icon(Icons.payments_outlined, size: AppHeight.h6,),
          ],
        ),
        _deliverRow(),
      ],
    );
  }

  _deliverRow(){
    call(){

    }
    deliver(){}
    location(){

    }
    return Column(
      children: [
        const Divider(color: MyColors.mainColor,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: ()=> call(),
                icon: Icon(Icons.call_outlined, size: AppHeight.h6,)
            ),
            IconButton(
                onPressed: ()=> location(),
                icon: Icon(Icons.location_on_outlined, size: AppHeight.h6,)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppWidth.w2),
              child: IconButton(
                  onPressed: ()=> deliver(),
                  icon: Icon(Icons.delivery_dining_outlined, size: AppHeight.h6,)
              ),
            ),

          ],
        ),
      ],
    );
  }

  _refresh(){
      _onPress(){}
      return Align(
        alignment: lng==2?Alignment.centerLeft:Alignment.centerRight,
        child: IconButton(
          icon: const Icon(Icons.refresh_outlined, color: MyColors.black,),
          onPressed: () => _onPress(),
        ),);
    }

  _topBar(curve) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
          boxShadow: const [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )], ),
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
                      alignment: lng == 2 ? Alignment.centerRight : Alignment.centerLeft,
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    onPressed: ()=> Navigator.of(context).pop(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _m!.titleText1(AppLocalizations.of(context)!.translate('My Orders')),
                ),
                Expanded(
                  flex: 1,
                  child: _refresh(),
                ),
              ],
            ),
          ],
        )
    );
  }

  _changeCurrentOrder(){
    _currentOrder=!_currentOrder;
    setState(() {});
  }

}
