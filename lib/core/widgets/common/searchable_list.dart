import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:get/get.dart';

class SearchableListView extends StatefulWidget {
  const SearchableListView({
    Key? key,
    this.onSelect,
    required this.itemList,
    this.bindText,
    this.bindValue,
    this.fetchApi,
    required this.isLive,
    this.labelText,
    this.hintText,
    this.hederText,
    this.isOnSearch,
    this.isOnheder,
    this.hederColor,
    this.hederTxtColor,
    this.txtController,
    this.bindTextStyle,
  }) : super(key: key);
  final List itemList;
  final String? bindText;
  final String? bindValue;
  final Function? onSelect;
  final Function? fetchApi;
  final bool isLive;
  final String? labelText;
  final String? hintText;
  final String? hederText;
  final bool? isOnheder;
  final bool? isOnSearch;
  final Color? hederColor;
  final Color? hederTxtColor;
  final TextEditingController? txtController;
  final TextStyle? bindTextStyle;

  @override
  State<SearchableListView> createState() => _SearchableListViewState();
}

class _SearchableListViewState extends State<SearchableListView> {
  @override
  void initState() {
    itemList = widget.itemList;
    resultList = widget.itemList;
    super.initState();
  }

  List itemList = [];
  List resultList = [];

  void _runFilter(String enteredKeyword) {
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = itemList;
    } else {
      results = itemList.where((record) => record[widget.bindText].toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }
    setState(() {
      resultList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isOnSearch!
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: widget.txtController,
                onChanged: (search) async {
                  if (widget.isLive && widget.fetchApi != null) {
                    resultList = await widget.fetchApi!(search);
                  } else {
                    if (widget.bindText != null) {
                      _runFilter(search);
                    }
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  labelText: widget.labelText ?? '',
                  hintText: widget.hintText ?? '',
                  suffixIcon: SizedBox(
                    height: 50,
                    width: 50,
                    child: Row(
                      children: [
                        VerticalDivider(
                          thickness: 1.5,
                          indent: 5,
                          endIndent: 5,
                          color: Theme.of(context).primaryColor.withOpacity(0.5),
                        ),
                        Icon(
                          Icons.search,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                  hintStyle: const TextStyle(fontSize: 15),
                  labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  filled: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              Expanded(child: _buildMe()),
            ],
          )
        : _buildMe();
  }

  Widget _buildMe() {
    return Column(
      children: [
        widget.isOnheder!
            ? Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: widget.hederColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.hederText ?? "",
                      style: AppCss.h3.copyWith(
                        color: widget.hederTxtColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1,
                      ),
                    ).paddingOnly(left: 5),
                  ],
                ),
              )
            : Container(),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              ...resultList.map(
                (e) {
                  return ListTile(
                    onTap: () {
                      if (widget.bindValue != null && widget.bindText != null) {
                        widget.onSelect!(e[widget.bindValue], e[widget.bindText], e);
                      } else if (widget.bindValue != null) {
                        widget.onSelect!(e[widget.bindValue]);
                      } else {
                        widget.onSelect!(e);
                      }
                    },
                    title: Text(
                      widget.bindText != null ? e[widget.bindText].toString().capitalizeFirst : e,
                      style: widget.bindTextStyle ??
                          AppCss.body2.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        if (resultList.isEmpty)
          commonButton(
            onTap: () {
              Get.back();
            },
            text: "New add",
            height: 50.0,
          ).paddingSymmetric(horizontal: 10, vertical: 5),
      ],
    );
  }
}
