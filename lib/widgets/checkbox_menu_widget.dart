import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

enum MenuItemType { dropdown, checkbox, none }

class MenuItem extends StatelessWidget {
  bool disabled;
  bool enabled;
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function() onPressed;
  MenuItemType type;

  MenuItem(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.subtitle,
      required this.icon,
      this.enabled = false,
      this.disabled = false,
      this.type = MenuItemType.none});

  Widget renderRightMenu() {
    switch (type) {
      case MenuItemType.dropdown:
        return Container();
      case MenuItemType.checkbox:
        return renderCheckbox();
      default:
        return Container();
    }
  }

  Widget renderCheckbox() {
    return Checkbox(value: enabled, onChanged: (v) {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !disabled ? onPressed : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title).bold(),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ),
            ),
            renderRightMenu()
          ],
        ),
      ),
    );
  }
}
