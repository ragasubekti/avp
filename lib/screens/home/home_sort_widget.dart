import 'package:avp/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSortWidget extends GetView<HomeController> {
  const HomeSortWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Text(
              "sort_by_title".tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.sort_by_alpha),
            title: Text("sort_by_alphabet".tr),
            trailing: Icon(Icons.arrow_downward),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.numbers),
            title: Text("sort_by_duration".tr),
            trailing: Icon(Icons.arrow_downward),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.video_file_outlined),
            title: Text("sort_by_recently_added".tr),
            trailing: Icon(Icons.arrow_downward),
          ),
        ],
      ),
    );
  }
}
