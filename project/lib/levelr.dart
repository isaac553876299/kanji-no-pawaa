import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MyLockPattern extends CustomPainter {
  final List<Offset> positions;
  final Offset? offset;
  final List<int> codes;
  final Function(int code) onSelect;
  MyLockPattern({
    required this.positions,
    required this.offset,
    required this.codes,
    required this.onSelect,
  });
  @override
  bool shouldRepaint(MyLockPattern oldDelegate) {
    return offset != oldDelegate.offset;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Color non = Colors.grey.shade700;
    Color sel = Colors.white;

    int lastIn = -1;

    for (var i = 0; i < 7; ++i) {
      var pathOut = Path()
        ..addOval(Rect.fromCircle(
            center: positions[i].translate(size.width / 2, size.height / 2),
            radius: 30));

      if (offset != null && pathOut.contains(offset!)) lastIn = i;

      var painter = Paint()
        ..strokeWidth = 1.0
        ..color = codes.contains(i) ? sel : non;
      canvas.drawPath(pathOut, painter..style = PaintingStyle.stroke);
    }
    onSelect(lastIn);
  }
}

class LevelR extends StatefulWidget {
  const LevelR({
    super.key,
    required this.onReFilter,
  });
  final Function(int code) onReFilter;
  @override
  State<LevelR> createState() => _LevelRState();
}

class _LevelRState extends State<LevelR> {
  Offset? offset;
  List<int> codes = [];
  bool lastIn = false;

  void modify(int code) {
    if (code == -1) {
      lastIn = false;
    } else if (!lastIn) {
      lastIn = true;
      if (!codes.contains(code)) {
        codes.add(code);
      } else {
        codes.remove(code);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var r = 130;
    var positions = List<Offset>.generate(
      7,
      (i) => Offset(
        r * cos(i * 2 * pi / 6),
        r * sin(i * 2 * pi / 6),
      ),
      growable: false,
    );
    positions[6 /*last*/] = Offset(0, 0);
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onPanDown: (_) => setState(
            () {
              offset = _.localPosition;
              codes.clear();
            },
          ),
          onPanUpdate: (_) => setState(() => offset = _.localPosition),
          onPanEnd: (_) => setState(
            () {
              int newCode = codes
                  //.join('+')
                  .fold(0, (l, r) => l |= 1 << r);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    newCode.toString(),
                  ),
                  duration: const Duration(milliseconds: 250),
                ),
              );
              widget.onReFilter(newCode);
            },
          ),
          child: CustomPaint(
            size: Size.fromWidth(MediaQuery.of(context).size.width),
            painter: MyLockPattern(
              positions: positions,
              codes: codes,
              offset: offset,
              onSelect: modify,
            ),
          ),
        ),
        for (var i = 0; i < 7; ++i)
          Transform(
            transform: Matrix4.identity()
              ..translate(positions[i].dx, positions[i].dy),
            child: Text(
              '➀➁➂➃➄➅Ⓢ'[i],
              style: TextStyle(
                color: codes.contains(i) ? Colors.white : Colors.grey.shade700,
                fontSize: 64,
                height: 1.14,
              ),
            ),
          ),
      ],
    );
  }
}
