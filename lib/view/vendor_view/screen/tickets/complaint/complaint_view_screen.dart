import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/core/widgets/common/complaint_view_card.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_audio_player.dart';
import 'package:fw_vendor/env.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/complaint_view_controller.dart';
import 'package:get/get.dart';

class ComplaintViewScreen extends StatefulWidget {
  const ComplaintViewScreen({Key? key}) : super(key: key);

  @override
  State<ComplaintViewScreen> createState() => _ComplaintViewScreenState();
}

class _ComplaintViewScreenState extends State<ComplaintViewScreen> {
  ComplaintViewController controller = Get.put(ComplaintViewController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ComplaintViewController>(
      builder: (_) => Scaffold(
        appBar: AppBar(
          elevation: 1,
          automaticallyImplyLeading: true,
          foregroundColor: Colors.white,
          title: const Text("Complaint View", textScaleFactor: 1, textAlign: TextAlign.center),
        ),
        body: Column(
          children: [
            ComplaintView(
              shopName: controller.arguments["orderDetails"]["addressId"]["name"],
              orderNo: controller.arguments["orderDetails"]["vendorOrderNo"].toString(),
              addressDate: getFormattedDate2(controller.arguments["view"][0]["date"].toString()),
              images: controller.arguments["view"][0]["images"],
              notes: controller.arguments["view"][0]["desc"],
            ),
            _activityCard(controller.arguments["view"]),
          ],
        ).paddingAll(10),
      ),
    );
  }

  _activityCard(activity) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          ...activity.map(
            (e) => Card(
              elevation: 1,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e["userId"]["name"],
                          style: AppCss.h3.copyWith(color: Colors.black, fontSize: 15),
                        ),
                        Card(
                          color: e["status"] == "open" ? Colors.blue : Colors.deepOrangeAccent,
                          elevation: 0,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                          child: Text(
                            e["status"].toString(),
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ).paddingOnly(left: 4, right: 4),
                        ),
                      ],
                    ).paddingOnly(bottom: 2),
                    Text(
                      getFormattedDate2(e["userId"]["updatedAt"].toString()),
                      style: const TextStyle(fontSize: 10),
                    ).paddingOnly(bottom: 2),
                    Text(
                      e["userId"]["address"]["address_line"].toString(),
                      style: const TextStyle(fontSize: 12),
                    ).paddingOnly(bottom: 2),
                    Wrap(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            environment["imagesbaseUrl"] + e["userId"]["images"].toString(),
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
                        ),
                      ],
                    ).paddingAll(5),
                    CustomAudioPlayer(
                      margin: const EdgeInsets.only(bottom: 5),
                      borderRadius: 5,
                      padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 8),
                      audioPath: environment["imagesbaseUrl"] + e["audioNote"].toString(),
                      clearRecording: () {
                        e["audioNote"] = "";
                      },
                    ),
                    if (e["desc"] != null && e["desc"] != "")
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(e["desc"], style: AppCss.footnote),
                      ),
                  ],
                ).paddingAll(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
