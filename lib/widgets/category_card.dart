
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
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Background Image
              if (category.iconPath.startsWith('assets'))
                Image.asset(
                  category.iconPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (c, e, s) => Container(
                    color: AppColors.primaryOrange.withOpacity(0.2),
                    child: const Center(
                      child: Icon(Icons.category, size: 48, color: AppColors.primaryOrange),
                    ),
                  ),
                )
              else
                Container(
                  color: AppColors.primaryTeal.withOpacity(0.2),
                  child: Center(
                    child: Text(category.iconPath, style: const TextStyle(fontSize: 48)),
                  ),
                ),

              // Gradient Overlay for readability
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black54, // Darker at bottom
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),

              // Category Name
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),

              // Locked Overlay (if locked)
              if (!isUnlocked) ...[
                // Darken the whole card more
                Container(
                  color: Colors.black.withOpacity(0.4),
                ),
                // Lock Icon and Label
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'BLOQUÉ', 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
