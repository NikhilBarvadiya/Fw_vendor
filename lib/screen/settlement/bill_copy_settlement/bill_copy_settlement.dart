import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillCopySettementScreen extends StatefulWidget {
  const BillCopySettementScreen({Key? key}) : super(key: key);

  @override
  State<BillCopySettementScreen> createState() => _BillCopySettementScreenState();
}

class _BillCopySettementScreenState extends State<BillCopySettementScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (_) => Scaffold(
        appBar: AppBar(),
      ),
    );
  }
}
