
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../services/game_manager.dart';
import '../services/storage_service.dart';
import '../services/ad_service.dart';
import '../utils/data_source.dart';
import '../utils/app_colors.dart';
import '../widgets/category_card.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];
  
  @override
  void initState() {
    super.initState();
    categories = DataSource.getCategories();
  }

  void _onCategoryTap(CategoryModel category) {
    // Check lock status
    final storage = context.read<StorageService>();
    final adService = context.read<AdService>();
    final gameManager = context.read<GameManager>();

    bool isUnlocked = !category.isLocked || storage.isCategoryUnlocked(category.id);

    if (isUnlocked) {
      gameManager.prepareGame(category);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GameScreen()),
      );
    } else {
      // Show Rewarded Ad Dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Catégorie Verrouillée'),
          content: Text('Regardez une publicité pour débloquer "${category.name}" ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                adService.showRewarded(
                  onUserEarnedReward: () async {
                    await storage.unlockCategory(category.id);
                    setState(() {}); // Refresh UI
                    // Optionally auto-start game
                  },
                );
              },
              child: const Text('Regarder'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>(); // Watch for unlock changes

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chouf Game 🇲🇦'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             const Text(
              'Choisis une catégorie :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isUnlocked = !cat.isLocked || storage.isCategoryUnlocked(cat.id);
                  return CategoryCard(
                    category: cat,
                    isUnlocked: isUnlocked,
                    onTap: () => _onCategoryTap(cat),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
