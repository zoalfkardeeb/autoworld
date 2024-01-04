import 'package:automall/MyWidget.dart';
import 'package:automall/const.dart';
import 'package:automall/constant/app_size.dart';
import 'package:automall/constant/color/MyColors.dart';
import 'package:automall/constant/font_size.dart';
import 'package:automall/eShop/eShopMainScreen.dart';
import 'package:automall/localizations.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class FilterE_shop extends StatefulWidget {
  final Function() notify;
  const FilterE_shop({key, required this.notify}) : super(key : key);

  @override
  State<FilterE_shop> createState() => _FilterE_shopState();
}

class _FilterE_shopState extends State<FilterE_shop> {

  late List<Filter> _brand = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedBrand = null;
    for(var v in brandListStore!.data!){
      _brand.add(Filter(text: v.name!, id: v.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.topCon.withOpacity(0.6),
      body: Padding(
        padding: EdgeInsets.only(top: AppHeight.h1),
      //  margin: EdgeInsets.only(top: AppHeight.h1, bottom: AppHeight.h50*0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: AppHeight.h1),
              decoration: const BoxDecoration(
                color: MyColors.topCon,
              ),
              child: Column(
                children: [
                  MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('Filter your research to find immediately what you need'), color: MyColors.black, scale: 1.2),
                  SizedBox(height: AppHeight.h1,),
                 // dropDown2(['items1', 'items2'], null, "select"),
                  SizedBox(height: AppHeight.h1,),
                  dropDown2(_brand, null, selectedBrand == null? AppLocalizations.of(context)!.translate('Brand') : selectedBrand!.text),
                  SizedBox(height: AppHeight.h1,),
                  /*Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppWidth.w10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  //      MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('production Year'), padding: 0.1, color: MyColors.black, scale: 0.85),
                        Row(
                          children: [
                       *//*     Flexible(child: dropDown2(['items1', 'items2'], null, "select")),
                            SizedBox(width: AppWidth.w2,),
                            Flexible(child: dropDown2(['items1', 'items2'], null, "select")),
                       *//*   ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppHeight.h2*1.5,),
                  */
                  SizedBox(height: AppHeight.h2),
                  MyWidget(context).bottomContainer(
                      GestureDetector(
                        onTap:() => _filter(),
                        child: MyWidget(context).bodyText1(AppLocalizations.of(context)!.translate('Filter My Research'), color: MyColors.black, scale: 1.4),
                      ),
                      AppWidth.w8, bottomConRati: 0.07, color: MyColors.mainColor),
                ],
              ),
            ),
            SizedBox(height: AppHeight.h50, width: AppWidth.w100, child: GestureDetector(onTap: ()=> _filter(applyfilter: false),),)
          ],
        ),
      ),
    );
  }

  Widget dropDown2(List<Filter> filter, selectedValue, String hintText){
    List<String> items = [];
    for(var i in filter){
      items.add(i.text);
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Row(
          children: [
            /*Icon(
              Icons.list,
              size: AppHeight.h2,
              color: MyColors.black,
            ),*/
            SizedBox(
              width: AppWidth.w2*0,
            ),
            Expanded(
              child: Text(
                hintText,
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
        value: selectedValue,
        onChanged: (String? value) {
            selectedBrand = _brand.where((element) => element.text == value).toList().first;
            widget.notify();
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
    );
  }

  _filter({applyfilter}) {
    showFilter = false;
    applyFilter = applyfilter??true;
    widget.notify();
  }
}
class Filter{
  String text;
  int id;
  Filter({required this.text, required this.id});
}