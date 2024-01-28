import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/eShop/model/response/orderRead.dart' as order;
import 'package:automall/helper/launchUrlHelper.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
class MainWorkerScreen extends StatefulWidget {
  const MainWorkerScreen({Key? key,}) : super(key: key);

  @override
  State<MainWorkerScreen> createState() => _MainWorkerScreenState();
}

class _MainWorkerScreenState extends State<MainWorkerScreen> {
  List<order.Datum> _orderList = [];
  MyWidget? _m;
  bool _currentOrder = true;
  var _selectId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                      children: _orderList.map((e) => MyWidget.shadowContainer(
                        padding: AppWidth.w4,
                        margin: AppWidth.w4,
                        child: _orderContainer(e),
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

  _orderContainer(order.Datum order){
    return Column(
      children: [
        GestureDetector(
          onTap: ()=> setState(() {
            _selectId = order.purchaseOrder!.customerId.toString();
          }),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _m!.headText('Serial:', scale: 0.7),
                    _m!.headText(order.codeSerial, color: MyColors.qatarColor),
                  ],
                ),
                const VerticalDivider(color: MyColors.mainColor, thickness: 2,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _m!.bodyText1('${order.purchaseOrder!.user==null?'null':order.purchaseOrder!.user!.name}', padding: 0.0, padV: 0.0, color: MyColors.qatarColor),
                    _m!.bodyText1('${order.purchaseOrder!.orderDate!.toIso8601String().split('T')[0]}', padding: 0.0, padV: 0.0),
                  ],
                ),
                const VerticalDivider(color: MyColors.mainColor, thickness: 2),
                Column(
                  children: [
                    Icon(Icons.payments_outlined, size: AppHeight.h6,),
                    _m!.headText('${order.purchaseOrder!.payType == 0?'Card':'Cash'}', color: MyColors.qatarColor, scale: 0.7),
                  ],
                ),
              ],
            ),
          ),
        ),
        _selectId==order.purchaseOrder!.customerId?
        _deliverRow(
          phone: '${order.purchaseOrder!.user==null?'00974':order.purchaseOrder!.user!.mobile}',
          lat: order.purchaseOrder!.profileAddress==null?'':order.purchaseOrder!.profileAddress['lat'].toString(),
          lng: order.purchaseOrder!.profileAddress==null?'':order.purchaseOrder!.profileAddress['lng'].toString(),
          status: order.status??0,
          purchaseOrderProductsId: order.purchaseOrder!.id,
          addressId: order.purchaseOrder!.addressId,
        ):const SizedBox(),
      ],
    );
  }

  _deliverRow({required String phone, required String lat, required String lng, required int status, required purchaseOrderProductsId, required addressId}){
    call(){
      LaunchUrlHelper.makePhoneCall(phone);
    }
    deliver(){
      setState(() {
        pleaseWait = true;
      });
      MyAPI.changeStatusOrderProduct(
          purchaseOrderProductsId: purchaseOrderProductsId,
          status: status == 1 || status == 3?2 : status == 2 ? 4: status,
          addressId: addressId);
      setState(() {
        pleaseWait = false;
      });
    }
    location(){
      LaunchUrlHelper.openMap(lat, lng);

    }
    return Column(
      children: [
        const Divider(color: MyColors.mainColor, thickness: 2,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                IconButton(
                    onPressed: ()=> call(),
                    icon: Icon(Icons.call_outlined, size: AppHeight.h6,)
                ),
                _m!.headText('Call', scale: 0.7, paddingV: AppHeight.h1),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: ()=> location(),
                    icon: Icon(Icons.location_on_outlined, size: AppHeight.h6,)
                ),
                _m!.headText('Location', scale: 0.7, paddingV: AppHeight.h1),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.w2),
                  child: IconButton(
                      onPressed: ()=> deliver(),
                      icon: Icon(Icons.delivery_dining_outlined, size: AppHeight.h6,)
                  ),
                ),
                _m!.headText(status == 1 || status == 3?'Start':'Deliver', scale: 0.7, paddingV: AppHeight.h1),
              ],
            ),

          ],
        ),
      ],
    );
  }

  _refresh(){
      _onPress() async{
        setState(() {
          pleaseWait = true;
        });
        await MyAPI.getWorkerOrderRead();
        if(workerOrderList!= null){
          _orderList = workerOrderList!.data!.toList();
        }
        setState(() {
          pleaseWait = false;
        });
      }
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
