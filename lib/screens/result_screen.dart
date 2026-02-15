
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/game_manager.dart';
import '../models/game_session.dart';
import '../utils/app_colors.dart';
import '../services/ad_service.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _random = Random();

  @override
  void initState() {
    super.initState();
    // Double sécurité : s'assurer qu'on est bien en portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Interstitiel Ad — vrai 33% (Random, pas DateTime.millisecond)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adService = context.read<AdService>();
      if (_random.nextInt(3) == 0) {
        adService.showInterstitial();
      }
    });
  }

  void _shareResult(GameSession session) {
    Share.share(
      '🎮 J\'ai deviné ${session.score} mots dans CHOUF! 🇲🇦\n'
      'Catégorie : ${session.category.name}\n'
      'Tu peux faire mieux ? Télécharge le jeu !',
    );
  }

  String _getScoreLabel(int score) {
    if (score >= 8) return '🎉 Bravo !';
    if (score >= 4) return 'Pas mal !';
    return 'Tu peux mieux faire !';
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = context.read<GameManager>();
    final session = gameManager.session;

    if (session == null) {
      return const Scaffold(
        body: Center(child: Text('Erreur: Pas de session')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER SCORE ─────────────────────────────────────────────────
            _buildScoreHeader(session),

            // ── LISTE DES MOTS (scrollable, prend tout l'espace restant) ─────
            Expanded(child: _buildWordList(session)),

            // ── BOUTONS (taille fixe, en bas) ─────────────────────────────────
            _buildActionButtons(session),
          ],
        ),
      ),
    );
  }

  // ── Header score ────────────────────────────────────────────────────────────
  Widget _buildScoreHeader(GameSession session) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x40FF6B35),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
      child: Column(
        children: [
          Text(
            'SCORE',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${session.score}',
            style: GoogleFonts.poppins(
              fontSize: 80,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _getScoreLabel(session.score),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.90),
            ),
          ),
          const SizedBox(height: 8),
          // Mini stats
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _statChip('✅ ${session.score}', 'Corrects'),
              const SizedBox(width: 16),
              _statChip('❌ ${session.skipped}', 'Skippés'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.65),
            fontSize: 11,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ── Liste des mots ──────────────────────────────────────────────────────────
  Widget _buildWordList(GameSession session) {
    if (session.results.isEmpty) {
      return Center(
        child: Text(
          'Aucun mot joué',
          style: GoogleFonts.poppins(color: Colors.black38, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      physics: const BouncingScrollPhysics(),
      itemCount: session.results.length,
      itemBuilder: (context, index) {
        final result = session.results[index];
        final isCorrect = result.isCorrect;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isCorrect
                ? AppColors.successGreen.withOpacity(0.08)
                : AppColors.skipRed.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isCorrect
                  ? AppColors.successGreen.withOpacity(0.25)
                  : AppColors.skipRed.withOpacity(0.20),
            ),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Icon(
              isCorrect
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
              color: isCorrect ? AppColors.successGreen : AppColors.skipRed,
              size: 26,
            ),
            title: Text(
              result.word,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Boutons action ──────────────────────────────────────────────────────────
  Widget _buildActionButtons(GameSession session) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          // Partager
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () => _shareResult(session),
                icon: const Icon(Icons.share_rounded, size: 20),
                label: Text(
                  'Partager',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shadowColor: const Color(0x402196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Rejouer
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                icon: const Icon(Icons.replay_rounded, size: 20),
                label: Text(
                  'Rejouer',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shadowColor: AppColors.primaryTeal.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
