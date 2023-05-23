import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerEventBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, AccelerometerEvent? event)
      builder;

  const AccelerometerEventBuilder({required this.builder, super.key});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return builder(context, null);
    }

    return StreamBuilder<AccelerometerEvent>(
      builder: (context, snapshot) {
        return builder(context, snapshot.data);
      },
      stream: accelerometerEvents,
    );
  }
}
