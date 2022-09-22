import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_update_controller.dart';
import 'package:get/get.dart';

class AppUpdateScreen extends StatefulWidget {
  const AppUpdateScreen({Key? key}) : super(key: key);

  @override
  State<AppUpdateScreen> createState() => _AppUpdateScreenState();
}

class _AppUpdateScreenState extends State<AppUpdateScreen> {
  final AppUpdateController _controller = Get.put(AppUpdateController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppUpdateController>(
      builder: (_) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Image.asset(
                "assets/background.png",
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                colorBlendMode: BlendMode.modulate,
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 12 / 100,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        "assets/fastwhistle_loading.gif",
                        height: 150,
                        width: 150,
                      ),
                      Text(
                        "Time To Update!",
                        style: AppCss.h1,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "We added lots of new features and fix some bugs to make your experience as smooth as possible.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          if (!_controller.downloading) {
                            if (!_controller.isDownloaded) {
                              await _controller.downloadApk();
                            } else {
                              _controller.installApk();
                            }
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 50 / 100,
                          padding: const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: _controller.downloading ? Theme.of(context).primaryColor.withOpacity(.4) : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _controller.isDownloaded ? "Install App" : "Download App",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_controller.downloading)
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("${_controller.progress}%"),
                              const LinearProgressIndicator(),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 10 / 100,
                left: 0,
                right: 0,
                child: Image.asset(
                  "assets/text_logo.png",
                  height: 120,
                  colorBlendMode: BlendMode.modulate,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
