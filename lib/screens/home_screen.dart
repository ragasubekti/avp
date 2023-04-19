import 'package:flutter/material.dart';
import 'package:another_vp/core/scan_files.dart';
import 'package:another_vp/db/video_database.dart';
import 'package:another_vp/models/video_database_models.dart';
import 'package:another_vp/screens/settings_screen.dart';
import 'package:another_vp/screens/video_list_widget.dart';
import 'package:another_vp/widgets/app_bottom_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storageDirectory = getApplicationSupportDirectory();
  final PageController _pageController = PageController(initialPage: 0);
  late Database db;

  VideoDatabase vd = VideoDatabase();
  int selectedIndex = 0;
  GlobalKey<VideoListWidgetState> vlWidget = GlobalKey();
  bool isScanning = false;

  void onTabSwitchPage(int index) {
    if (!mounted) return;
    setState(() {
      selectedIndex = index;
    });

    vd.initializeDatabase();
    vlWidget.currentState?.mapFilesFromDatabase();
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastEaseInToSlowEaseOut);
  }

  Future<bool> onWillPop() async {
    if (_pageController.initialPage == _pageController.page) return false;

    _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.fastEaseInToSlowEaseOut);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AppBottomNavbar(
        pageController: _pageController,
        onTabChange: onTabSwitchPage,
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              child: const Icon(Icons.refresh),
              onPressed: () async {
                setState(() {
                  isScanning = true;
                });
                await scanFiles((VideoDatabaseModel? video, bool scanning) {
                  setState(() {
                    isScanning = scanning;
                  });
                  vlWidget.currentState?.mapFilesFromDatabase();
                });
              })
          : null,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: PageView(
          controller: _pageController,
          onPageChanged: onTabSwitchPage,
          children: [
            VideoListWidget(key: vlWidget, loading: isScanning),
            Container(
              color: Colors.black,
            ),
            const SettingsScreen()
          ],
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SearchBar(
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          onTap: () {},
          hintText: "Search",
        ),
      ),
    );
  }
}
