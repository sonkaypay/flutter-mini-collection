import 'package:blurhash_dart/blurhash_dart.dart';
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

  @override
  void initState() {
    super.initState();
    decoded = BlurHash.decode(widget.hash);
  }

  @override
  Widget build(BuildContext context) {
    return ShaderBuilder(
      (context, shader, child) {
        return CustomPaint(
          painter: _BlurHashPainter(decoded, shader),
          child: child,
        );
      },
      assetKey: 'shaders/blurhash.glsl',
    );
  }
}

class _BlurHashPainter extends CustomPainter {
  final BlurHash decoded;
  final FragmentShader shader;

  var _hasRangeError = false;

  _BlurHashPainter(this.decoded, this.shader) {
    try {
      for (var j = 0; j < decoded.numCompY; j++) {
        final component = decoded.components[j];
        for (var i = 0; i < decoded.numCompX; i++) {
          const colorsOffset = 2;
          const numberOfFloatsPerVec3 = 3;
          final vecOffset = colorsOffset +
              i * numberOfFloatsPerVec3 +
              j * decoded.numCompX * numberOfFloatsPerVec3;
          final vec3 = component[i];
          shader.setFloat(vecOffset, vec3.r);
          shader.setFloat(vecOffset + 1, vec3.g);
          shader.setFloat(vecOffset + 2, vec3.b);
        }
      }
    } on RangeError {
      // Flutter web has some issue with vec3 array in shader
      // we will capture it here and temporary disable the effect
      _hasRangeError = true;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_hasRangeError) return;

    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    final paint = Paint()..shader = shader;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(_BlurHashPainter oldDelegate) =>
      !identical(decoded, oldDelegate.decoded) ||
      !identical(shader, oldDelegate.shader);
}
