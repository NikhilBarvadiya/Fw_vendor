// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/utilities/index.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.signal_wifi_statusbar_connected_no_internet_4_sharp,
                size: 50,
                color: Colors.grey,
              ),
              const Text(
                'Oops,',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(
                height: appScreenUtil.size(5),
              ),
              const Text(
                'Please check your internet connection!',
                style: TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
