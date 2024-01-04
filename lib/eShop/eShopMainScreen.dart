import 'package:automall/MyWidget.dart';
import 'package:automall/api.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/constant/images/imagePath.dart';
import 'package:automall/eShop/filter.dart';
import 'package:automall/eShop/model/categoryModel.dart';
import 'package:automall/eShop/model/itemModel.dart';
import 'package:automall/eShop/model/response/productRead.dart';
import 'package:automall/eShop/productDetails.dart';
import 'package:automall/eShop/shopHelper.dart';
import 'package:automall/eShop/topBar.dart';
import 'package:automall/helper/functions.dart';
import 'package:automall/localizations.dart';
import 'package:automall/main.dart';
import 'package:automall/photoView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
class EShopMainScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  const EShopMainScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<EShopMainScreen> createState() => _EShopMainScreenState();
}

bool showFilter = false, applyFilter = false;
Filter? selectedBrand;

class _EShopMainScreenState extends State<EShopMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  final List<CategoryModel> _categoryList = [
    CategoryModel(id: 'id1', text: 'text'),
    CategoryModel(id: 'id2', text: 'text'),
    CategoryModel(id: 'id3', text: 'text'),
  ];

  late List<ItemModel> _foundItems = [
     ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fillFoundItem();
    _fillCategory();
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
            TopBarEShop(title: AppLocalizations.of(context)!.translate('E-Shop')),
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children:[
                      _search(),
                      _horizontalScrolCategory(),
                      Flexible(
                        child: RefreshIndicator(
                          onRefresh: ()=> _pullRefresh(),
                          child: GridView.count(
                            childAspectRatio: AppWidth.w50/AppWidth.w70/1.05,
                            //maxCrossAxisExtent: AppWidth.w70, // maximum item width
                            mainAxisSpacing: AppWidth.w4, // spacing between rows
                            crossAxisSpacing: AppWidth.w4, // spacing between columns
                            padding: EdgeInsets.symmetric(horizontal: AppWidth.w4, vertical: AppHeight.h2),
                            crossAxisCount: 2,
                            children: _foundItems.map((item) {
                              return _itemContainer(itemModel: item);
                            }).toList(),
                          ),
                        ),
                      ),
                    ]
                  ),
                  showFilter?
                  FilterE_shop(notify: () => setState(() {_fillFoundItem();}),).animate().fadeIn(duration: 300.ms):const SizedBox(),
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
      _filterCategory();
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
  Widget _search() {

    filter() async{
      setState(() {
        if(applyFilter) {
          applyFilter = false;
        }else{
          showFilter = true;
        }
        _fillFoundItem();
      });
    }
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: AppHeight.h2,
          horizontal: AppWidth.w4),
      child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: AppWidth.w90,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 0.01),
                suffixIconColor: MyColors.black,
                prefixIconColor: MyColors.black,
                prefixIcon:  IconButton(onPressed: ()=> search(), icon: const Icon(Icons.search)),
                suffixIcon: IconButton(onPressed: ()=> filter(), icon: Icon(applyFilter? Icons.filter_alt_off_outlined : Icons.list)),
                enabledBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(AppWidth.w2 * 1.5)),
                  borderSide: const BorderSide(color: MyColors.black),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppWidth.w5)),
                    //borderSide: const BorderSide(color: MyColors.mainColor)
                ),
                hintText: AppLocalizations.of(context)!.translate('Search'),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppWidth.w5)),
                   // borderSide: const BorderSide(color: MyColors.mainColor)
                ),
              ),
            ),
          ),
          //IconButton(onPressed: ()=> search(), icon: Icon(Icons.manage_search_outlined))
          //MyWidget(context).raisedButton(AppLocalizations.of(context)!.translate('Go'), ()=> search(), AppWidth.w20, chLogIn, textH: FontSize.s18, buttonText: AppColors.mainColor, colorText: AppColors.white)
        ],
      ),
    );
  }

  Widget _horizontalScrolCategory() {
    filter({required categoryId}){
      for(var c in _categoryList){
        c.select = false;
      }
      _categoryList.where((element) => element.id == categoryId).first.select = true;
      _filterCategory();
      setState(() {});
    }
    Widget text({required text, required select, required categoyId}){
      return GestureDetector(
        onTap: () => filter(categoryId: categoyId),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.w2, vertical: AppWidth.w1),
          margin: EdgeInsets.symmetric(horizontal: AppWidth.w1),
          decoration: BoxDecoration(
            color: select? MyColors.mainColor: MyColors.trans,
            borderRadius: BorderRadius.all(Radius.circular(AppWidth.w2)),
            border: Border.all(color: select? MyColors.mainColor: MyColors.trans)
          ),
          child: MyWidget(context).headText(text, scale: 0.7, color: select? MyColors.white: MyColors.black),
        ),
      );
    }
    return SingleChildScrollView(
      scrollDirection:Axis.horizontal,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: AppWidth.w4),
        child: Row(
          children: _categoryList.map((e) => text(text: e.text, select: e.select, categoyId: e.id)).toList(),
        ),
      ),
    );
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
          /*Row(
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
          */
          MyWidget(context).headText('${AppLocalizations.of(context)!.translate('Price')}: ${itemModel.price} ${AppLocalizations.of(context)!.translate('currency')}', scale: 0.55, color: MyColors.mainColor),
        ],
      ),
    );
  }

  _pullRefresh() async{
    await Future.wait([
      MyAPI.productRead(),
      MyAPI.categoryRead(),
      MyAPI.purchaseOrderRead(),
      MyAPI.brandsReadStore(),
    ]);
    setState(() {
      pleaseWait = false;
      _fillCategory();
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
                purchaseAttributeValues: product.purchaseAttributeValues!,
                suppliers: product.suppliers!,
                id: product.id.toString(),
                brands:product.brands,
                networkImage: product.productDetailsPics![0].attachment!,
                isFavorite: checkIsFafourite(product.id.toString()),
                amount: 1,
                name: product.products!.name.toString(),
                category: CategoryModel(id: product.products!.productCategory!.id.toString(), text: product.products!.productCategory!.name!) ,
                price: product.price.toString(),
                imageListGallery: getGalaryImages(product.productDetailsPics!),
                attributeValues: product.attributeValues,
                description: product.description??"",
                purchaseAttributeValueIds: purchaseAttributeValueIds,
            ));
      }
    }
    if(applyFilter){
      _filterBrand();
    }
  }
  _fillCategory(){
    _categoryList.clear();
    _categoryList.add(CategoryModel(id: '00', text: AppLocalizations.of(navigatorKey.currentContext!)!.translate('All'), select: true));
    if(categoryList != null && categoryList!.data != null){
      for( var c in categoryList!.data!){
        _categoryList.add(CategoryModel(id: c.id.toString(), text: c.name!));
      }
    }
  }

  _filterCategory(){
    var categoryId = _categoryList.where((element) => element.select).toList()[0].id.toString();
    if(categoryId != "00"){
      _foundItems = _foundItems.where((element) => element.category.id.toString() == categoryId).toList();
    }else{
      _fillFoundItem();
    }
  }

  _filterBrand(){
    if(selectedBrand != null){
      var brandId = selectedBrand!.id.toString();
      _foundItems = _foundItems.where((element) => element.brands==null || element.brands!.id.toString() == brandId).toList();
    }else{
      _fillFoundItem();
    }

  }
}
