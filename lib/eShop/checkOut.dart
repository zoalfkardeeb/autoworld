import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/constant/font_size.dart';
import 'package:automall/eShop/model/categoryModel.dart';
import 'package:automall/eShop/model/itemModel.dart';
import 'package:automall/eShop/model/response/productRead.dart';
import 'package:automall/eShop/productDetails.dart';
import 'package:automall/eShop/shopHelper.dart';
import 'package:automall/eShop/topBar.dart';
import 'package:automall/eShop/trackOrder.dart';
import 'package:automall/helper/functions.dart';
import 'package:automall/localizations.dart';
import 'package:automall/model/request/address.dart';
import 'package:automall/photoView.dart';
import 'package:automall/screen/address/addAddress.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:automall/model/response/addressRead.dart' as addressRead;
class CheckOutScreen extends StatefulWidget {
  List<ItemModel> foundItems;
  CheckOutScreen({Key? key, required this.foundItems}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late List<ItemModel> _foundItems = [];

  // 1 : card
  // 2 : on delivery
  late int _payType; // 3:OnDelivery, 1: Paid


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payType = 3;
    _foundItems = widget.foundItems;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.topCon,
      body: Stack(
          children:[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopBarEShop(title: AppLocalizations.of(context)!.translate('Check out'), navCart: false,),
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _selectAddress(),
                          _phoneNumber(),
                          SizedBox(height: AppHeight.h1,),
                          _paymentSummery(),
                          _payWith()
                        ],
                      ),
                    )
                ),
                MyWidget(context).bottomContainer(
                    GestureDetector(
                      onTap:() => _selectedAddress==null?null:_placeOrder(),
                      child: MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('Place Order'), color: MyColors.white, scale: 1.4),
                    ),
                    AppWidth.w8, bottomConRati: 0.08, color: _selectedAddress!=null?MyColors.mainColor:MyColors.card)
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: pleaseWait?
              MyWidget(context).progress()
                  :
              const SizedBox(),
            )
          ]
      ),
    );
  }

  _placeOrder() async{
    List<Future> d = [];
    for(var v in _foundItems){
      d.add(MyAPI.changeStatusOrderProduct(purchaseOrderProductsId: v.purchaseOrderProductId.toString(), status: _payType, addressId: _selectedAddress!.id.toString()));
    }
    setState(() {
      pleaseWait = true;
    });
    await Future.wait(d);
    await MyAPI.getOrderProductList();
    setState(() {
      pleaseWait = false;
    });
    // ignore: use_build_context_synchronously
    MyApplication.navigateToReplace(context, const TrackOrders());
  }

  double _calkTotal(){
    var total = 0.0;
    for(var v in _foundItems){
      total = total + v.amount * double.parse(v.price);
    }
    return total;
  }

  addressRead.Datum? _selectedAddress;

  Widget _selectAddress(){
    List<String> items = [];
    if(addressList!=null){
      for(var i in addressList!.data!){
        items.add(i.title??'');
      }
    }
    if(items.isNotEmpty) _selectedAddress = addressList!.data![0];
    items.add(AppLocalizations.of(context)!.translate('Add new Address'));
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppHeight.h2),
        child: Column(
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Row(
                  children: [
                    Icon(
                      Icons.list,
                      size: AppHeight.h2,
                      color: MyColors.black,
                    ),
                    SizedBox(
                      width: AppWidth.w2*0,
                    ),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.translate('Select Address'),
                        style: TextStyle(
                          fontSize: FontSize.s16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: items.map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: FontSize.s16,
                      fontWeight: FontWeight.bold,
                      color: MyColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
                    .toList(),
                value: _selectedAddress==null? AppLocalizations.of(context)!.translate('Add new Address') : _selectedAddress!.title,
                onChanged: (String? value) {
                  if(value == AppLocalizations.of(context)!.translate('Add new Address')){
                    MyApplication.navigateToReplace(context, AddAddress(address: AddressRequest(userId: userInfo['id'])));
                  }
                  else{
                    _selectedAddress = addressList!.data!.where((element) => element.title == value).toList().first;
                  }
                  setState(() {

                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: AppHeight.h4*1.2,
                  width: AppWidth.w80,
                  padding: EdgeInsets.symmetric(horizontal:AppWidth.w2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppWidth.w2),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: MyColors.topCon,
                  ),
                  elevation: 1,
                ),
                iconStyleData: IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,size: AppHeight.h4,
                  ),
                  iconSize: 14,
                  iconEnabledColor: MyColors.black,
                  iconDisabledColor: Colors.grey,
                  openMenuIcon: Icon(
                    Icons.arrow_drop_up,size: AppHeight.h4,
                  ),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: AppHeight.h30,
                  width: AppWidth.w80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppWidth.w2),
                    color: MyColors.topCon,
                  ),
                  offset: const Offset(0, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all<double>(2),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData:  MenuItemStyleData(
                  height: AppHeight.h4,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
            _selectedAddress!=null?
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppWidth.w8, vertical: AppHeight.h1),
              child: SizedBox(
                width: AppWidth.w80,
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Expanded(
                      child: MyWidget(context).bodyText1(_selectedAddress!.notes, padding: AppWidth.w1),),
                  ],
                ),
              ),
            ):SizedBox()
          ],
        ),
      ),
    );
  }

  _paymentSummery() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppHeight.h1, horizontal: AppWidth.w12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyWidget(context).headText('Payment summery', scale: 0.7),
          /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyWidget(context).bodyText1('Subtotal', padding: 0.0),
              MyWidget(context).bodyText1('Subtotal', padding: 0.0),
            ],
          ),
         */
          SizedBox(height: AppHeight.h1,),
          const Divider(height: 6, color: MyColors.black, thickness: 2,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyWidget(context).headText('Total amount', scale: 0.6),
              MyWidget(context).headText('${_calkTotal()} ${AppLocalizations.of(context)!.translate('currency')}', scale: 0.6, color: MyColors.mainColor),
            ],
          ),
          SizedBox(height: AppHeight.h1,),
        ],
      ),
    );
  }

  _payWith() {
    return Container(
      width: AppWidth.w80,
        padding: EdgeInsets.symmetric(vertical: AppHeight.h1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyWidget(context).headText('${AppLocalizations.of(context)!.translate('Pay with')}', scale: 0.7),
                Row(
                  children: [
                    IconButton(onPressed: ()=> _changePayType(1), icon: Icon(_payType==1?Icons.check_circle_outline:Icons.circle_outlined)),
                    MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('Card'), padding: 0.0),
                  ],
                ),
                Row(
                  children: [
                    IconButton(onPressed: ()=> _changePayType(3), icon: Icon(_payType==3?Icons.check_circle_outline:Icons.circle_outlined)),
                    MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('On Delivery'), padding: 0.0),
                  ],
                ),
              ],
            ),
    );
  }

  _changePayType(int payType) {
    _payType = payType;
    print(_payType);
    setState(() {
    });
  }

  _phoneNumber() {
    return SizedBox(
      width: AppWidth.w80,
      child: MyWidget.shadowContainer(
        padding: 0.0,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                  child: MyWidget(context).headText(AppLocalizations.of(context)!.translate('Phone Number'), scale: 0.6),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: MyWidget(context).bodyText1(userInfo['mobile'], padV: AppHeight.h2, scale: 1,padding: 2.0),
                  decoration: BoxDecoration(
                      color: MyColors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(AppWidth.w2), bottomRight: Radius.circular(AppWidth.w2)),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

}
