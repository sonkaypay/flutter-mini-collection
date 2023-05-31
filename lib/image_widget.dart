import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:mini_collection_poc/data.dart';

class ImageWidget extends StatelessWidget {
  static bool debugUseImageAsset = false;

  final MiniCollection data;

  const ImageWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    if (debugUseImageAsset) {
      return Image.asset(
        data.assetName,
        excludeFromSemantics: true,
      );
    }

    return Image.network(
      'https://raw.githubusercontent.com/sonkaypay/flutter-mini-collection/main/${data.assetName}',
      excludeFromSemantics: true,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame != null) return child;

        return Stack(
          children: [
            AspectRatio(
              aspectRatio: data.aspectRatio,
              child: BlurHash(
                hash: data.blurHash,
              ),
            ),
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          ],
        );
      },
    );
  }
}
