import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mini_collection_poc/data.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart' as lib;
import 'package:mini_collection_poc/blur_hash_widget.dart' as our;

Future<void> main() async {
  await loadAppFonts();

  group('BlurHashWidget', () {
    testGoldens('goldens', (tester) async {
      final builder = GoldenBuilder.grid(columns: 3, widthToHeightRatio: 1)
        ..addCollectionScenarios(0)
        ..addCollectionScenarios(1)
        ..addCollectionScenarios(2);
      await tester.pumpWidgetBuilder(builder.build());

      // wait for the lib to decode hash, generate bitmap, etc.
      await tester.runAsync(() => Future.delayed(const Duration(seconds: 5)));

      await screenMatchesGolden(
        tester,
        'blur_hash_widget',
        autoHeight: true,
      );
    });
  });
}

extension on GoldenBuilder {
  void addCollectionScenarios(int i) {
    final collection = collections[i];
    final nameSuffix = '#${i + 1}';
    final Widget Function(Widget) wrapper = i == 0
        ? (widget) => RotatedBox(
              quarterTurns: 1,
              child: widget,
            )
        : (widget) => widget;

    addScenario(
      'Image $nameSuffix',
      wrapper(
        AspectRatio(
          aspectRatio: collection.aspectRatio,
          child: Image.asset(collection.assetName),
        ),
      ),
    );
    addScenario(
      'flutter_blurhash $nameSuffix',
      wrapper(
        AspectRatio(
          aspectRatio: collection.aspectRatio,
          child: lib.BlurHash(hash: collection.blurHash),
        ),
      ),
    );
    addScenario(
      'Custom $nameSuffix',
      wrapper(
        AspectRatio(
          aspectRatio: collection.aspectRatio,
          child: our.BlurHashWidget(collection.blurHash),
        ),
      ),
    );
  }
}
