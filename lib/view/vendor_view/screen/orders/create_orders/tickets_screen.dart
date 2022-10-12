import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fw_vendor/core/theme/index.dart';
import 'package:fw_vendor/core/widgets/common/common_button.dart';
import 'package:fw_vendor/core/widgets/common/common_orders_text_card.dart';
import 'package:fw_vendor/core/widgets/common_dialog/stylish_dialog.dart';
import 'package:fw_vendor/core/widgets/common_loading/loading.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_audio_player.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_audio_recorder.dart';
import 'package:fw_vendor/core/widgets/custom_widgets/custom_location_card.dart';
import 'package:fw_vendor/extensions/date_exensions.dart';
import 'package:fw_vendor/view/vendor_view/controller/tickets_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  TicketsController controller = Get.put(TicketsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketsController>(
      builder: (_) => LoadingMode(
        isLoading: controller.isLoading,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            foregroundColor: Colors.white,
            title: const Text("Ticket"),
          ),
          body: Stack(
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  CustomLocationCard(
                    shopName: controller.status["location"]["addressId"] != null
                        ? controller.status["location"]["addressId"]["name"].toString()
                        : controller.status["location"]["name"] != null
                            ? controller.status["location"]["name"].toString()
                            : "",
                    personName: controller.status["location"]["addressId"] != null
                        ? controller.status["location"]["addressId"]["person"].toString()
                        : controller.status["location"]["person"] != null
                            ? controller.status["location"]["person"].toString()
                            : "",
                    mobileNumber: controller.status["location"]["addressId"] != null
                        ? controller.status["location"]["addressId"]["mobile"].toString()
                        : controller.status["location"]["mobile"] != null
                            ? controller.status["location"]["mobile"].toString()
                            : "",
                    address: controller.status["location"]["addressId"] != null
                        ? controller.status["location"]["addressId"]["address"].toString().capitalizeFirst
                        : controller.status["location"]["address"] != null
                            ? controller.status["location"]["address"].toString().capitalizeFirst
                            : "",
                    billAmount: controller.status["location"]["amount"] != "" &&
                            controller.status["location"]["amount"] != null &&
                            controller.status["location"]["amount"] != 0
                        ? "₹${controller.status["location"]["amount"]}"
                        : "₹0.00",
                    cash: controller.status["location"]["cash"] != "" &&
                            controller.status["location"]["cash"] != null &&
                            controller.status["location"]["cash"] != 0
                        ? "₹${controller.status["location"]["cash"]}"
                        : "₹0.00",
                    cashReceived: controller.status["location"]["cashReceived"] != "" &&
                            controller.status["location"]["cashReceived"] != null &&
                            controller.status["location"]["cashReceived"] != 0
                        ? "₹${controller.status["location"]["cashReceived"]}"
                        : "₹0.00",
                    date: controller.status["location"]["updatedAt"] != ""
                        ? getFormattedDate(controller.status["location"]["updatedAt"].toString())
                        : "",
                  ),
                  Wrap(
                    children: <Widget>[
                      ...controller.selectedFileList.map((img) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.file(img, height: 80, width: 80, fit: BoxFit.cover)),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () => controller.delete(img),
                                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                  const Icon(Icons.delete, size: 15),
                                  Text("Delete", style: AppCss.footnote),
                                ]),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      InkWell(
                        onTap: () async {
                          if (controller.selectedFileList.length < 5) {
                            controller.getImage(ImageSource.camera);
                          } else {
                            infoDialog(titleText: "Info", contentText: "You can add upto 5 images at a time!", onPressed: () => Get.back());
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                          child: const Center(child: Icon(Icons.add)),
                        ),
                      ),
                    ],
                  ).paddingAll(10),
                  CommonOrdersTextCard(
                    name: "Description",
                    hintText: "Tell us something...",
                    controller: controller.txtNotes,
                    focusNode: controller.txtNameFocus,
                  ),
                  Wrap(
                    children: [
                      for (int b = 0; b < controller.constantData.length; b++)
                        InputChip(
                          shadowColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(width: 1, color: Colors.grey),
                          ),
                          backgroundColor: Colors.yellow.shade100,
                          onPressed: () => controller.setNote(controller.constantData[b]),
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FontAwesomeIcons.clone, size: 12),
                              const SizedBox(width: 5),
                              Text(controller.constantData[b], style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        ).paddingOnly(left: 5),
                    ],
                  ).paddingAll(5),
                  if (controller.isRecorded == false)
                    CustomAudioRecorder(onStop: (path) {
                      if (path != "") {
                        controller.isRecorded = true;
                        controller.audioPath = path;
                        controller.audioNote = controller.setAudioFile(controller.audioPath);
                        setState(() {});
                      }
                    }),
                  if (controller.isRecorded == true)
                    CustomAudioPlayer(
                      audioPath: controller.audioPath,
                      clearRecording: () {
                        controller.isRecorded = false;
                        controller.audioPath = '';
                        controller.audioNote = null;
                        setState(() {});
                      },
                    ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: commonButton(
                  borderRadius: 0.0,
                  margin: EdgeInsets.zero,
                  onTap: () => controller.onReturnOrderDetails(),
                  color: Colors.green,
                  text: "Save",
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
