import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class ShowAddressBookCard extends StatefulWidget {
  final String? name;
  final String? mobileNumber;
  final String? address;
  final void Function()? onDelete;
  final void Function()? onAdd;
  const ShowAddressBookCard({
    Key? key,
    this.name,
    this.mobileNumber,
    this.address,
    this.onDelete,
    this.onAdd,
  }) : super(key: key);

  @override
  State<ShowAddressBookCard> createState() => _ShowAddressBookCardState();
}

class _ShowAddressBookCardState extends State<ShowAddressBookCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: Theme.of(context).canvasColor,
      semanticContainer: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.name != null)
                  Text(
                    widget.name ?? "",
                    style: AppCss.h3.copyWith(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ).paddingOnly(bottom: 5),
                if (widget.mobileNumber != null && widget.mobileNumber != "")
                  Text(
                    widget.mobileNumber ?? "",
                    style: AppCss.footnote.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ).paddingOnly(bottom: 5),
                if (widget.address != null && widget.address != "")
                  Text(
                    widget.address ?? "",
                    style: AppCss.poppins.copyWith(
                      color: Colors.black,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: widget.onAdd,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ).paddingOnly(bottom: 10),
              GestureDetector(
                onTap: widget.onDelete,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  child: const Icon(
                    Icons.clear,
                    size: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ).paddingAll(8),
    );
  }
}
