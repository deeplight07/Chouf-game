
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late SharedPreferences _prefs;
  static const String _unlockedCategoriesKey = 'unlocked_categories';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool isCategoryUnlocked(String categoryId) {
    // Default categories are handled by 'isLocked' flag in model, 
    // but if user unlocked it via rewarded ad, we store it here.
    final unlockedList = _prefs.getStringList(_unlockedCategoriesKey) ?? [];
    return unlockedList.contains(categoryId);
  }

  Future<void> unlockCategory(String categoryId) async {
    final unlockedList = _prefs.getStringList(_unlockedCategoriesKey) ?? [];
    if (!unlockedList.contains(categoryId)) {
      unlockedList.add(categoryId);
      await _prefs.setStringList(_unlockedCategoriesKey, unlockedList);
    }
  }

  // Debug: Reset unlocks
  Future<void> clearUnlocks() async {
    await _prefs.remove(_unlockedCategoriesKey);
  }
}
