import 'package:flutter/material.dart';import 'package:fw_vendor/core/theme/index.dart';import 'package:get/get.dart';class OrderAddressCard extends StatefulWidget {  final String? addressHeder;  final dynamic addressHederfontSize;  final String? personName;  final String? address;  final String? area;  final Color? cardColors;  final Color? deleteIconColor;  final Color? deleteIconBoxColor;  final IconData? deleteIcon;  final bool? icon;  final void Function()? onTap;  const OrderAddressCard({    Key? key,    this.addressHeder,    this.personName,    this.address,    this.area,    this.onTap,    this.cardColors,    this.deleteIcon,    this.deleteIconColor,    this.icon,    this.deleteIconBoxColor,    this.addressHederfontSize,  }) : super(key: key);  @override  State<OrderAddressCard> createState() => _OrderAddressCardState();}class _OrderAddressCardState extends State<OrderAddressCard> {  @override  Widget build(BuildContext context) {    return Card(      elevation: 1,      shape: RoundedRectangleBorder(        borderRadius: const BorderRadius.all(          Radius.circular(8),        ),        side: BorderSide(          color: Colors.blue.shade400,          width: 1,        ),      ),      color: widget.cardColors ?? Colors.white,      child: Stack(        children: [          Padding(            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),            child: Column(              mainAxisSize: MainAxisSize.min,              crossAxisAlignment: CrossAxisAlignment.start,              children: [                Row(                  mainAxisAlignment: MainAxisAlignment.spaceBetween,                  children: [                    Expanded(                      child: Text(                        widget.addressHeder ?? '',                        style: AppCss.h1.copyWith(fontSize: widget.addressHederfontSize),                      ),                    ),                    GestureDetector(                      onTap: widget.onTap,                      child: AnimatedContainer(                        duration: const Duration(milliseconds: 100),                        alignment: Alignment.center,                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),                        decoration: widget.icon == true                            ? const BoxDecoration()                            : BoxDecoration(                                color: widget.deleteIconBoxColor,                                borderRadius: const BorderRadius.all(                                  Radius.circular(8),                                ),                              ),                        child: Icon(                          widget.deleteIcon,                          color: widget.icon == true ? widget.deleteIconColor ?? Colors.white : Colors.white,                        ),                      ),                    ),                  ],                ).paddingOnly(bottom: 5),                Text(                  widget.personName ?? '',                  style: AppCss.h3,                ).paddingOnly(bottom: 5),                Text(                  widget.address ?? '',                  style: AppCss.h3.copyWith(                    color: Colors.black.withOpacity(0.6),                    fontWeight: FontWeight.w600,                  ),                ).paddingOnly(bottom: 5),                Text(                  widget.area ?? '',                  style: AppCss.h3.copyWith(                    color: Colors.black.withOpacity(0.6),                    fontWeight: FontWeight.w600,                  ),                ).paddingOnly(bottom: 5),              ],            ),          ),        ],      ),    );  }}