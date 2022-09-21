// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimingAddEdit extends StatefulWidget {
  const TimingAddEdit({Key? key, required this.isEdit, required this.data, required this.upTimings}) : super(key: key);
  final bool isEdit;
  final dynamic data;
  final Function upTimings;

  @override
  _TimingAddEditState createState() => _TimingAddEditState();
}

class _TimingAddEditState extends State<TimingAddEdit> {
  String selectedDay = "Monday";
  List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
  List timings = [];

  getTimings() {
    if (widget.data != null) {
      if (widget.data["timings"].length > 0) {
        for (var e in widget.data["timings"]) {
          timings.add(e);
        }
      } else {
        timings.add({"from": "", "to": ""});
      }
    } else {
      timings.add({"from": "", "to": ""});
    }
    setState(() {});
  }

  getTime(time) {
    String hour = time.hour.toString().length == 1 ? '0${time.hour}' : time.hour.toString();
    String minute = time.minute.toString().length == 1 ? '0${time.minute}' : time.minute.toString();
    return "$hour:$minute";
  }

  @override
  void initState() {
    getTimings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isEdit)
            Wrap(
              children: [
                ...days.map(
                  (e) {
                    return Container(
                      margin: const EdgeInsets.all(5),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedDay = e;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: selectedDay == e ? Theme.of(context).primaryColorLight : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(e),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          if (widget.isEdit && widget.data != null)
            Text(
              widget.data["day"],
              style: const TextStyle(fontSize: 20),
            ),
          const SizedBox(height: 20),
          for (int e = 0; e < timings.length; e++)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              TimeOfDay currentTime = TimeOfDay.fromDateTime(DateTime.now());
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: currentTime,
                                initialEntryMode: TimePickerEntryMode.input,
                              );
                              setState(
                                () {
                                  if (time != null) {
                                    timings[e]["from"] = getTime(time);
                                  }
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 8,
                                bottom: 8,
                              ),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade400)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    timings[e]["from"] != '' ? timings[e]["from"] : "- - : - -",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down_outlined, color: Colors.grey.shade700)
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              TimeOfDay currentTime = TimeOfDay.fromDateTime(DateTime.now());
                              TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: currentTime,
                                initialEntryMode: TimePickerEntryMode.input,
                              );
                              setState(
                                () {
                                  if (time != null) {
                                    timings[e]["to"] = getTime(time);
                                  }
                                },
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 8,
                                bottom: 8,
                              ),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade400)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    timings[e]["to"] != '' ? timings[e]["to"] : "- - : - -",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down_outlined, color: Colors.grey.shade700)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (e == 0)
                    InkWell(
                      onTap: () {
                        setState(
                          () {
                            timings.add(
                              {"from": "", "to": ""},
                            );
                          },
                        );
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.amber,
                        minRadius: 13,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  if (e == 0 && timings.length == 1)
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: InkWell(
                        onTap: () {
                          setState(
                            () {
                              timings.removeAt(e);
                            },
                          );
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.red.shade700,
                          minRadius: 13,
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  if (e != 0)
                    InkWell(
                      onTap: () {
                        setState(() {
                          timings.removeAt(e);
                        });
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.red.shade700,
                        minRadius: 13,
                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                      ),
                    )
                ],
              ),
            ),
          const SizedBox(height: 15),
          MaterialButton(
            onPressed: () {
              widget.upTimings(timings, selectedDay);
              Get.back();
            },
            color: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 13, bottom: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Save Changes",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
