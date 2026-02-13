
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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

  @override
  void initState() {
    super.initState();
    // Show Interstitial Ad (33% chance)
    // Actually user said 33% chance.
    // Random check?
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adService = context.read<AdService>();
      if (DateTime.now().millisecond % 3 == 0) { // Simple randomizer
         adService.showInterstitial();
      }
    });
  }

  void _shareResult(int score) {
    Share.share('J\'ai deviné $score mots dans Chouf Game ! 🇲🇦 Télécharge le jeu !');
  }

  @override
  Widget build(BuildContext context) {
    final gameManager = context.read<GameManager>();
    final session = gameManager.session;

    if (session == null) {
      return const Scaffold(body: Center(child: Text('Erreur: Pas de session')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // Score Header
          Container(
            padding: const EdgeInsets.all(32),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                const Text(
                  'SCORE',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                Text(
                  '${session.score}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: session.results.length,
              itemBuilder: (context, index) {
                final result = session.results[index];
                return ListTile(
                  leading: result.isCorrect 
                    ? const Icon(Icons.check_circle, color: AppColors.successGreen)
                    : const Icon(Icons.cancel, color: AppColors.skipRed),
                  title: Text(
                    result.word,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _shareResult(session.score),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Partager'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                     onPressed: () {
                       // Go back to Home
                       Navigator.popUntil(context, (route) => route.isFirst);
                     },
                     child: const Text('Rejouer'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
