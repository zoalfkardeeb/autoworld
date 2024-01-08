import 'package:automall/MyWidget.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/eShop/model/categoryModel.dart';
import 'package:automall/eShop/model/itemModel.dart';
import 'package:automall/eShop/model/response/productRead.dart';
import 'package:automall/eShop/productDetails.dart';
import 'package:automall/eShop/shopHelper.dart';
import 'package:automall/eShop/topBar.dart';
import 'package:automall/helper/functions.dart';
import 'package:automall/localizations.dart';
import 'package:automall/photoView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class TrackOrders extends StatefulWidget {
  const TrackOrders({Key? key}) : super(key: key);

  @override
  State<TrackOrders> createState() => _TrackOrdersState();
}

class _TrackOrdersState extends State<TrackOrders> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late List<ItemModel> _foundItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fillFoundItem();
  }
  @override
  Widget build(BuildContext context) {
    _fillFoundItem();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.topCon,
      body: Stack(
          children:[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopBarEShop(title: AppLocalizations.of(context)!.translate('Track Your Order'), navCart: false,),
                Expanded(
                  child: Column(
                      children:[
                        Flexible(
                          child: RefreshIndicator(
                            onRefresh: ()=> _refresh(),
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: AppWidth.w4*1.5, vertical: AppHeight.h1),
                              children: _foundItems.map((item) {
                                return _itemContainer(itemModel: item);
                              }).toList(),
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                MyWidget(context).bottomContainer(
                    GestureDetector(
                      onTap:() => _spport(),
                      child: MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('Support'), color: MyColors.white, scale: 1.4),
                    ),
                    AppWidth.w8, bottomConRati: 0.08, color: MyColors.mainColor)

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

  Widget _itemContainer({
    required ItemModel itemModel
  }){
    ShopHelper shopHelper = ShopHelper(notify: ()=>setState(() {}), itemModel: itemModel);
    return MyWidget.shadowContainer(
      padding: 0.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppWidth.w2)),
              color: MyColors.qatarColor,
            ),
            padding: EdgeInsets.symmetric(horizontal: AppWidth.w4, vertical: AppHeight.h1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyWidget(context).bodyText1(itemModel.orderSerial??'', padding: 0.0, scale: 0.8, maxLine: 1, color: MyColors.white,),
                MyWidget(context).bodyText1(DateFormat('E d LLL y H:m').format(itemModel.orderDate!), padding: 0.0, scale: 0.8, maxLine: 1, color: MyColors.white,),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap:()=>MyApplication.navigateTo(context, ProductDetails(item: itemModel)),
                child: Container(
                  margin: EdgeInsets.all(AppWidth.w2),
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(
                        color: MyColors.black,
                        offset: Offset(1, 2),
                        blurRadius: 4,
                      )],
                      color: MyColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(AppWidth.w2)),
                      image: DecorationImage(image: NetworkImage(itemModel.networkImage), fit: BoxFit.cover,)
                  ),
                  height: AppWidth.w24,
                  width: AppWidth.w24,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyWidget(context).headText(itemModel.name, scale: 0.55, maxLine: 2, align: TextAlign.start, paddingV: AppHeight.h1/3),
                    MyWidget(context).bodyText1('${AppLocalizations.of(context)!.translate('Quantity')} ${itemModel.amount}', padding: 0.0, scale: 0.8, maxLine: 2),
                    SizedBox(height: AppWidth.w1,),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: AppHeight.h1/2, horizontal: AppWidth.w4*1.5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.storefront_outlined, color: _statusColor(itemModel.status)),
                          Icon(Icons.payments_outlined, color: _statusColor(itemModel.status)),
                          Icon(Icons.delivery_dining_outlined, color: _statusColor(itemModel.status)),
                          Icon(Icons.fact_check_outlined, color: _statusColor(itemModel.status)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _fillFoundItem(){
    checkIsFafourite(productId){
      return false;
    }
    checkAmount(productId){
      return 1;
    }
    getGalaryImages(List<ProductDetailsPic> productDetailsPics){
      List<GalarryItems> pics = [];
      for(var picture in productDetailsPics){
        pics.add(GalarryItems(image: picture.attachment.toString(), id: picture.id!));
      }
      return pics;
    }
    _foundItems.clear();
    if(orderProductList != null && orderProductList!.data != null){
      for(var product in orderProductList!.data!){
        List<int> purchaseAttributeValueIds = [];
        for(var pur in product.purchaseOrderProductsAttr!){
          purchaseAttributeValueIds.add(pur.purchaseAttributeValuesId!);
        }
        _foundItems.add(ItemModel(
          // purchaseAttributeValues: product.purchaseAttributeValues!,
          status: product.status,
          orderSerial: '${product.codeSerial??''}',
          orderDate: product.purchaseOrder?.insertDate??DateTime.now(),
          suppliers: product.productDetails!.suppliers!,
          id: product.id.toString(),
          networkImage: product.productDetails!.productDetailsPics![0].attachment!,
          isFavorite: checkIsFafourite(product.id.toString()),
          amount: product.quantity!,
          name: product.productDetails!.products!.name.toString(),
          category: CategoryModel(id: product.productDetails!.products!.productCategory!.id.toString(), text: product.productDetails!.products!.productCategory!.name!) ,
          price: product.price.toString(),
          imageListGallery: getGalaryImages(product.productDetails!.productDetailsPics!),
          attributeValues:" product.attributeValues",
          // description: product.productDetails.products..description??"",
          purchaseAttributeValueIds: purchaseAttributeValueIds,
        ));
      }
    }
  }

  _refresh() async{

  }

  _spport() {}

  _statusColor(int? status){
    status??=0;
    var color = MyColors.card;
    switch(status.toString()){
      case '0':
        color = MyColors.card;
        break;
      case '1':
        color = MyColors.qatarColor;
        break;
      case '2':
        color = MyColors.black;
        break;
    }
    return color;
  }
}
