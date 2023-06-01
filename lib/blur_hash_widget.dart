import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

class BlurHashWidget extends StatefulWidget {
  final String hash;

  const BlurHashWidget(this.hash, {super.key});

  @override
  State<BlurHashWidget> createState() => _BlurHashState();
}

class _BlurHashState extends State<BlurHashWidget> {
  late final BlurHash decoded;

  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    decoded = BlurHash.decode(widget.hash);

    final numX = decoded.numCompX;
    final numY = decoded.numCompY;
    final byteData = ByteData(numX * numY * 4 * 4);
    for (var j = 0; j < numY; j++) {
      final component = decoded.components[j];
      for (var i = 0; i < numX; i++) {
        const numberOfFloatsPerPixel = 4;
        const numberOfBytesPerFloat = 4;
        final vecOffset =
            (i * numberOfFloatsPerPixel + j * numX * numberOfFloatsPerPixel) *
                numberOfBytesPerFloat;
        final colorTriplet = component[i];
        byteData.setFloat32(vecOffset, colorTriplet.r);
        byteData.setFloat32(
            vecOffset + 1 * numberOfBytesPerFloat, colorTriplet.g);
        byteData.setFloat32(
            vecOffset + 2 * numberOfBytesPerFloat, colorTriplet.b);
        byteData.setFloat32(vecOffset + 3 * numberOfBytesPerFloat, 1.0);
      }
    }
    final pixels = byteData.buffer.asUint8List();
    print(pixels);
    ui.decodeImageFromPixels(pixels, numX, numY, ui.PixelFormat.rgbaFloat32,
        (image) {
      image.toByteData(format: ui.ImageByteFormat.rawRgba).then((value) {
        print(value?.buffer.asUint8List());
      });
    });

    // ui.ImmutableBuffer.fromUint8List(byteData.buffer.asUint8List()).then(
    //   (buffer) async {
    //     final imageDescriptor = ui.ImageDescriptor.raw(
    //       buffer,
    //       height: numY,
    //       width: numX,
    //       pixelFormat: ui.PixelFormat.rgbaFloat32,
    //     );
    //     final codec = await imageDescriptor.instantiateCodec();
    //     ui.decodeImageFromPixels(pixels, width, height, format, (result) { })
    //     final frame = await codec.getNextFrame();
    //     if (mounted) setState(() => _image = frame.image);

    //     frame.image
    //         .toByteData(format: ui.ImageByteFormat.rawRgba)
    //         .then((value) {
    //       print(value?.buffer.asUint8List());
    //     });
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      (context, shader, child) {
        final image = _image;
        final key = '${widget.hash}-${image != null ? 1 : 0}';
        print('key=$key');

        return CustomPaint(
          key: ValueKey(key),
          painter: image != null ? _BlurHashPainter(image, shader) : null,
          child: child,
        );
      },
      assetKey: 'shaders/blurhash.glsl',
    );
  }
}

class _BlurHashPainter extends CustomPainter {
  final ui.Image image;
  final FragmentShader shader;

  _BlurHashPainter(this.image, this.shader) {
    shader.setFloat(0, image.width.toDouble());
    shader.setFloat(1, image.height.toDouble());
    shader.setImageSampler(0, image);
  }

  @override
  void paint(Canvas canvas, Size size) {
    shader.setFloat(2, size.width);
    shader.setFloat(3, size.height);

    final paint = Paint()..shader = shader;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_BlurHashPainter oldDelegate) => false;
}
