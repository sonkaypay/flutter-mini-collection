import 'package:flutter/material.dart';
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
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        final expectedTotalBytes = loadingProgress.expectedTotalBytes;
        return Center(
          child: CircularProgressIndicator.adaptive(
            value: expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }
}
