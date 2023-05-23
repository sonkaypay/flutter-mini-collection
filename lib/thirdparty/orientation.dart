import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class OrientationProvider extends StatelessWidget {
  static bool debugIsEnabled = true;

  final Widget child;

  const OrientationProvider({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    if (!debugIsEnabled ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return child;
    }

    return NativeDeviceOrientationReader(
      builder: (_) => child,
    );
  }

  static NativeDeviceOrientation of(BuildContext context) {
    if (!debugIsEnabled ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return NativeDeviceOrientation.portraitUp;
    }

    return NativeDeviceOrientationReader.orientation(context);
  }
}
