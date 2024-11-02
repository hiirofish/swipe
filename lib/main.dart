import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SwipeTestPage(),
    );
  }
}

class SwipeTestPage extends StatefulWidget {
  const SwipeTestPage({super.key});

  @override
  State<SwipeTestPage> createState() => _SwipeTestPageState();
}

class _SwipeTestPageState extends State<SwipeTestPage> {
  int horizontalIndex = 0;
  int verticalIndex = 0;
  
  final List<String> numbers = ['1', '2', '3', '4', '5'];
  final List<String> letters = ['A', 'B', 'C', 'D', 'E'];

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.velocity;
    const minVelocity = 100.0; // スワイプを検知する最小速度（低めに設定）

    if (velocity.pixelsPerSecond.dx.abs() > velocity.pixelsPerSecond.dy.abs()) {
      // 水平方向のスワイプ
      if (velocity.pixelsPerSecond.dx.abs() > minVelocity) {
        setState(() {
          if (velocity.pixelsPerSecond.dx > 0) {
            // 右スワイプ
            horizontalIndex = (horizontalIndex + 1) % 5;
          } else {
            // 左スワイプ
            horizontalIndex = (horizontalIndex - 1 + 5) % 5;
          }
        });
      }
    } else {
      // 垂直方向のスワイプ
      if (velocity.pixelsPerSecond.dy.abs() > minVelocity) {
        setState(() {
          if (velocity.pixelsPerSecond.dy > 0) {
            // 下スワイプ
            verticalIndex = (verticalIndex + 1) % 5;
          } else {
            // 上スワイプ
            verticalIndex = (verticalIndex - 1 + 5) % 5;
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe Test'),
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
              setState(() {
                horizontalIndex = (horizontalIndex + 1) % 5;
              });
            } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
              setState(() {
                horizontalIndex = (horizontalIndex - 1 + 5) % 5;
              });
            } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              setState(() {
                verticalIndex = (verticalIndex + 1) % 5;
              });
            } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              setState(() {
                verticalIndex = (verticalIndex - 1 + 5) % 5;
              });
            }
          }
        },
        child: GestureDetector(
          onHorizontalDragEnd: _handleSwipe,
          onVerticalDragEnd: _handleSwipe,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${numbers[horizontalIndex]}${letters[verticalIndex]}',
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'スワイプ または ← → ↑ ↓',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}