import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mini_collection_poc/data.dart';
import 'package:mini_collection_poc/thirdparty/orientation.dart';
import 'package:mini_collection_poc/thirdparty/tilt.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class ProductTagWidget extends StatelessWidget {
  final Product product;

  const ProductTagWidget(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final side = size.shortestSide;
    final iconSize = max(44.0, side / 10);

    return TiltBuilder(
      builder: (context, tilt) {
        final orientation = OrientationProvider.of(context);
        final angle = switch (orientation) {
          NativeDeviceOrientation.landscapeLeft => tilt.dx,
          NativeDeviceOrientation.landscapeRight => -tilt.dx,
          NativeDeviceOrientation.portraitUp => tilt.dy,
          // TODO: native_device_orientation needs Flutter Web support
          NativeDeviceOrientation.unknown => kIsWeb ? tilt.dy : .0,
          _ => .0
        };

        return Transform.translate(
          offset: Offset(-iconSize / 2, -iconSize / 2),
          child: Transform.rotate(
            angle: angle,
            child: IconButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(product.name),
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
