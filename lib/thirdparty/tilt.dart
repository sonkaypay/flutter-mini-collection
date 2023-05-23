import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tilt/tilt.dart';

class TiltBuilder extends StatelessWidget {
  static bool debugIsEnabled = true;

  final Widget Function(BuildContext context, Offset rotation) builder;

  const TiltBuilder({required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    if (!debugIsEnabled ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return builder(context, Offset.zero);
    }

    return StreamBuilder<Tilt>(
      stream: DeviceTilt(samplingRateMs: 16).stream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return builder(context, Offset.zero);
        }

        return builder(context, Offset(data.xRadian, data.yRadian));
      },
    );
  }
}
