
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _showInstruction = true;

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
          // Masquer l'instruction après 5 secondes
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted) setState(() => _showInstruction = false);
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    // Safety net : reset portrait si démonté sans navigation normale
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = context.watch<GameManager>();

    // Forcer portrait AVANT navigation vers ResultScreen
    if (gameManager.status == GameStatus.finished) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ResultScreen()),
          );
        }
      });
    }

    return Scaffold(
      backgroundColor: AppColors.primaryOrange,
      body: Stack(
        children: [
          // ── JEU PRINCIPAL ─────────────────────────────────────────────────
          if (!_startCountdown)
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final sw = constraints.maxWidth;
                  final sh = constraints.maxHeight;
                  final isLowTime = gameManager.timeLeft <= 10;

                  return Stack(
                    children: [
                      // ── TIMER : barre de progression + chiffre ────────────
                      Positioned(
                        top: 0,
                        left: 16,
                        right: 16,
                        child: Column(
                          children: [
                            const SizedBox(height: 8),
                            // Chiffre secondes
                            Text(
                              '${gameManager.timeLeft}',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: isLowTime
                                    ? Colors.red[200]
                                    : Colors.white.withOpacity(0.9),
                              ),
                            ).animate(
                              target: isLowTime ? 1 : 0,
                            ).scaleXY(
                              begin: 1.0,
                              end: 1.15,
                              duration: 300.ms,
                              curve: Curves.easeInOut,
                            ),
                            const SizedBox(height: 4),
                            // Barre de progression
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: gameManager.timeLeft / 60.0,
                                minHeight: 6,
                                backgroundColor:
                                    Colors.white.withOpacity(0.25),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isLowTime
                                      ? Colors.red[300]!
                                      : Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── CARTE MOT ────────────────────────────────────────
                      Center(
                        child: Container(
                          width: sw * 0.82,
                          height: sh * 0.58,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/word_card_bg.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 20),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  gameManager.currentWord,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: GoogleFonts.poppins(
                                    fontSize: sw * 0.15,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    height: 1.2,
                                    shadows: [
                                      Shadow(
                                        offset: const Offset(0, 3),
                                        blurRadius: 10,
                                        color:
                                            Colors.black.withOpacity(0.6),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  .animate()
                                  .scale(
                                    duration: 250.ms,
                                    curve: Curves.easeOutBack,
                                  ),
                            ),
                          ),
                        ),
                      ),

                      // ── SCORE LIVE (bas gauche) ───────────────────────────
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Row(
                          children: [
                            Text(
                              '✅ ${gameManager.score}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '❌ ${gameManager.skipCount}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── INSTRUCTION (bas droite, disparaît après 5s) ──────
                      if (_showInstruction)
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Text(
                            'Place sur ton front !',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.65),
                              letterSpacing: 0.8,
                            ),
                          ).animate().fadeIn(duration: 400.ms),
                        ),
                    ],
                  );
                },
              ),
            ),

          // ── COUNTDOWN OVERLAY ─────────────────────────────────────────────
          if (_startCountdown)
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.85,
                  colors: [Color(0xFF00BFA5), Color(0xFF009688)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_countdown',
                      style: GoogleFonts.poppins(
                        fontSize: 150,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        height: 1.0,
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 20,
                            color: Color(0x60000000),
                          ),
                        ],
                      ),
                    ).animate(
                      onPlay: (controller) => controller.repeat(),
                    ).scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.05, 1.05),
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ).fadeOut(delay: 600.ms, duration: 300.ms),
                    const SizedBox(height: 16),
                    Text(
                      'Prépare-toi !',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.70),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

}
