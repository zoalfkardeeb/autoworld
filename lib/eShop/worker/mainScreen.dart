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
                  const SizedBox(height: 3,),
                  Expanded(
                    flex: 1,
                    child: ListView(

                      children: order.map((e) => MyWidget.shadowContainer(
                        padding: AppWidth.w4,
                        margin: AppWidth.w4,
                        child: _orderContainer(),
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


}
