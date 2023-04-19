import 'dart:io';

import 'package:flutter/material.dart';

class ThumbnailImagePreview extends StatelessWidget {
  const ThumbnailImagePreview({
    super.key,
    required this.thumbnailPath,
  });

  final String thumbnailPath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        color: Colors.black,
        child: FutureBuilder(
          future: File(thumbnailPath).exists(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.data) {
              case true:
                return Image.file(
                  File(thumbnailPath),
                  width: 200,
                  height: 200 / 1.7,
                  fit: BoxFit.cover,
                );
              default:
                return Container(
                  width: 200,
                  height: 200 / 1.7,
                  decoration: const BoxDecoration(color: Colors.black45),
                  child: const Center(child: Text("Failed to get thumbnail")),
                );
            }
          },
        ),
      ),
    );
  }
}
