import 'package:avp/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewOptionWidget extends GetView<HomeController> {
  const HomeViewOptionWidget({super.key});

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
              "view_option_title".tr,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.grid_view),
            title: Text("view_option_default".tr),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.list_alt),
            title: Text("view_option_detailed".tr),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(Icons.list_sharp),
            title: Text("view_option_list".tr),
          ),
        ],
      ),
    );
  }
}
