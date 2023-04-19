import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:another_vp/core/time_helper.dart';
import 'package:another_vp/db/settings_database.dart';
import 'package:another_vp/db/video_database.dart';
import 'package:another_vp/models/settings_model.dart';
import 'package:another_vp/models/video_database_models.dart';
import 'package:another_vp/screens/video_list_item.dart';
import 'package:another_vp/screens/video_player_screen.dart';
import 'package:sqflite/sqflite.dart';

class VideoListWidget extends StatefulWidget {
  const VideoListWidget({super.key, required this.loading});

  final bool loading;

  @override
  State<VideoListWidget> createState() => VideoListWidgetState();
}

class VideoListWidgetState extends State<VideoListWidget> {
  final TextEditingController _searchController = TextEditingController();
  final vd = VideoDatabase();
  late Database db;

  List<VideoDatabaseModel> videoList = [];
  List<VideoDatabaseModel> filteredVideoList = [];
  int selectedIndex = 0;
  String search = "";

  //
  final SettingsDatabase settingsDb = SettingsDatabase();
  late Database dbS;
  SettingsModel? settings;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      db = await vd.initializeDatabase();
      dbS = await settingsDb.initializeDatabase();

      mapFilesFromDatabase();
    });
  }

  void mapFilesFromDatabase() async {
    var query = await db.query("video_database");
    var sett = await settingsDb.getSettings(dbS);

    var mapped = query.map((e) => vd.mapFromDb(e)).toList();

    setState(() {
      videoList = mapped;
      settings = sett;
    });
  }

  void onSearchSubmit(String value) {
    setState(() {
      search = value;
      var filtered = videoList
          .where((element) =>
              element.fileName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      filteredVideoList = filtered;
    });
  }

  void onVideoPressed(VideoDatabaseModel video) {
    if (settings != null) {
      if (settings!.alwaysOpenExternal) {
        AndroidIntent intent = AndroidIntent(
            action: 'action_view', type: "video/*", data: video.filePath);

        intent.launch();
        return;
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(
                    videoData: video,
                    settings: settings,
                  )));

      return;
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                VideoPlayerScreen(videoData: video, settings: settings)));

    return;
  }

  @override
  Widget build(BuildContext context) {
    if (videoList.isNotEmpty) {
      return SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: SearchBar(
                controller: _searchController,
                hintText: "Search",
                leading:
                    const IconButton(onPressed: null, icon: Icon(Icons.search)),
                trailing: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.grid_view)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.sort))
                ],
                onChanged: (text) {},
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: search.isEmpty
                        ? videoList.length
                        : filteredVideoList.length,
                    itemBuilder: (context, index) {
                      final videoItem = search.isEmpty
                          ? videoList[index]
                          : filteredVideoList[index];

                      return VideoListItem(
                          title: videoItem.fileName,
                          thumbnailPath: videoItem.thumbnailPath,
                          resolution: videoItem.resolution,
                          duration: intToTimeLeft(videoItem.duration,
                              showHours: videoItem.duration >= 3600),
                          metadata: videoItem.mimetype,
                          onTap: () => onVideoPressed(videoItem));
                    },
                  ),
                  Visibility(
                    visible: widget.loading,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                      ),
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                              // strokeWidth: 4,
                              // value: 0,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            "Scanning Files...",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Video List is Empty",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text(
              "Try rescanning or manually setting the app storage permission",
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }
  }
}
