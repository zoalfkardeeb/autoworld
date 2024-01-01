import 'package:automall/MyWidget.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/eShop/model/categoryModel.dart';
import 'package:automall/eShop/model/itemModel.dart';
import 'package:automall/eShop/model/response/productRead.dart';
import 'package:automall/eShop/shopHelper.dart';
import 'package:automall/eShop/topBar.dart';
import 'package:automall/localizations.dart';
import 'package:automall/photoView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class ProductDetails extends StatefulWidget {
  final ItemModel item;
  const ProductDetails({key, required this.item}) : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  List<GalarryItems> suggestionList = [
    GalarryItems(image: 'https://maycointernational.com/wp-content/uploads/2019/07/Blog-CarParts.jpg', id: 1),
    GalarryItems(image: 'https://maycointernational.com/wp-content/uploads/2019/07/Blog-CarParts.jpg', id: 1),
    GalarryItems(image: 'https://maycointernational.com/wp-content/uploads/2019/07/Blog-CarParts.jpg', id: 1),
  ];
  List<Widget> imageList = [];
  late final ShopHelper shopHelper;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    shopHelper = ShopHelper(notify: ()=>setState(() {}), itemModel: widget.item);
  }
  @override
  Widget build(BuildContext context) {
    imageList.clear();
    for (var element in widget.item.imageListGallery) {
      imageList.add(
          MyWidget(context).networkImage(element.image, AppWidth.w90, crossAlign: CrossAxisAlignment.center, height: AppHeight.h20)
      );
    }
    return Scaffold(
      backgroundColor: MyColors.topCon,
      body: Column(
        children: [
          TopBarEShop(title: widget.item.name),
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
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(top: AppHeight.h20- AppHeight.h2, right: AppWidth.w2),
                              child: IconButton(onPressed: () =>shopHelper.addToFavorite(), icon: Icon(widget.item.isFavorite? Icons.favorite : Icons.favorite_border,color: MyColors.mainColor, size: AppHeight.h4,)),
                            ),
                          )
                        ]
                      ),
                      SizedBox(height: AppWidth.w1,),
                      MyWidget(context).headText(widget.item.name, scale: 0.6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MyWidget(context).bodyText1(widget.item.category.text, padding: 0.0, scale: 0.8),
                           //   MyWidget(context).bodyText1(widget.item.attributeValues, padding: 0.0, scale: 0.8),
                            ],
                          ),
                          Container(
                            height: AppWidth.w4*1.5,
                            width: AppWidth.w20*1.3,
                            padding: EdgeInsets.symmetric(horizontal: AppWidth.w1),
                            decoration: BoxDecoration(
                              border: Border.all(color: MyColors.mainColor, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(AppWidth.w1)),
                            ),
                            child: widget.item.amount != 0?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    width: AppWidth.w5,
                                    height: AppWidth.w5,
                                    child: IconButton(onPressed: ()=> shopHelper.removeItem(), icon: Icon(Icons.remove,size: AppWidth.w4,color: MyColors.mainColor), padding: const EdgeInsets.all(0.1))),
                                const VerticalDivider(color: MyColors.mainColor, thickness: 1,),
                                MyWidget(context).headText('${widget.item.amount}', scale: 0.5, color: MyColors.mainColor),
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
                        ],
                      ),
                      SizedBox(height: AppWidth.w1,),
                      MyWidget(context).headText('${AppLocalizations.of(context)!.translate('Price')}: ${widget.item.price} ${AppLocalizations.of(context)!.translate('currency')}', scale: 0.55, color: MyColors.mainColor),
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
              GestureDetector(
                   onTap:() => _addToCart(),
                child: MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('Add to basket'), color: MyColors.black, scale: 1.4),
              ),
              AppWidth.w8, bottomConRati: 0.08, color: MyColors.mainColor)
        ],
      ),
    );
  }

  int _selectedImageIndex = 0;

  _imageSlider(listImage){
    return ImageSlideshow(

      /// Width of the [ImageSlideshow].
      width: double.infinity,

      /// Height of the [ImageSlideshow].
      height: MediaQuery.of(context).size.height/3.5,

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
        child: MyWidget(context).bodyText1('${AppLocalizations.of(context)!.translate('Description:')}\n ${widget.item.description.toString()}', padding: 0.0, scale: 0.8, align: TextAlign.start),
      );
    }
    else{
      return const SizedBox();
    }


  }

  _suggestion(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppHeight.h2,width: AppWidth.w4,),
        MyWidget(context).headText(AppLocalizations.of(context)!.translate('Suggestion:'), scale: 0.6),
        Row(
          children: suggestionList.map((e) => MyWidget.shadowContainer(child: Image.network(e.image, height: AppHeight.h10, fit: BoxFit.cover,), width: AppWidth.w24, margin: AppWidth.w2,)).toList(),
        )
      ],
    );

  }

  _addToCart() {}

  Widget _horizontalScrolAtt(List<PurchaseAttributeValue> attributeValueList) {
    var textH = attributeValueList[0].purchaseAttributeValues!.purchaseAttribute!.name??'';
    List<CategoryModel> attributeList = [];
    for(var attributeValue in attributeValueList){
      attributeList.add(CategoryModel(id: attributeValue.purchaseAttributeValuesId!.toString(), text: attributeValue.purchaseAttributeValues!.val.toString(), select: true),);
    }
    selectAtt({required attributesId}){
      for(var c in attributeList){
        c.select = false;
      }
      attributeList.where((element) => element.id == attributesId).first.select = true;
      setState(() {});
    }
    Widget text({required text, required select, required attributesId}){
      return GestureDetector(
        onTap: () => selectAtt(attributesId: attributesId),
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
}
