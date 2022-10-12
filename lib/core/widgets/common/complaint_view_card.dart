import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/env.dart';
import 'package:get/get.dart';

class ComplaintView extends StatefulWidget {
  final String? orderNo;
  final String? shopName;
  final String? addressDate;
  final String? notes;
  final List? images;

  const ComplaintView({
    Key? key,
    this.shopName,
    this.addressDate,
    this.orderNo,
    this.images,
    this.notes,
  }) : super(key: key);

  @override
  State<ComplaintView> createState() => _ComplaintViewState();
}

class _ComplaintViewState extends State<ComplaintView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.shopName != null && widget.shopName != "") Text(widget.shopName ?? "", style: AppCss.h3),
            if (widget.orderNo != null && widget.orderNo != "") Text(widget.orderNo ?? "", style: AppCss.body1),
            if (widget.addressDate != null && widget.addressDate != "")
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  widget.addressDate ?? "",
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            if (widget.images!.isNotEmpty)
              Wrap(
                children: [
                  ...widget.images!.map((img) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        environment["imagesbaseUrl"] + img,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ).paddingOnly(right: 5, bottom: 5, top: 5);
                  }).toList(),
                ],
              ),
            if (widget.notes != null && widget.notes != "")
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(widget.notes ?? "", style: AppCss.footnote),
              ),
          ],
        ).paddingAll(4),
      ),
    );
  }
}
