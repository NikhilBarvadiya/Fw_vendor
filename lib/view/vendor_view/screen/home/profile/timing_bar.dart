// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class TimingBar extends StatefulWidget {
  const TimingBar({Key? key, required this.onEdit, this.data}) : super(key: key);
  final Function onEdit;
  final dynamic data;

  @override
  _TimingBarState createState() => _TimingBarState();
}

class _TimingBarState extends State<TimingBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.data["day"],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.onEdit();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Edit",
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            ...widget.data["timings"].map(
              (e) {
                return Text(
                  "${e["from"]} - ${e["to"]}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
