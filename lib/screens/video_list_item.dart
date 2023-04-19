import 'package:flutter/material.dart';
import 'package:another_vp/screens/thumbnail_image_preview.dart';
import 'package:styled_widget/styled_widget.dart';

class VideoListItem extends StatelessWidget {
  final String title;
  final String thumbnailPath;
  final String resolution;
  final String duration;
  final Function() onTap;
  final String metadata;

  const VideoListItem(
      {super.key,
      required this.title,
      required this.thumbnailPath,
      required this.resolution,
      required this.duration,
      required this.onTap,
      required this.metadata});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ThumbnailImagePreview(thumbnailPath: thumbnailPath),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: SizedBox(
                height: 200 / 1.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ).bold(),
                    ),
                    Text(
                      resolution.trim(),
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: Text(
                            duration,
                            style: Theme.of(context).textTheme.labelSmall,
                          ).bold(),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 4),
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4))),
                          child: Text(
                            metadata.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall,
                          ).bold(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
