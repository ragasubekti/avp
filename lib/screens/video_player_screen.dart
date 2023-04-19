import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:another_vp/models/settings_model.dart';
import 'package:another_vp/models/video_database_models.dart';
import 'package:styled_widget/styled_widget.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoDatabaseModel videoData;
  final SettingsModel? settings;

  const VideoPlayerScreen({super.key, required this.videoData, this.settings});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VlcPlayerController controller;
  Future<void> initializePlayer() async {}

  bool isControlVisible = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    getVideoOrientation();

    List<String> vlcAudioOptions =
        widget.settings?.alwaysMute ?? false ? ['--noaudio'] : [];

    controller = VlcPlayerController.file(File(widget.videoData.filePath),
        hwAcc: HwAcc.auto,
        autoPlay: true,
        options: VlcPlayerOptions(audio: VlcAudioOptions(vlcAudioOptions)),
        autoInitialize: true);

    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        isControlVisible = false;
      });
    });
  }

  void toggleControlVisibility() {
    setState(() {
      isControlVisible = true;
    });

    Future.delayed(const Duration(seconds: 5), () {
      if (controller.value.isPlaying) {
        setState(() {
          isControlVisible = false;
        });
      }
    });
  }

  void getVideoOrientation() {
    final resolution = widget.videoData.resolution;
    if (widget.settings!.forceDeviceOrientation ==
        SettingDeviceOrientation.landscape) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      return;
    } else if (widget.settings!.forceDeviceOrientation ==
        SettingDeviceOrientation.portrait) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      return;
    }

    if (resolution != "Unknown") {
      final _resolution = resolution.split("x");

      if (int.parse(_resolution[0]) <= int.parse(_resolution[1])) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
      }
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
  }

  double getAspectRatio() {
    final resolution = widget.videoData.resolution;

    if (resolution != "Unknown") {
      final _resolution = resolution.split("x");

      return int.parse(_resolution[0]) / int.parse(_resolution[1]);
    }
    return 16 / 9;
  }

  @override
  void dispose() async {
    super.dispose();
    await controller.stopRendererScanning();

    SystemChrome.setPreferredOrientations([]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // await videoViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: toggleControlVisibility,
          child: Stack(
            children: [
              Center(
                child: VlcPlayer(
                    controller: controller, aspectRatio: getAspectRatio()),
              ),
              SafeArea(
                child: VideoPlayerControl(
                  controller: controller,
                  videoData: widget.videoData,
                  isControlVisible: isControlVisible,
                  toggleControllVisibility: toggleControlVisibility,
                  settings: widget.settings,
                ),
              )
            ],
          ),
        ));
  }
}

class VideoPlayerControl extends StatefulWidget {
  VlcPlayerController controller;
  VideoDatabaseModel videoData;
  bool isControlVisible;
  Function toggleControllVisibility;
  SettingsModel? settings;

  VideoPlayerControl(
      {super.key,
      required this.controller,
      required this.videoData,
      required this.isControlVisible,
      required this.toggleControllVisibility,
      this.settings});

  @override
  State<VideoPlayerControl> createState() => _VideoPlayerControlState();
}

class _VideoPlayerControlState extends State<VideoPlayerControl> {
  String duration = "";
  String position = "";
  String totalDuration = "";
  bool isPlaying = false;
  double sliderValue = 0.0;
  bool validPosition = false;

