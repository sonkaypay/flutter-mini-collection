import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart' as lib;
import 'package:mini_collection_poc/blur_hash_widget.dart' as our;
import 'package:mini_collection_poc/data.dart';

class ImageWidget extends StatelessWidget {
  static bool debugUseImageAsset = false;
  static bool debugUseFlutterBlurHash = false;

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
              child: debugUseFlutterBlurHash
                  ? lib.BlurHash(hash: data.blurHash)
                  // Attempt a custom implementation with shader to avoid
                  // flickering during BlurHash initial render.
                  // Apparently the lib has to decode the hash,
                  // then build a bitmap image
                  // and finally pass that to the GPU to render.
                  // Our widget has other limitation though, the hash must be 4x3.
                  : our.BlurHashWidget(data.blurHash),
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
