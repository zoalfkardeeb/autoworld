import 'package:automall/MyWidget.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/eShop/model/categoryModel.dart';
import 'package:automall/eShop/model/itemModel.dart';
import 'package:automall/localizations.dart';
import 'package:flutter/material.dart';
class EShopMainScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  const EShopMainScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<EShopMainScreen> createState() => _EShopMainScreenState();
}

class _EShopMainScreenState extends State<EShopMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  final List<CategoryModel> _categoryList = [
    CategoryModel(id: 'id1', text: 'text'),
    CategoryModel(id: 'id2', text: 'text'),
    CategoryModel(id: 'id3', text: 'text'),
  ];

  final List<ItemModel> _foundItems = [
    ItemModel(id: 'id1', networkImage: 'https://miro.medium.com/v2/resize:fit:720/format:webp/1*5Y0m9U2bNNttP69AryJMvA.png', isFavorite: true, amount: 0, name: 'name', category: 'category', price: 'price'),
    ItemModel(id: 'id1', networkImage: 'https://miro.medium.com/v2/resize:fit:720/format:webp/1*5Y0m9U2bNNttP69AryJMvA.png', isFavorite: false, amount: 0, name: 'name', category: 'category', price: 'price'),
    ItemModel(id: 'id1', networkImage: 'https://miro.medium.com/v2/resize:fit:720/format:webp/1*5Y0m9U2bNNttP69AryJMvA.png', isFavorite: false, amount: 0, name: 'name', category: 'category', price: 'price'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.topCon,
      body: Stack(
        children:[
          Column(
          children: [
            _topBar(),
            _search(),
            _horizontalScrolCategory(),

            Expanded(
              child: GridView.extent(
                childAspectRatio: AppWidth.w50/AppWidth.w70,
                maxCrossAxisExtent: AppWidth.w70, // maximum item width
                mainAxisSpacing: AppWidth.w4, // spacing between rows
                crossAxisSpacing: AppWidth.w4, // spacing between columns
                padding: EdgeInsets.symmetric(horizontal: AppWidth.w4, vertical: AppHeight.h2),
                children: _foundItems.map((item) {
                  return _itemContainer(itemModel: item);
                }).toList(),
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

  Widget _topBar() {
    var curve = AppWidth.w4*1.5;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: curve, vertical: curve/2),
        decoration: BoxDecoration(
          color: MyColors.topCon,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(curve), bottomRight: Radius.circular(curve)),
          boxShadow: const [BoxShadow(
            color: MyColors.black,
            offset: Offset(0, 1),
            blurRadius: 4,
          )],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppHeight.h4,),
            Row(
              children: [
                MyWidget(context).drawerButton(_scaffoldKey),
                Expanded(
                  child: MyWidget(context).titleText1(widget.title),
                ),
                _cartIcon(),
              ],
            ),
          ],
        )
    );
  }

  Widget _cartIcon() {
    return IconButton(onPressed: (){}, icon: const Icon(Icons.shopping_cart_outlined));
  }

  Widget _search() {
    search() async{
      if(_searchController.text.length<2){
        return;
      }
      setState(() {
        pleaseWait = true;
      });
      _searchController.text = '';
      setState(() {
        pleaseWait = false;
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
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(onPressed: ()=> search(), icon: const Icon(Icons.list)),
                enabledBorder: OutlineInputBorder(
                  borderRadius:  BorderRadius.all(Radius.circular(AppWidth.w2 * 1.5)),
                  borderSide: const BorderSide(color: MyColors.black),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppWidth.w5)),
                    borderSide: const BorderSide(color: MyColors.mainColor)),
                hintText: AppLocalizations.of(context)!.translate('Search'),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(AppWidth.w5)),
                    borderSide: const BorderSide(color: MyColors.mainColor)),
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
      setState(() {});
    }
    Widget text({required text, required select, required categoyId}){
      return GestureDetector(
        onTap: () => filter(categoryId: categoyId),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppWidth.w2, vertical: AppWidth.w1),
          margin: EdgeInsets.symmetric(horizontal: AppWidth.w2),
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
    addtoFavorite(){
      setState(() {
        itemModel.isFavorite = !itemModel.isFavorite;
      });
    }
    remove(){
      setState(() {
        if(itemModel.amount>0){
          itemModel.amount -= 1;
        }
      });
    }
    add(){
      setState(() {
        itemModel.amount += 1;
      });
    }
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Align(child:
              Container(
                  decoration: BoxDecoration(
                    boxShadow: const [BoxShadow(
                      color: MyColors.black,
                      offset: Offset(1, 2),
                      blurRadius: 4,
                    )],
                    color: MyColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(AppWidth.w2)),
                    image: DecorationImage(image: NetworkImage(itemModel.networkImage), fit: BoxFit.contain,)
                  ),
                  height: AppWidth.w40,
              ),
              ),
              Align(alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppWidth.w2*0),
                    child: IconButton(onPressed: () => addtoFavorite(), icon: Icon(itemModel.isFavorite? Icons.favorite : Icons.favorite_border,color: MyColors.mainColor,)),
                  ),
              ),
            ],
          ),
          SizedBox(height: AppWidth.w1,),
          MyWidget(context).headText(itemModel.name, scale: 0.6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyWidget(context).bodyText1(itemModel.category, padding: 0.0, scale: 0.8),
              Container(
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
                        child: IconButton(onPressed: ()=> remove(), icon: Icon(Icons.remove,size: AppWidth.w4,color: MyColors.mainColor), padding: const EdgeInsets.all(0.1))),
                    const VerticalDivider(color: MyColors.mainColor, thickness: 1,),
                    MyWidget(context).headText('${itemModel.amount}', scale: 0.5, color: MyColors.mainColor),
                    const VerticalDivider(color: MyColors.mainColor, thickness: 1,),
                    SizedBox(
                        width: AppWidth.w5,
                        height: AppWidth.w5,
                        child: IconButton(onPressed: ()=> add(), icon: Icon(Icons.add, size: AppWidth.w4,color: MyColors.mainColor), padding: const EdgeInsets.all(0.1),)),
                  ],
                )
                    :
                SizedBox(
                    width: AppWidth.w5,
                    height: AppWidth.w5,
                    child: IconButton(onPressed: ()=> add(), icon: Icon(Icons.add, size: AppWidth.w4,color: MyColors.mainColor), padding: const EdgeInsets.all(0.1),)),

              ),
            ],
          ),
          SizedBox(height: AppWidth.w1,),
          MyWidget(context).headText('${AppLocalizations.of(context)!.translate('Price')}: ${itemModel.price} ${AppLocalizations.of(context)!.translate('currency')}', scale: 0.55, color: MyColors.mainColor),
        ],
      ),
    );
  }


}
