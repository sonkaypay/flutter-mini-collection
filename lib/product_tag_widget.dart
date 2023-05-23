import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mini_collection_poc/data.dart';
import 'package:mini_collection_poc/thirdparty/accelerometer_event.dart';
import 'package:mini_collection_poc/thirdparty/orientation.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class ProductTagWidget extends StatefulWidget {
  final Product product;

  const ProductTagWidget(this.product, {super.key});

  @override
  State<ProductTagWidget> createState() => _ProductTagWidgetState();
}

class _ProductTagWidgetState extends State<ProductTagWidget> {
  @override
  Widget build(BuildContext context) {
    const iconSize = 44.0;

    return AccelerometerEventBuilder(
      builder: (context, data) {
        final orientation = OrientationProvider.of(context);
        final angle = switch (orientation) {
          NativeDeviceOrientation.landscapeLeft => -1 * (data?.y ?? .0),
          NativeDeviceOrientation.landscapeRight => (data?.y ?? .0),
          NativeDeviceOrientation.portraitUp => data?.x ?? .0,
          _ => .0
        };
        return Transform.rotate(
          angle: angle * pi / 18.0,
          child: Transform.translate(
            offset: const Offset(-iconSize / 2, -iconSize / 2),
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
