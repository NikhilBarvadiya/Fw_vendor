import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static FirebaseOptions get platformOptions {
    if (kIsWeb) {
      // web
      return const FirebaseOptions(
        apiKey: '1:468966504025:web:865e2e813c888a15896348',
        appId: 'AIzaSyC4eqEBIg98obCDzIOjVtXr_EtkKne6Eic',
        messagingSenderId: 'carerocket-848db',
        projectId: '468966504025',
      );
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        apiKey: '1:468966504025:ios:b27f435ed004e5bd896348',
        appId: 'AIzaSyANm-Q1OquY1vhvL5k2DM5JkQ4nSw7uyQI',
        messagingSenderId: 'carerocket-848db',
        projectId: '468966504025',
        iosBundleId: 'com.carerockets',
      );
    } else {
      // Android
      return const FirebaseOptions(
        appId: '1:468966504025:android:34bba080b6358065896348',
        apiKey: 'AIzaSyB1VtaTNeZ5GBnDrr0fukrexEdLEhbCH3M',
        projectId: 'carerocket-848db',
        messagingSenderId: '468966504025',
      );
    }
  }
}
