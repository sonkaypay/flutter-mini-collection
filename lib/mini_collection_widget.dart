import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mini_collection_poc/data.dart';
import 'package:mini_collection_poc/image_widget.dart';
import 'package:mini_collection_poc/product_tag_widget.dart';
import 'package:mini_collection_poc/thirdparty/orientation.dart';

class MiniCollectionWidget extends StatelessWidget {
  final MiniCollection data;

  const MiniCollectionWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationProvider(
      child: _MiniCollectionLayout(
        data,
        children: [
          ImageWidget(data),
          ...data.products.map(ProductTagWidget.new),
        ],
      ),
    );
  }
}

class _MiniCollectionLayout extends MultiChildRenderObjectWidget {
  final MiniCollection data;

  const _MiniCollectionLayout(this.data, {super.children});

  @override
  RenderObject createRenderObject(BuildContext _) =>
      _MiniCollectionLayoutRenderObject(data: data);

  @override
  void updateRenderObject(
          BuildContext _, _MiniCollectionLayoutRenderObject renderObject) =>
      renderObject.setData(data);
}

class _MiniCollectionLayoutData extends ContainerBoxParentData<RenderBox> {}

class _MiniCollectionLayoutRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _MiniCollectionLayoutData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _MiniCollectionLayoutData> {
  MiniCollection _data;

  var _imageIsReady = false;

  _MiniCollectionLayoutRenderObject({
    required MiniCollection data,
  }) : _data = data;

  void setData(MiniCollection data) {
    if (!identical(data, _data)) return;
    _data = data;
    markNeedsLayout();
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);

  @override
  void paint(PaintingContext context, Offset offset) {
    var child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as _MiniCollectionLayoutData;
      context.paintChild(child, childParentData.offset + offset);
      child = childParentData.nextSibling;

      if (!_imageIsReady) {
        // image is still loading, do not render the product tags
        return;
      }
    }
  }

  @override
  void performLayout() {
    final firstRatio = guessChildRatio(firstChild);
    final viewportSize =
        (constraints.hasBoundedHeight && constraints.hasBoundedWidth)
            ? constraints.biggest
            : constraints.smallest;
    final backgroundRect = calculateBackgroundRect(viewportSize, firstRatio);
    final backgroundOffset = backgroundRect.topLeft;
    _imageIsReady = firstChild is RenderImage && (firstRatio ?? .0) > 0;

    RenderBox? child = firstChild;
    var i = 0;
    while (child != null) {
      final childData = child.parentData! as _MiniCollectionLayoutData;
      final childIsBackground = i == 0;
      child.layout(
        childIsBackground
            ? BoxConstraints.tight(backgroundRect.size)
            : const BoxConstraints(),
      );
      if (childIsBackground) {
        childData.offset = backgroundOffset;
      } else {
        final product = _data.products[i - 1];
        childData.offset = Offset(
          backgroundOffset.dx + product.position.dx * backgroundRect.width,
          backgroundOffset.dy + product.position.dy * backgroundRect.height,
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

  static double? guessChildRatio(RenderBox? child) {
    if (child == null) {
      return null;
    }

    const height = 100.0;
    final width = child.getMaxIntrinsicWidth(height);
    if (width == 0) {
      return null;
    }

    return width / height;
  }

  static Rect calculateBackgroundRect(Size viewportSize, double? imageRatio) {
    final viewportRatio = viewportSize.width / viewportSize.height;
    if (imageRatio == null) {
      // image is still loading, no need to calculate
      return Rect.fromLTWH(0, 0, viewportSize.width, viewportSize.height);
    }

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
