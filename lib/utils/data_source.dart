
import 'dart:convert';
import '../models/category_model.dart';

class DataSource {
  static const String _categoriesJson = '''
[
  {
    "id": "celebrities_maroc",
    "name": "🇲🇦 Célébrités Marocaines",
    "iconPath": "assets/images/celebrities.png",
    "isLocked": false,
    "words": ["Ahmed Soultan", "Saad Lamjarred", "Gad Elmaleh", "RedOne", "Dunia Batma", "Hassan El Fad", "Jamel Debbouze", "Asmaa Lamnawar", "Hatim Ammor", "Zina Daoudia"]
  },
  {
    "id": "cuisine_maroc",
    "name": "🥘 Cuisine Marocaine",
    "iconPath": "assets/images/cuisine.png",
    "isLocked": false,
    "words": ["Couscous", "Tajine", "Harira", "Pastilla", "Rfissa", "Chebakia", "Baghrir", "Msemen", "Saffa", "Tanjia"]
  },
  {
    "id": "villes_maroc",
    "name": "🏙️ Villes du Maroc",
    "iconPath": "assets/images/cities.png",
    "isLocked": false,
    "words": ["Casablanca", "Rabat", "Marrakech", "Fès", "Tanger", "Agadir", "Meknès", "Oujda", "Tetouan", "Essaouira"]
  },
  {
    "id": "films_series_maroc",
    "name": "🎬 Films & Séries Maroc",
    "iconPath": "assets/images/cinema.png",
    "isLocked": true,
    "words": ["Lalla Laaroussa", "Rachid Show", "Ali Zaoua", "Casanegra", "Horses of God", "Much Loved", "Zéro", "Road to Kabul", "Marock", "Razzia"]
  },
  {
    "id": "sport_marocain",
    "name": "⚽ Sport Marocain",
    "iconPath": "assets/images/sport.png",
    "isLocked": false,
    "words": ["Badr Hari", "Hicham El Guerrouj", "Nawal El Moutawakel", "Walid Regragui", "Achraf Hakimi", "Yassine Bounou", "Hakim Ziyech", "Raja Casablanca", "Wydad Casablanca", "Atlas Lions"]
  },
  {
    "id": "expressions_darija",
    "name": "🗣️ Expressions Darija",
    "iconPath": "assets/images/darija.png",
    "isLocked": false,
    "words": ["Machi Mouchkil", "Bzaf", "Wakha", "Safi", "Chno", "Fin", "Kifach", "Mzyan", "Beslama", "Choukran"]
  },
  {
    "id": "culture_arabe",
    "name": "🕌 Culture Arabe",
    "iconPath": "assets/images/culture.png",
    "isLocked": true,
    "words": ["Ramadan", "Eid", "Kaaba", "Quran", "Mecca", "Medina", "Arabic Calligraphy", "Oud", "Mint Tea", "Henna"]
  },
  {
    "id": "memes_maroc",
    "name": "😂 Mèmes Maroc",
    "iconPath": "assets/images/memes.png",
    "isLocked": true,
    "words": ["Tika Tika", "Sari Cool", "Niba", "Ikram Bellanova", "Mi Naima", "Hlib Lkhil", "Lcoupl", "Kebbour", "Chouftv", "Allali"]
  }
]
''';

  static List<CategoryModel> getCategories() {
    final List<dynamic> jsonList = json.decode(_categoriesJson);
    return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
