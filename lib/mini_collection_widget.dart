import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mini_collection_poc/data.dart';
import 'package:mini_collection_poc/product_tag_widget.dart';
import 'package:mini_collection_poc/thirdparty/orientation.dart';

class MiniCollectionWidget extends StatefulWidget {
  static bool debugDeterministicIndicator = false;

  final MiniCollection data;

  const MiniCollectionWidget(this.data, {super.key});

  @override
  State<MiniCollectionWidget> createState() => _MiniCollectionWidgetState();
}

class _MiniCollectionWidgetState extends State<MiniCollectionWidget> {
  final imageKey = GlobalKey();

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
    final image = Image(image: imageProvider, key: imageKey);

    return FutureBuilder(
      future: imageSizeCompleter?.future,
      builder: (context, AsyncSnapshot<Size> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: MiniCollectionWidget.debugDeterministicIndicator
                ? image
                : const CircularProgressIndicator.adaptive(),
          );
        }

        final size = MediaQuery.sizeOf(context);
        final side = size.shortestSide;
        final iconSize = max(44.0, side / 10);

        return OrientationProvider(
          child: _MiniCollectionLayout(
            data: widget.data,
            imageSize: snapshot.requireData,
            children: [
              image,
              for (final product in widget.data.products)
                ProductTagWidget(
                  product,
                  iconSize: iconSize,
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MiniCollectionLayout extends MultiChildRenderObjectWidget {
  final MiniCollection data;
  final Size imageSize;

  const _MiniCollectionLayout({
    super.children,
    required this.data,
    required this.imageSize,
  });

  @override
  RenderObject createRenderObject(BuildContext _) =>
      _MiniCollectionLayoutRenderObject(
        data: data,
        imageSize: imageSize,
      );

  @override
  void updateRenderObject(BuildContext context,
          covariant _MiniCollectionLayoutRenderObject renderObject) =>
      renderObject
        ..setData(data)
        ..setImageSize(imageSize);
}

class _MiniCollectionLayoutData extends ContainerBoxParentData<RenderBox> {}

class _MiniCollectionLayoutRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MiniCollectionLayoutData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MiniCollectionLayoutData> {
  MiniCollection _data;
  Size _imageSize;

  _MiniCollectionLayoutRenderObject({
    required MiniCollection data,
    required Size imageSize,
  })  : _data = data,
        _imageSize = imageSize;

  void setData(MiniCollection data) {
    if (!identical(data, _data)) return;
    _data = data;
    markNeedsLayout();
  }

  void setImageSize(Size imageSize) {
    if (imageSize != _imageSize) return;
    _imageSize = imageSize;
    markNeedsLayout();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  void performLayout() {
    final viewportSize =
        (constraints.hasBoundedHeight && constraints.hasBoundedWidth)
            ? constraints.biggest
            : _imageSize;
    Rect image = calculateImageRect(_imageSize, viewportSize);
    final imageOffset = image.topLeft;

    RenderBox? child = firstChild;
    var i = 0;
    while (child != null) {
      final childData = child.parentData! as _MiniCollectionLayoutData;
      final childIsImage = i == 0;
      child.layout(
        childIsImage
            ? BoxConstraints.tight(image.size)
            : const BoxConstraints(),
      );
      if (childIsImage) {
        childData.offset = imageOffset;
      } else {
        final product = _data.products[i - 1];
        childData.offset = Offset(
          imageOffset.dx + product.position.dx * image.width,
          imageOffset.dy + product.position.dy * image.height,
        );
      }

      child = childData.nextSibling;
      i++;
    }

    size = constraints.constrain(viewportSize);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _MiniCollectionLayoutData) {
      child.parentData = _MiniCollectionLayoutData();
    }
  }

  static Rect calculateImageRect(Size imageSize, Size viewportSize) {
    final viewportRatio = viewportSize.width / viewportSize.height;
    final imageRatio = imageSize.width / imageSize.height;

    double imageHeight, imageWidth, left, top;
    double hiddenArea;
    if (imageRatio > viewportRatio) {
      // too wide
      imageHeight = viewportSize.height;
      imageWidth = imageHeight * imageRatio;
      final deltaWidth = viewportSize.width - imageWidth;
      left = deltaWidth / 2;
      top = 0;
      hiddenArea = deltaWidth.abs() * imageHeight;
    } else {
      // too tall
      imageWidth = viewportSize.width;
      imageHeight = imageWidth / imageRatio;
      final deltaHeight = viewportSize.height - imageHeight;
      left = 0;
      top = deltaHeight / 2;
      hiddenArea = deltaHeight.abs() * imageWidth;
    }

    if (hiddenArea > (imageWidth * imageHeight * .2)) {
      // too much hidden area, display with black bar
      if (imageRatio > viewportRatio) {
        imageWidth = viewportSize.width;
        imageHeight = imageWidth / imageRatio;
        left = 0;
        top = (viewportSize.height - imageHeight) / 2;
      } else {
        imageHeight = viewportSize.height;
        imageWidth = imageHeight * imageRatio;
        left = (viewportSize.width - imageWidth) / 2;
        top = 0;
      }
    }

    return Rect.fromLTWH(left, top, imageWidth, imageHeight);
  }
}
