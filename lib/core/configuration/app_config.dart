// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class AppConfig {
  static bool enableLog = true;
  static bool debugBanner = false;
  static String appName = "Fast Whistle Vendor";
  static String stTheme = "appTheme";
}

Future<File> imageFromUInit8List(Uint8List imageUInt8List) async {
  Uint8List tempImg = imageUInt8List;
  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/images.jpg').create();
  file.writeAsBytesSync(tempImg);
  return file;
}
