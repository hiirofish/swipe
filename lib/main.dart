import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

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

  // ジェスチャーデバッグ用の変数を追加
  int _gestureAttempts = 0;
  int _gestureSuccesses = 0;
  double? _lastSpeed;
  DateTime? _lastGestureTime;

  void _handleSwipe(DragEndDetails details) {
    if (kDebugMode) {
      debugPrint('\n--- New Gesture Detected ---');
    }

    final now = DateTime.now();
    _gestureAttempts++;
    
    final velocity = details.velocity.pixelsPerSecond;
    final speed = velocity.dx.abs() > velocity.dy.abs() ? velocity.dx.abs() : velocity.dy.abs();
    
    // 完全な無効ジェスチャーのチェック
    if (velocity.dx == 0 && velocity.dy == 0 && details.primaryVelocity == 0) {
      // 前回の有効なジェスチャーからの経過時間をチェック
      if (_lastGestureTime != null) {
        final timeDiff = now.difference(_lastGestureTime!).inMilliseconds;
        
        // 高速フリック直後の無効化を救済
        if (_lastSpeed != null && _lastSpeed! > 500 && timeDiff < 100) {
          _gestureSuccesses++;
          _handleSuccessfulGesture(details, speed, now);
          return;
        }
        
        // 連続した無効化を救済
        if (timeDiff < 50) {
          _gestureSuccesses++;
          _handleSuccessfulGesture(details, speed, now);
          return;
        }
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('Raw gesture detected:');
      debugPrint('  Speed: $speed');
      debugPrint('  Velocity: dx=${velocity.dx}, dy=${velocity.dy}');
    }
    
    const minVelocity = 50.0; // スワイプを検知する最小速度（より敏感に）
    if (speed > minVelocity || details.primaryVelocity != 0) {
      _gestureSuccesses++;
      if (kDebugMode) {
        debugPrint('Successful gesture:');
        debugPrint('  Success rate: ${(_gestureSuccesses / _gestureAttempts * 100).toStringAsFixed(1)}%');
        debugPrint('  Total attempts: $_gestureAttempts');
      }
      
      _handleSuccessfulGesture(details, speed, now);
    } else {
      if (kDebugMode) {
        debugPrint('Gesture velocity too low:');
        debugPrint('  Required: $minVelocity');
        debugPrint('  Actual speed: $speed');
      }
    }
  }

  void _handleSuccessfulGesture(DragEndDetails details, double speed, DateTime now) {
    _lastSpeed = speed;
    _lastGestureTime = now;
    
    final velocity = details.velocity.pixelsPerSecond;
    if (velocity.dx.abs() > velocity.dy.abs()) {
      // 水平方向のスワイプ
      setState(() {
        if (velocity.dx > 0) {
          // 右スワイプ
          horizontalIndex = (horizontalIndex + 1) % 5;
        } else {
          // 左スワイプ
          horizontalIndex = (horizontalIndex - 1 + 5) % 5;
        }
      });
    } else {
      // 垂直方向のスワイプ
      setState(() {
        if (velocity.dy > 0) {
          // 下スワイプ
          verticalIndex = (verticalIndex + 1) % 5;
        } else {
          // 上スワイプ
          verticalIndex = (verticalIndex - 1 + 5) % 5;
        }
      });
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