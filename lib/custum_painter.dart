import 'dart:math';

import 'package:flutter/material.dart';

class CustomPaintScreen extends StatelessWidget {
  const CustomPaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('TestScreen'),
      ),
      body: Center(
        child: Container(
          width: 200,
          height: 200,
          color: Colors.white,
          child: CustomPaint(
            // child 앞에 위치
            foregroundPainter: LinePainter(),
            // child 뒤에 위치
            painter:TrianglePainter(),
            // ArcPainter(),
            // CirclePainter(),
            // RectPainter(),
            // RRectPainter(),

            child: Center(
                child: Text(
                  "Hi",
                  style: TextStyle(
                    fontSize: 150,
                    color: Colors.purple[900],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}

//삼각형 그리기
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final paint = Paint()
      ..strokeWidth = 10
      ..color = Colors.green
      ..style = PaintingStyle.stroke;

    final x = size.width;
    final y = size.height;

    //이동
    path.moveTo(x / 5, y / 5);
    //선 그리며 이동
    path.lineTo(x * 4 / 5, y / 5);
    path.lineTo(x / 2, y * 2 / 3);
    path.lineTo(x / 5, y / 5);

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

//호 그리기
class ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 10.0
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(
      size.width * 0.3,
      size.height * 0.7,
    );

    path.arcToPoint(
      Offset(
        size.width * 0.7,
        size.height * 0.7,
      ),
      radius: const Radius.circular(80),
      // true면 위로 볼록, false며 아래로 볼록
      clockwise: false,
    );

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 원 그리기
class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.greenAccent;

    canvas.drawCircle(
      Offset(
        size.width / 2,
        size.height / 2,
      ),
      min(size.width, size.height) / 3,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

//모서리가 깎인 사각형 그리기
class RRectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromPoints(
          Offset(size.width * 1 / 6, size.height * 1 / 6),
          Offset(size.width * 5 / 6, size.height * 5 / 6),
        ),
        Radius.circular(20.0),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 사각형 그리기
class RectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 10.0
      ..style = PaintingStyle.stroke;
    canvas.drawRect(
      Rect.fromPoints(
        Offset(size.width * 1 / 6, size.height * 1 / 6),
        Offset(size.width * 5 / 6, size.height * 5 / 6),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// 라인 그리기
class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 10.0
      ..color = Colors.red
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 1 / 6, size.height * 1 / 6),
      Offset(size.width * 5 / 6, size.height * 5 / 6),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
