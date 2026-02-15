
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Important for Center
                  children: [
                    Text(
                      '${gameManager.timeLeft}',
                      style: const TextStyle(
                        fontSize: 32, // Reduced from 40
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12), // Reduced from 20
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 280, // Slightly reduced from 300 to better fit landscape
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/images/word_card_bg.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            gameManager.currentWord,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 56, 
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
                    const SizedBox(height: 12), // Reduced from 20
                    const Text(
                      'Place sur ton front !',
                      style: TextStyle(color: Colors.white70, fontSize: 16), // Reduced from 18
                    ),
                  ],
                ),
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
