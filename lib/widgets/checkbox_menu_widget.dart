import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class ChecboxMenuWidget extends StatelessWidget {
  bool enabled;
  final String title;
  final String subtitle;
  final IconData icon;
  final void Function() onPressed;

  ChecboxMenuWidget(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.subtitle,
      required this.icon,
      this.enabled = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
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
                  Text(subtitle).fontSize(12).textColor(Colors.black54)
                ],
              ),
            ),
            Checkbox(value: enabled, onChanged: (v) {})
          ],
        ),
      ),
    );
  }
}
