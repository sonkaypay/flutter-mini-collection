import 'package:flutter/material.dart';
import 'package:mini_collection_poc/data.dart';
import 'package:mini_collection_poc/thirdparty/orientation.dart';
import 'package:mini_collection_poc/thirdparty/tilt.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class ProductTagWidget extends StatefulWidget {
  final double iconSize;
  final Product product;

  const ProductTagWidget(
    this.product, {
    required this.iconSize,
    super.key,
  });

  @override
  State<ProductTagWidget> createState() => _ProductTagWidgetState();
}

class _ProductTagWidgetState extends State<ProductTagWidget> {
  @override
  Widget build(BuildContext context) {
    return TiltBuilder(
      builder: (context, tilt) {
        final orientation = OrientationProvider.of(context);
        final angle = switch (orientation) {
          NativeDeviceOrientation.landscapeLeft => tilt.dx,
          NativeDeviceOrientation.landscapeRight => -tilt.dx,
          NativeDeviceOrientation.portraitUp => tilt.dy,
          _ => .0
        };
        final iconSize = widget.iconSize;

        return Transform.translate(
          offset: Offset(-iconSize / 2, -iconSize / 2),
          child: Transform.rotate(
            angle: angle,
            child: IconButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.product.name),
                  duration: const Duration(milliseconds: 100),
                ),
              ),
              icon: Image.asset(
                'assets/flaticon/price-tag.png',
                height: iconSize,
                width: iconSize,
              ),
            ),
          ),
        );
      },
    );
  }
}
