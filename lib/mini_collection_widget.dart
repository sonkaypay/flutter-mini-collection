import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mini_collection_poc/data.dart';

class MiniCollectionWidget extends StatefulWidget {
  final MiniCollection data;

  const MiniCollectionWidget(this.data, {super.key});

  @override
  State<MiniCollectionWidget> createState() => _MiniCollectionWidgetState();
}

class _MiniCollectionWidgetState extends State<MiniCollectionWidget> {
  late final ImageProvider imageProvider;
  late final ImageStream imageStream;
  late final ImageStreamListener imageStreamListener;

  Completer<Size>? imageSizeCompleter;

  @override
  void initState() {
    super.initState();

    imageProvider = AssetImage(widget.data.assetName);

    imageStreamListener = ImageStreamListener(
      (ImageInfo info, bool _) {
        imageStream.removeListener(imageStreamListener);
        final image = info.image;
        final imageSize = Size(image.width.toDouble(), image.height.toDouble());
        imageSizeCompleter?.complete(imageSize);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (imageSizeCompleter == null) {
      imageSizeCompleter = Completer();
      imageStream = imageProvider.resolve(const ImageConfiguration())
        ..addListener(imageStreamListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: imageSizeCompleter?.future,
      builder: (context, AsyncSnapshot<Size> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        final imageSize = snapshot.requireData;
        return AspectRatio(
          aspectRatio: imageSize.width / imageSize.height,
          child: LayoutBuilder(
            builder: (context, bc) {
              final viewportSize = bc.biggest;
              return Stack(
                children: [
                  Image(image: imageProvider),
                  ...widget.data.products.map(
                    (product) => Positioned(
                      left: product.position.dx * viewportSize.width,
                      top: product.position.dy * viewportSize.height,
                      child: ElevatedButton(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(product.name),
                          duration: const Duration(milliseconds: 100),
                        )),
                        child: const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
