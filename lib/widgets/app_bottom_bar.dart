import 'package:flutter/material.dart';

class AppBottomNavbar extends StatefulWidget {
  final Function(int) onTabChange;
  final PageController pageController;

  const AppBottomNavbar(
      {super.key, required this.onTabChange, required this.pageController});

  @override
  State<AppBottomNavbar> createState() => _AppBottomNavbarState();
}

class _AppBottomNavbarState extends State<AppBottomNavbar> {
  int _selectedIndex = 0;

  void _onNavigationDestinationChange(int selectedIndex) {
    setState(() {
      _selectedIndex = selectedIndex;
    });

    widget.onTabChange(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavigationDestinationChange,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Home",
            selectedIcon: Icon(Icons.home),
          ),
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            label: "Library",
            selectedIcon: Icon(Icons.video_library),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: "Settings",
            selectedIcon: Icon(Icons.settings),
          )
        ]);
  }
}
