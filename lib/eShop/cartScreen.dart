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
class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}): super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();

  late List<ItemModel> _foundItems = [
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fillFoundItem();
    _searchController.addListener(() {search(); });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.topCon,
      body: Stack(
          children:[
            Column(
              children: [
                TopBarEShop(title: AppLocalizations.of(context)!.translate('Basket')),
                Expanded(
                  child: Stack(
                    children: [
                      Column(
                          children:[
                            Flexible(
                              child: RefreshIndicator(
                                onRefresh: ()=> _pullRefresh(),
                                child: ListView(
                                  children: _foundItems.map((item) {
                                    return _itemContainer(itemModel: item);
                                  }).toList(),
                                ),
                              ),
                            ),
                          ]
                      ),
                    ],
                  ),
                )
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
  search() async{
    setState(() {
      _fillFoundItem();
      if(_searchController.text.length<3){
        return;
      }
      _foundItems = _foundItems.where((element) =>
      element.name.toString().toLowerCase().contains(_searchController.text) ||
          element.attributeValues.toString().toLowerCase().contains(_searchController.text) ||
          element.category.text.toString().toLowerCase().contains(_searchController.text)
      ).toList();

    });
  }

  Widget _itemContainer({
    required ItemModel itemModel
  }){
    ShopHelper shopHelper = ShopHelper(notify: ()=>setState(() {}), itemModel: itemModel);
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Align(child:
              GestureDetector(
                onTap:()=>MyApplication.navigateTo(context, ProductDetails(item: itemModel)),
                child: Container(
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
                  height: AppWidth.w40,
                ),
              ),
              ),
              Align(alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppWidth.w2*0),
                  child: IconButton(onPressed: () =>shopHelper.addToFavorite(), icon: Icon(itemModel.isFavorite? Icons.favorite : Icons.favorite_border,color: MyColors.mainColor,)),
                ),
              ),
            ],
          ),
          SizedBox(height: AppWidth.w1,),
          MyWidget(context).headText(itemModel.name, scale: 0.55, maxLine: 2, align: TextAlign.start, paddingV: AppHeight.h1/2),
          MyWidget(context).bodyText1(itemModel.category.text, padding: 0.0, scale: 0.8, maxLine: 2),
          SizedBox(height: AppHeight.h1,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: AppWidth.w4*1.5,
                  width: AppWidth.w20*1.3,
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
          SizedBox(height: AppWidth.w1,),
          MyWidget(context).headText('${AppLocalizations.of(context)!.translate('Price')}: ${itemModel.price} ${AppLocalizations.of(context)!.translate('currency')}', scale: 0.55, color: MyColors.mainColor),
        ],
      ),
    );
  }

  _pullRefresh() async{
   /* await Future.wait([
      MyAPI.productRead(),
      MyAPI.categoryRead(),
      MyAPI.purchaseOrderRead(),
    ]);*/
    setState(() {
      pleaseWait = false;
      _fillFoundItem();
    });
  }

  _fillFoundItem(){
    checkIsFafourite(productId){
      return false;
    }
    checkAmount(productId){
      return 0;
    }
    getGalaryImages(List<ProductDetailsPic> productDetailsPics){
      List<GalarryItems> pics = [];
      for(var picture in productDetailsPics){
        pics.add(GalarryItems(image: picture.attachment.toString(), id: picture.id!));
      }
      return pics;

    }
    _foundItems.clear();
    if(productList != null && productList!.data != null){
      for(var product in productList!.data!){
        List<int> purchaseAttributeValueIds = [];
        for(var pur in product.purchaseAttributeValues!){
          purchaseAttributeValueIds.add(pur[0].purchaseAttributeValues!.id!);
        }
        _foundItems.add(ItemModel(
          id: product.id.toString(),
          networkImage: product.productDetailsPics![0].attachment!,
          isFavorite: checkIsFafourite(product.id.toString()),
          amount: checkAmount(product.id.toString()),
          name: product.products!.name.toString(),
          category: CategoryModel(id: product.products!.productCategory!.id.toString(), text: product.products!.productCategory!.name!) ,
          price: product.price.toString(),
          imageListGallery: getGalaryImages(product.productDetailsPics!),
          attributeValues: product.attributeValues,
          description: product.products!.description,
          purchaseAttributeValueIds: purchaseAttributeValueIds,
        ));
      }
    }
  }

}
