import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DicePage extends StatefulWidget {
  const DicePage({Key? key}) : super(key: key);

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();
  int _diceResult = 0;
  bool _isRolling = false;
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isRolling = false;
          _diceResult = _random.nextInt(20) + 1;
        });
        _flashTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _flashTimer?.cancel();
    super.dispose();
  }

  void _rollDice() {
    setState(() {
      _isRolling = true;
      _flashTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _diceResult = _random.nextInt(20) + 1;
        });
      });
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final i10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(i10n.rollDice),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/d20.png',
                width: 250,
                height: 250,
              ),
            ),
            Text(
              '$_diceResult',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isRolling ? null : _rollDice,
        child: const Icon(Icons.casino),
      ),
    );
  }
}
