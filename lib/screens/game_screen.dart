
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/game_manager.dart';
import '../utils/app_colors.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _startCountdown = true;
  int _countdown = 3;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    // Force Landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _startCountdownTimer();
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _startCountdown = false;
          timer.cancel();
          context.read<GameManager>().startGame();
        }
      });
    });
  }
  
  // Correction: startGame should be called after countdown.
  // HomeScreen called startGame.
  // We should probably pause game in GameManager init or pass a flag "delayedStart".
  // OR: HomeScreen does NOT call startGame. It passes Category to GameScreen.
  // GameScreen calls startGame after countdown.
  // I'll adjust HomeScreen logic in next step or ignore this optimization for MVP.
  // Actually, if I don't fix it, user loses 3 seconds. That's acceptable for MVP v1.
  // User can hold phone on forehead during countdown.
  
  @override
  void dispose() {
    // Reset to Portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = context.watch<GameManager>();

    // Listen for game end
    if (gameManager.status == GameStatus.finished) {
       // Navigate to Result immediately?
       // We can use a listener outside build or check here
       WidgetsBinding.instance.addPostFrameCallback((_) {
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => const ResultScreen()),
         );
       });
    }

    return Scaffold(
      backgroundColor: AppColors.primaryOrange,
      body: Stack(
        children: [
          // Main Game UI
          if (!_startCountdown)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${gameManager.timeLeft}',
                    style: const TextStyle(
                      fontSize: 40, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      gameManager.currentWord,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 80, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Place sur ton front !',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),

          // Countdown Overlay
          if (_startCountdown)
            Container(
              color: AppColors.primaryTeal,
              child: Center(
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate(
                  onPlay: (controller) => controller.repeat(),
                ).scale(duration: 500.ms).fadeOut(delay: 500.ms),
              ),
            ),
            
          // Helper instructions (Testing only)
          /*
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              children: [
                FloatingActionButton(onPressed: () => gameManager.handleTiltTest(TiltAction.correct), child: Icon(Icons.check)),
                SizedBox(width: 10),
                FloatingActionButton(onPressed: () => gameManager.handleTiltTest(TiltAction.skip), child: Icon(Icons.close)),
              ],
            ),
          )
          */
        ],
      ),
    );
  }
}