  bool isPortrait = false;
  Map<int, String> spuTracks = Map();
  Map<int, String> audioTracks = Map();

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(videoPlayerListener);
    Future.delayed(const Duration(milliseconds: 500), () async {
      final _spuTracks = await widget.controller.getSpuTracks();
      final _audioTracks = await widget.controller.getAudioTracks();

      setState(() {
        spuTracks = _spuTracks;
        audioTracks = _audioTracks;
        isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
      });
    });
  }

  void videoPlayerListener() async {
    final controller = widget.controller;
    if (!mounted) return;

    if (controller.value.isInitialized) {
      final oPosition = controller.value.position;
      final oDuration = controller.value.duration;

      if (oPosition != null && oDuration != null) {
        if (oDuration.inHours == 0) {
          final strPosition = oPosition.toString().split('.').first;
          final strDuration = oDuration.toString().split('.').first;
          setState(() {
            position =
                "${strPosition.split(':')[1]}:${strPosition.split(':')[2]}";
            duration =
                "${strDuration.split(':')[1]}:${strDuration.split(':')[2]}";
          });
        } else {
          setState(() {
            position = oPosition.toString().split('.').first;
            // color: Colors.blue.withAlpha(100),
            duration = oDuration.toString().split('.').first;
          });
        }
        setState(() {
          validPosition = oDuration.compareTo(oPosition) >= 0;
          sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
        });
      }

      setState(() {
        isPlaying = controller.value.isPlaying;
      });
    }
  }

  void onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    //convert to Milliseconds since VLC requires MS to set time
    widget.controller
        .setTime(sliderValue.toInt() * Duration.millisecondsPerSecond);
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(videoPlayerListener);
  }

  void changeOrientation() {
    if (widget.settings!.forceDeviceOrientation !=
        SettingDeviceOrientation.auto) return;
    if (isPortrait) {
      setState(() {
        isPortrait = false;
      });

      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      setState(() {
        isPortrait = true;
      });
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    }
  }

  void onCCPressed() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Subtitle",
                  style: Theme.of(context).textTheme.headlineSmall,
                ).padding(all: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: spuTracks.keys.length + 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        index < spuTracks.keys.length
                            ? spuTracks.values.elementAt(index).toString()
                            : 'Disable',
                      ),
                      onTap: () async {
                        final selectedSubId = index < spuTracks.keys.length
                            ? spuTracks.keys.elementAt(index)
                            : -1;
                        await widget.controller.setSpuTrack(selectedSubId);
                        Navigator.pop(context);
                      },
                    );
                  },
                )
              ],
            ),
          );
        });
  }

  void onAudioTrackPressed() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) {
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Audio Tracks",
                  style: Theme.of(context).textTheme.headlineSmall,
                ).padding(all: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: spuTracks.keys.length + 1,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        index < audioTracks.keys.length
                            ? audioTracks.values.elementAt(index).toString()
                            : 'Disable',
                      ),
                      onTap: () async {
                        final selectedAudioTracks =
                            index < spuTracks.keys.length
                                ? audioTracks.keys.elementAt(index)
                                : -1;
                        await widget.controller
                            .setAudioTrack(selectedAudioTracks);
                        Navigator.pop(context);
                      },
                    );
                  },
                )
              ],
            ),
          );
        });
  }

  IconData getOrientationIcon() {
    if (widget.settings != null &&
        widget.settings!.forceDeviceOrientation ==
            SettingDeviceOrientation.landscape) {
      return Icons.screen_lock_landscape;
    } else if (widget.settings != null &&
        widget.settings!.forceDeviceOrientation ==
            SettingDeviceOrientation.portrait) {
      return Icons.screen_lock_portrait;
    } else {
      if (isPortrait) {
        return Icons.stay_primary_portrait;
      }
      return Icons.stay_primary_landscape;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isControlVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.transparent,
                Colors.black
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.2, 0.7, 1],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    widget.videoData.fileName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ).bold(),
                ],
              ),
              Expanded(child: Container()),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FilledButton(
                          style: FilledButton.styleFrom(
                              shape: const CircleBorder()),
                          onPressed: changeOrientation,
                          child: Icon(getOrientationIcon())),
                      FilledButton(
                          style: FilledButton.styleFrom(
                              shape: const CircleBorder()),
                          onPressed: onAudioTrackPressed,
                          child: const Icon(Icons.audiotrack)),
                      FilledButton(
                          style: FilledButton.styleFrom(
                              shape: const CircleBorder()),
                          onPressed: spuTracks.isNotEmpty ? onCCPressed : null,
                          child: const Icon(Icons.closed_caption))
                    ],
                  ),
                  Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withOpacity(0.3),
                      min: 0.0,
                      max: !validPosition
                          ? 1.0
                          : widget.controller.value.duration.inSeconds
                              .toDouble(),
                      value: sliderValue,
                      onChanged: onSliderPositionChanged),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(position),
                      Row(
                        children: [
                          FilledButton(
                            child: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow),
                            onPressed: () {
                              widget.toggleControllVisibility();
                              if (!isPlaying) {
                                widget.controller.play();
                              } else {
                                widget.controller.pause();
                              }
                            },
                          ),
                        ],
                      ),
                      Text(duration)
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}
