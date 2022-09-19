// ignore_for_file: must_be_immutable
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/core/theme/app_css.dart';

class LoadingMode extends StatefulWidget {
  bool isLoading = false;
  Widget child;

  LoadingMode({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  State<LoadingMode> createState() => _LoadingModeState();
}

class _LoadingModeState extends State<LoadingMode> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading)
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.2),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: kElevationToShadow[2],
                    ),
                    child: Column(
                      children: [
                        const CupertinoActivityIndicator(
                          color: Colors.black,
                          animating: true,
                          radius: 10,
                        ),
                        Text(
                          "Loading",
                          style: AppCss.h3.copyWith(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
