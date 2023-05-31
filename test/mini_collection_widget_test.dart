import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mini_collection_poc/data.dart';
import 'package:mini_collection_poc/image_widget.dart';
import 'package:mini_collection_poc/mini_collection_widget.dart';
import 'package:mini_collection_poc/thirdparty/orientation.dart';
import 'package:mini_collection_poc/thirdparty/tilt.dart';

Future<void> main() async {
  await loadAppFonts();

  ImageWidget.debugUseImageAsset = true;
  TiltBuilder.debugIsEnabled = false;
  OrientationProvider.debugIsEnabled = false;

  group('MiniCollectionWidget', () {
    testGoldens('goldens', (tester) async {
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          Device.phone,
          Device.iphone11,
          Device.tabletPortrait,
          Device.tabletLandscape,
        ])
        ..addScenario(
          name: 'Mini Collection 1',
          widget: MiniCollectionWidget(collections[0]),
        )
        ..addScenario(
          name: 'Mini Collection 2',
          widget: MiniCollectionWidget(collections[1]),
        )
        ..addScenario(
          name: 'Mini Collection 3',
          widget: MiniCollectionWidget(collections[2]),
        );

      await tester.pumpDeviceBuilder(builder);
      await tester.runAsync(() => Future.delayed(const Duration(seconds: 1)));
      await tester.pumpAndSettle();

      await screenMatchesGolden(tester, 'mini_collection_widget');
    });
  });
}
