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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Complaint View", textScaleFactor: 1, textAlign: TextAlign.center),
              Text(
                getFormattedDate2(controller.arguments["orderDetails"]["createdAt"].toString()),
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
          actions: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                controller.arguments["orderDetails"]["status"].toString().capitalizeFirst.toString(),
                style: AppCss.h2,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            ComplaintView(
              shopName: controller.arguments["orderDetails"]["addressId"]["name"],
              orderNo: controller.arguments["orderDetails"]["vendorOrderNo"].toString(),
              images: controller.arguments["orderDetails"]["images"],
              notes: controller.arguments["orderDetails"]["desc"] != ""
                  ? controller.arguments["orderDetails"]["desc"].toString()
                  : "Description not found...",
              reOpenStatus: controller.arguments["orderDetails"]["status"] == "open"
                  ? "Resolve"
                  : controller.arguments["orderDetails"]["status"] == "resolved"
                      ? "reOpen"
                      : controller.arguments["orderDetails"]["status"] == "reopen"
                          ? "Resolve"
                          : "Open",
              onStatus: () => controller.onStatusCheck(controller.arguments["orderDetails"]),
            ),
            _activityCard(controller.arguments["view"]),
          ],
        ),
      ),
    );
  }

  _activityCard(activity) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(
            "Status History",
            style: AppCss.h1.copyWith(color: Colors.black, fontSize: 18),
          ),
          ...activity.map(
            (e) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e["userId"]["name"],
                            style: AppCss.body1.copyWith(color: Colors.black, fontSize: 15),
                          ),
                          if (e["desc"] != null && e["desc"] != "") Text(e["desc"], style: AppCss.footnote),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            e["status"] == "open"
                                ? "This is open!"
                                : e["status"] == "resolved"
                                    ? "Was resolved!"
                                    : e["status"] == "reopen"
                                        ? "Was reopen!"
                                        : "",
                            style: AppCss.footnote.copyWith(fontSize: 12),
                          ),
                          Text(
                            getFormattedDate2(e["userId"]["updatedAt"].toString()),
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      )
                    ],
                  ).paddingOnly(bottom: 2),
                  if (e["userId"]["images"] != null)
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
                  if (e["userId"]["audioNote"] != null)
                    CustomAudioPlayer(
                      margin: const EdgeInsets.only(bottom: 5),
                      borderRadius: 5,
                      padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 8),
                      audioPath: environment["imagesbaseUrl"] + e["userId"]["audioNote"].toString(),
                      clearRecording: () => controller.clearRecording(e),
                    ),
                  Divider(
                    color: e["status"] == "open"
                        ? Colors.green
                        : e["status"] == "resolved"
                            ? Colors.amber
                            : e["status"] == "reopen"
                                ? Colors.blue
                                : Colors.transparent,
                  ),
                ],
              ).paddingAll(10),
            ),
          ),
        ],
      ).paddingAll(10),
    );
  }
}
