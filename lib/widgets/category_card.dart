
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../utils/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onTap;
  final bool isUnlocked;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.isUnlocked = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: Card(
        color: isUnlocked ? Colors.white : Colors.grey[200],
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon (using emoji or asset, currently logic supports image mostly)
                // If iconPath starts with 'assets', use Image.asset, else Text
                if (category.iconPath.startsWith('assets'))
                   Expanded(
                     child: Padding(
                       padding: const EdgeInsets.all(16.0),
                       child: Image.asset(category.iconPath, errorBuilder: (c,e,s) => const Icon(Icons.category, size: 48, color: AppColors.primaryOrange)),
                     ),
                   )
                else
                  Text(category.iconPath, style: const TextStyle(fontSize: 48)),
                  
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
            if (!isUnlocked)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock, color: Colors.white, size: 32),
                      const SizedBox(height: 8),
                      // "Watch Ad to Unlock" logic would be in onTap wrapper or button
                      ElevatedButton(
                        onPressed: onTap, // onTap here triggers the unlock flow
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: const TextStyle(fontSize: 12),
                        ),
                        child: const Text('Débloquer'),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
