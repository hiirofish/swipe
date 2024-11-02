import 'package:flutter/material.dart';

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

  // ドラッグ開始位置を保存
  Offset? dragStartPosition;

  void _handleDragStart(DragStartDetails details) {
    dragStartPosition = details.globalPosition;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (dragStartPosition == null) return;

    final dragDistance = details.globalPosition - dragStartPosition!;
    const minDistance = 20.0; // スワイプを検知する最小距離

    // 水平方向の移動が垂直方向より大きい場合
    if (dragDistance.dx.abs() > dragDistance.dy.abs()) {
      if (dragDistance.dx.abs() > minDistance) {
        setState(() {
          if (dragDistance.dx > 0) {
            // 右スワイプ
            horizontalIndex = (horizontalIndex + 1) % 5;
          } else {
            // 左スワイプ
            horizontalIndex = (horizontalIndex - 1 + 5) % 5;
          }
          dragStartPosition = details.globalPosition;
        });
      }
    } 
    // 垂直方向の移動が水平方向より大きい場合
    else if (dragDistance.dy.abs() > minDistance) {
      setState(() {
        if (dragDistance.dy > 0) {
          // 下スワイプ
          verticalIndex = (verticalIndex + 1) % 5;
        } else {
          // 上スワイプ
          verticalIndex = (verticalIndex - 1 + 5) % 5;
        }
        dragStartPosition = details.globalPosition;
      });
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    dragStartPosition = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipe Test'),
      ),
      body: Center(
        child: MouseRegion(
          cursor: SystemMouseCursors.move,
          child: GestureDetector(
            onPanStart: _handleDragStart,
            onPanUpdate: _handleDragUpdate,
            onPanEnd: _handleDragEnd,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${numbers[horizontalIndex]}${letters[verticalIndex]}',
                      style: const TextStyle(fontSize: 48),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ドラッグして値を変更',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}