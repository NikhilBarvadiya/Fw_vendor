import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class AppUpdateController extends GetxController{
  String downloadUrl = "https://fastwhistle.com/vendor-pharma.apk";
  String progress = "0";
  bool isDownloaded = false;
  bool downloading = false;
  String fileName = "vendor-pharma.apk";

  downloadApk() async {
    await _downloadFile(downloadUrl, fileName);
  }

  String savePath = "";
  installApk() async {
    if (savePath != "") {
      if (kDebugMode) {
        print("Installing apk: $savePath");
      }
      OpenFile.open(savePath);
    }
  }

  Future<void> _downloadFile(uri, fileName) async {
    downloading = true;
    update();
    savePath = await _getFilePath(fileName);
    Dio dio = Dio();
    dio.download(
      uri,
      savePath,
      onReceiveProgress: (rcv, total) {
        if (kDebugMode) {
          print('received: ${rcv.toStringAsFixed(0)} out of total: ${total.toStringAsFixed(0)}');
        }
        progress = ((rcv / total) * 100).toStringAsFixed(0);
        update();
        if (progress == '100') {
          isDownloaded = true;
          update();
        } else if (double.parse(progress) < 100) {}
      },
      deleteOnError: true,
    ).then((_) {
      if (progress == '100') {
        isDownloaded = true;
      }
      downloading = false;
      update();
    });
  }

  Future<String> _getFilePath(uniqueFileName) async {
    String path = '';
    Directory? dir = await getExternalStorageDirectory();
    if (dir != null) {
      path = '${dir.path}/$uniqueFileName';
      if (kDebugMode) {
        print(path);
      }
    }
    return path;
  }
}