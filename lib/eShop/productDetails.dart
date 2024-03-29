import 'package:automall/MyWidget.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/eShop/eShopMainScreen.dart';
import 'package:automall/eShop/model/categoryModel.dart';
import 'package:automall/eShop/model/itemModel.dart';
import 'package:automall/eShop/model/response/productRead.dart';
import 'package:automall/eShop/shopHelper.dart';
import 'package:automall/eShop/topBar.dart';
import 'package:automall/helper/functions.dart';
import 'package:automall/localizations.dart';
import 'package:automall/photoView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ProductDetails extends StatefulWidget {
  late ItemModel item;
  late List<ItemModel> suggestionList;
  ProductDetails({key, required this.item, required this.suggestionList}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

  List<Widget> imageList = [];
  late ShopHelper shopHelper;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    shopHelper = ShopHelper(notify: ()=>setState(() {}), itemModel: widget.item);
  }
  @override
  Widget build(BuildContext context) {
    imageList.clear();
    shopHelper = ShopHelper(notify: ()=>setState(() {}), itemModel: widget.item);
    for (var element in widget.item.imageListGallery) {
      imageList.add(
          MyWidget(context).networkImage(element.image, AppWidth.w80, crossAlign: CrossAxisAlignment.center)
      );
    }
    return Scaffold(
      backgroundColor: MyColors.topCon,
      body: Stack(
        children: [
          Column(
            children: [
              TopBarEShop(title: widget.item.name, notify: _setState,),
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppWidth.w4*1.5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                              children: [
                                GestureDetector(
                                  onTap: ()=> MyWidget(context).showImage('src', listNetworkImage: widget.item.imageListGallery, selectedIndex: _selectedImageIndex),
                                  child: _imageSlider(imageList),
                                ),
                               /* Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: AppHeight.h20- AppHeight.h2, right: AppWidth.w2),
                                    child: IconButton(onPressed: () =>shopHelper.addToFavorite(), icon: Icon(widget.item.isFavorite? Icons.favorite : Icons.favorite_border,color: MyColors.mainColor, size: AppHeight.h4,)),
                                  ),
                                )*/
                              ]
                          ),
                          SizedBox(height: AppWidth.w1,),
                          MyWidget(context).headText(widget.item.name, scale: 0.7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyWidget(context).bodyText1("${widget.item.category.text}, ${widget.item.code ?? ''}", padding: 0.0, scale: 1, maxLine: 2),
                                  //   MyWidget(context).bodyText1(widget.item.attributeValues, padding: 0.0, scale: 0.8),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: AppWidth.w1,),
                          Row(
                            children: [
                              Expanded(
                                  child: MyWidget(context).headText('${AppLocalizations.of(context)!.translate('Price')}: ${widget.item.price} ${AppLocalizations.of(context)!.translate('currency')}', scale: 0.8, color: MyColors.mainColor, align: TextAlign.start),
                              ),
                              MyWidget(context).bodyText1(widget.item.outOfStock ? AppLocalizations.of(context)!.translate('Out of stock'): '${AppLocalizations.of(context)!.translate('Available')} ${widget.item.storeQuantity}', scale: 0.9, color: MyColors.mainColor.withOpacity(0.7)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.item.purchaseAttributeValues!.map((e) => _horizontalScrolAtt(e)).toList(),
                          ),
                          SizedBox(height: AppHeight.h1,),
                          _description(),
                          _suggestion(),
                        ],
                      ),
                    ),
                  )
              ),
              MyWidget(context).bottomContainer(
                  widget.item.amount == 0? GestureDetector(
                    onTap:() => _addToCart(),
                    child: MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('Add to basket'), color: MyColors.white, scale: 1.4),
                  ): _addMinCounter(),
                  AppWidth.w8, bottomConRati: 0.08, color: widget.item.outOfStock && widget.item.amount==0? MyColors.card : MyColors.mainColor)
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: pleaseWait?
            MyWidget(context).progress()
                :
            const SizedBox(),
          ),
        ]
      ),
    );
  }

  int _selectedImageIndex = 0;

  _imageSlider(listImage){
    return ImageSlideshow(

      /// Width of the [ImageSlideshow].
      width: double.infinity,

      /// Height of the [ImageSlideshow].
      height: AppWidth.w90,

      /// The page to show when first creating the [ImageSlideshow].
      initialPage: 0,

      /// The color to paint the indicator.
      indicatorColor: MyColors.mainColor,

      /// The color to paint behind th indicator.
      indicatorBackgroundColor: Colors.grey,

      /// The widgets to display in the [ImageSlideshow].
      /// Add the sample image file into the images folder
      children: listImage,

      /// Called whenever the page in the center of the viewport changes.
      onPageChanged: (value) {
        _selectedImageIndex = value;
        print('Page changed: $value');
      },

      /// Auto scroll interval.
      /// Do not auto scroll with null or 0.
      autoPlayInterval: null,

      /// Loops back to first slide.
      isLoop: true,
    );
  }

  _description() {
    if(widget.item.description != null){
      return MyWidget.shadowContainer(
        child: MyWidget(context).bodyText1('${AppLocalizations.of(context)!.translate('Description:')}\n ${widget.item.description.toString()}', padding: 0.0, scale: 1, align: TextAlign.start),
      );
    }
    else{
      return const SizedBox();
    }


  }

  _suggestion(){
    select(ItemModel e) async{
      setState(() {
        pleaseWait = true;
      });
      widget.item = e;
      shopHelper = ShopHelper(notify: ()=>setState(() {}), itemModel: widget.item);
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        pleaseWait = false;
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppHeight.h2,width: AppWidth.w4,),
        MyWidget(context).headText(AppLocalizations.of(context)!.translate('Suggestion:'), scale: 0.6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.suggestionList.map((e) =>
                GestureDetector(
                  onTap: ()=> select(e),
                    child: MyWidget.shadowContainer(child: Image.network(e.networkImage, height: AppHeight.h10, fit: BoxFit.cover,), width: AppWidth.w24, margin: AppWidth.w2,))).toList(),
          ),
        )
      ],
    );
  }

  _addToCart() async{
    await shopHelper.addItemToBasket();
   //MyApplication.navigateToReplace(context, EShopMainScreen(title: 'title'));
  }

  Widget _horizontalScrolAtt(List<PurchaseAttributeValue> attributeValueList) {
    var textH = attributeValueList[0].purchaseAttributeValues!.purchaseAttribute!.name??'';
    List<CategoryModel> attributeList = [];
    for(var attributeValue in attributeValueList){
      var se = false;
      widget.item.purchaseAttributeValueIds.forEach((element) {
        if(element.toString()==attributeValue.purchaseAttributeValues!.id.toString()) se = true;
      });
      attributeList.add(
        CategoryModel(
            id: attributeValue.purchaseAttributeValues!.id.toString(),
            text: attributeValue.purchaseAttributeValues!.val.toString(),
            select: se,
        ),
      );
    }
    selectAtt({required attributesId}){
      for(var c in attributeList){
        widget.item.purchaseAttributeValueIds.removeWhere((element) => element.toString() == c.id.toString());
      }
      widget.item.purchaseAttributeValueIds.add(int.parse(attributesId.toString()));
      //attributeList.where((element) => element.id == attributesId).first.select = true;
      setState(() {});
    }
    Widget text({required text, required select, required attributesId}){
      return GestureDetector(
        onTap: () => select? null: selectAtt(attributesId: attributesId),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.w2, vertical: AppWidth.w1),
          margin: EdgeInsets.symmetric(horizontal: AppWidth.w1),
          decoration: BoxDecoration(
              color: select? MyColors.mainColor: MyColors.trans,
              borderRadius: BorderRadius.all(Radius.circular(AppWidth.w2)),
              border: Border.all(color: select? MyColors.mainColor: MyColors.trans)
          ),
          child: MyWidget(context).headText(text, scale: 0.5, color: select? MyColors.white: MyColors.black, paddingH: 0.0),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppHeight.h1,),
        MyWidget(context).bodyText1(textH+': ', padding: 0.0),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: AppWidth.w4*0),
            child: Row(
              children: attributeList.map((e) => text(text: e.text, select: e.select, attributesId: e.id)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  _addMinCounter() {
    var color = MyColors.black;
    var color1 = MyColors.mainColor;
    return Container(
      //height: AppWidth.w4*1.5,
      //width: AppWidth.w20*1.3,
      padding: EdgeInsets.symmetric(horizontal: AppWidth.w1),
      decoration: BoxDecoration(
        border: Border.all(color: color1, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(AppWidth.w1)),
      ),
      child: widget.item.amount != 0?
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
              width: AppWidth.w10,
              height: AppWidth.w10,
              child: IconButton(onPressed: ()=> shopHelper.removeItem(), icon: Icon(Icons.remove,size: AppWidth.w10,color: color), padding: const EdgeInsets.all(0.1))),
          VerticalDivider(color: color1, thickness: 1,),
          MyWidget(context).headText('${widget.item.amount}', scale: 1.2, color: color),
          VerticalDivider(color: color1, thickness: 1,),
          SizedBox(
              width: AppWidth.w10,
              height: AppWidth.w10,
              child: IconButton(onPressed: ()=> shopHelper.addItem(), icon: Icon(Icons.add, size: AppWidth.w10,color: color), padding: const EdgeInsets.all(0.1),)),
        ],
      )
          :
      SizedBox(
          width: AppWidth.w5,
          height: AppWidth.w5,
          child: IconButton(onPressed: ()=> shopHelper.addItem(), icon: Icon(Icons.add, size: AppWidth.w4,color: MyColors.mainColor), padding: const EdgeInsets.all(0.1),)),

    );
  }

  _setState() async{
    setState(() { });
  }
}
