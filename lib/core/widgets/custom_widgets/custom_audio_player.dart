import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fw_vendor/view/auth_checking_view/controller/app_controller.dart';

// CustomAudioPlayer(
// margin: const EdgeInsets.only(bottom: 5),
// borderRadius: 5,
// padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5, right: 8),
// audioPath: controller.audioPath = "/data/user/0/com.example.fw_vendor/cache/audio6106999262448371952.m4a",
// clearRecording: () => controller.clearRecording(),
// ),

class CustomAudioPlayer extends StatefulWidget {
  final Function clearRecording;
  final String audioPath;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? borderRadius;

  const CustomAudioPlayer({
    Key? key,
    required this.clearRecording,
    required this.audioPath,
    this.margin,
    this.borderRadius,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();
  late List<StreamSubscription> streams;
  PlayerState? state;

  @override
  void initState() {
    super.initState();
    streams = <StreamSubscription>[
      player.onPlayerStateChanged.listen((it) => setState(() => state = it)),
      player.onPlayerCompletion.listen((it) {
        setState(() => {isPlaying = false});
      }),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    for (var it in streams) {
      it.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            if (!isPlaying) {
              isPlaying = true;
              setState(() {});
              await player.play(widget.audioPath, isLocal: true);
            } else {
              isPlaying = false;
              await player.pause();
              setState(() {});
            }
          },
          child: Container(
            margin: widget.margin ?? const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: AppController().appTheme.primary1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(widget.borderRadius ?? 10),
                bottomLeft: Radius.circular(widget.borderRadius ?? 10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                isPlaying ? const Icon(Icons.pause, color: Colors.white, size: 20) : const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                const SizedBox(width: 5),
                Text(
                  isPlaying ? "PAUSE" : "PLAY",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await player.stop();
            widget.clearRecording();
            setState(() {});
          },
          child: Container(
            margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 10),
            padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(widget.borderRadius ?? 10),
                bottomRight: Radius.circular(widget.borderRadius ?? 10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.close, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
