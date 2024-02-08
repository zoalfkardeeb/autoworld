import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/eShop/checkOut.dart';
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
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}): super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
                TopBarEShop(title: AppLocalizations.of(context)!.translate('Basket'), navCart: false,),
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
                _paymentSummery(),
                MyWidget(context).bottomContainer(
                    GestureDetector(
                      onTap:() => _calkTotal()==0? null : _checkOut(),
                      child: MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('Check out'), color: MyColors.white, scale: 1.4),
                    ),
                    AppWidth.w8, bottomConRati: 0.08, color: _calkTotal()==0? MyColors.card : MyColors.mainColor)

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
            padding: EdgeInsets.symmetric(horizontal: AppWidth.w4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyWidget(context).bodyText1(itemModel.suppliers.fullName??'', padding: 0.0, scale: 0.8, maxLine: 1, color: MyColors.white, underLine: true, padV: AppHeight.h1),
                //IconButton(onPressed: ()=> select(itemModel), icon: Icon(itemModel.isSelect! ? Icons.check_circle:Icons.circle_outlined, color: MyColors.white,)),
              ],
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap:()=>null,//MyApplication.navigateTo(context, ProductDetails(item: itemModel)),
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
              SizedBox(
                width: AppWidth.w30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyWidget(context).headText(itemModel.name, scale: 0.55, maxLine: 2, align: TextAlign.start, paddingV: AppHeight.h1/2),
                    MyWidget(context).bodyText1(itemModel.category.text, padding: 0.0, scale: 0.8, maxLine: 2),
                    SizedBox(height: AppWidth.w1,),
                    MyWidget(context).headText('${AppLocalizations.of(context)!.translate('Price')}: ${itemModel.price} ${AppLocalizations.of(context)!.translate('currency')}', scale: 0.5, color: MyColors.mainColor),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  height: AppWidth.w4*1.5,
                  width: AppWidth.w20*1.3,
                  margin: EdgeInsets.symmetric(horizontal: AppWidth.w2),
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.w1),
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.mainColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(AppWidth.w1)),
                  ),
                  child: itemModel.amount != 0?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: AppWidth.w5,
                          height: AppWidth.w5,
                          child: IconButton(onPressed: ()=> shopHelper.removeItem(), icon: Icon(Icons.remove,size: AppWidth.w4,color: MyColors.mainColor), padding: const EdgeInsets.all(0.1))),
                      const VerticalDivider(color: MyColors.mainColor, thickness: 1,),
                      MyWidget(context).headText('${itemModel.amount}', scale: 0.5, color: MyColors.mainColor),
                      const VerticalDivider(color: MyColors.mainColor, thickness: 1,),
                      SizedBox(
                          width: AppWidth.w5,
                          height: AppWidth.w5,
                          child: IconButton(onPressed: ()=> shopHelper.addItem(), icon: Icon(Icons.add, size: AppWidth.w4,color: MyColors.mainColor), padding: const EdgeInsets.all(0.1),)),
                    ],
                  )
                      :
                  SizedBox(
                      width: AppWidth.w5,
                      height: AppWidth.w5,
                      child: IconButton(onPressed: ()=> shopHelper.addItem(), icon: Icon(Icons.add, size: AppWidth.w4,color: MyColors.mainColor), padding: const EdgeInsets.all(0.1),)),

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
    if(cartProductList != null && cartProductList!.data != null){
      for(var product in cartProductList!.data!){
        List<int> purchaseAttributeValueIds = [];
        for(var pur in product.purchaseOrderProductsAttr!){
          purchaseAttributeValueIds.add(pur.purchaseAttributeValuesId!);
        }
        _foundItems.add(ItemModel(
          code: product.productDetails!.code,
          //purchaseAttributeValues: product.productDetails.products.,
          storeQuantity: product.productDetails!.storeQuantity!,
          purchaseOrderProductId: product.id,
          purchaseOrderId: product.purchaseOrder!.id,
          suppliers: product.productDetails!.suppliers!,
          id: product.productDetails!.id.toString(),
          networkImage: product.productDetails!.productDetailsPics![0].attachment!,
          isFavorite: checkIsFafourite(product.productDetails!.id.toString()),
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

  select(ItemModel itemModel) {
    itemModel.isSelect = !itemModel.isSelect;
    setState(() {

    });
  }

  _refresh() async{}

  _checkOut() async{
    setState(() {
      pleaseWait = true;
    });
    await MyAPI.addressRead();
    setState(() {
      pleaseWait = false;
    });
    // ignore: use_build_context_synchronously
    MyApplication.navigateToReplace(context, CheckOutScreen(foundItems: _foundItems,));
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

  double _calkTotal(){
    var total = 0.0;
    for(var v in _foundItems){
      if(v.isSelect) total = total + v.amount * double.parse(v.price);
    }
    return total;
  }
}
