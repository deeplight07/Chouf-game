
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
    "words": [
      "Saad Lamjarred", "Gad Elmaleh", "Jamel Debbouze", "Ahmed Soultan", "RedOne",
      "Dunia Batma", "Hassan El Fad", "Asmaa Lamnawar", "Hatim Ammor", "Zina Daoudia",
      "Samira Said", "Nouamane Lahlou", "Abdelfattah Grini", "Nabila Maan", "Sophia Aram",
      "Younès Belhanda", "Achraf Hakimi", "Hakim Ziyech", "Yassine Bounou", "Abderrazak Hamdallah",
      "Badr Hari", "Hicham El Guerrouj", "Nawal El Moutawakel", "Mohamed Rabii", "Safaa Fathy",
      "Fadwa Taleb", "Leila Hadioui", "Sanaa Akroud", "Latifa Raafat", "Houcine Slaoui",
      "Abdelhadi Belkhayat", "Nass El Ghiwane", "Jil Jilala", "Hamid Inerzaf", "Amina Rachid",
      "Fadila Benmoussa", "Rachida Brakni", "Loubna Abidar", "Dounia Boutazout", "Ayoub El Khazzani",
      "Mohamed Choubi", "Said Taghmaoui", "Lubna Azabal", "Hicham Bahloul", "Omar Lotfi",
      "Hassan Hajjaj", "Lalla Essaydi", "Majida El Roumi", "Abdelaziz Stati", "Mehdi Nassouli"
    ]
  },
  {
    "id": "cuisine_maroc",
    "name": "🥘 Cuisine Marocaine",
    "iconPath": "assets/images/cuisine.png",
    "isLocked": false,
    "words": [
      "Couscous", "Tajine", "Harira", "Pastilla", "Rfissa", "Chebakia", "Baghrir", "Msemen",
      "Saffa", "Tanjia", "Zaalouk", "Taktouka", "Bissara", "Mechoui", "Mrouzia", "Khobz",
      "Batbout", "Harcha", "Briouats", "Ghriba", "Sellou", "Kaab el Ghazal", "Makrout", "Shebbakia",
      "Beghrir", "Rghaif", "Trid", "Seffa Medfouna", "Kefta Mkaouara", "Zaalouk", "Matlouh",
      "Khobz Dyal Dar", "Amlou", "Smen", "Kesra", "Maakouda", "Loubia", "Bessara", "Khlii",
      "Gueddid", "Khliaa", "Sfenj", "Ghoriba", "Fekkas", "Kaak", "Shebakia", "Briouat aux Amandes",
      "Cornes de Gazelle", "Cigares aux Amandes"
    ]
  },
  {
    "id": "villes_maroc",
    "name": "🏙️ Villes du Maroc",
    "iconPath": "assets/images/cities.png",
    "isLocked": false,
    "words": [
      "Casablanca", "Rabat", "Marrakech", "Fès", "Tanger", "Agadir", "Meknès", "Oujda",
      "Kenitra", "Tetouan", "Safi", "Temara", "Mohammedia", "Khouribga", "El Jadida", "Beni Mellal",
      "Aït Melloul", "Nador", "Dar Bouazza", "Settat", "Berrechid", "Khemisset", "Inezgane",
      "Ksar El Kebir", "Larache", "Guelmim", "Khenifra", "Berkane", "Taourirt", "Bouskoura",
      "Fquih Ben Salah", "Dcheira El Jihadia", "Oued Zem", "El Kelaa des Sraghna", "Sidi Slimane",
      "Errachidia", "Guercif", "Oulad Teima", "Ben Guerir", "Tifelt", "Lqliaa", "Taroudant",
      "Sefrou", "Essaouira", "Fnideq", "Sidi Kacem", "Tiznit", "Tan-Tan", "Ouarzazate", "Dakhla"
    ]
  },
  {
    "id": "films_series_maroc",
    "name": "🎬 Films & Séries Maroc",
    "iconPath": "assets/images/cinema.png",
    "isLocked": true,
    "words": [
      "Lalla Laaroussa", "Rachid Show", "Hdidane", "Nass Mlah City", "Lkhayna", "Dada Massimo",
      "Sallamt Oum El Kheir", "Al Khawa", "Mawtini", "Nass El Ghiwane", "Omar M'Gatel",
      "Casanegra", "Ali Zaoua", "Les Chevaux de Dieu", "Marock", "Much Loved", "Zero", "Razzia",
      "Road to Kabul", "WWW", "Burnout", "Adam", "Hors La Loi", "Une Minute de Soleil en Moins",
      "Le Grand Voyage", "L'Orchestre des Aveugles", "Wherever They May Be", "Mille Mois",
      "La Petite Vendeuse de Soleil", "Les Yeux Secs", "L'Enfant Endormi", "Le Miracle du Saint Inconnu",
      "Zainab Takdahal Al Madina", "Le Cheval de Vent", "L'Armée du Salut", "La Plage des Enfants Perdus",
      "Le Fils de l'Epicier", "Death for Sale", "L'Autre", "Goodbye Morocco", "Volubilis",
      "Pegase", "Aïta", "Amours Voilées", "Mimosas", "Sofia", "The Unknown Saint", "Mektoub",
      "L'Orchestre Rouge", "Bled Number One"
    ]
  },
  {
    "id": "sport_marocain",
    "name": "⚽ Sport Marocain",
    "iconPath": "assets/images/sport.png",
    "isLocked": false,
    "words": [
      "Badr Hari", "Hicham El Guerrouj", "Nawal El Moutawakel", "Walid Regragui", "Achraf Hakimi",
      "Yassine Bounou", "Hakim Ziyech", "Sofyan Amrabat", "Noussair Mazraoui", "Romain Saïss",
      "Youssef En-Nesyri", "Abdelhamid Sabiri", "Azzedine Ounahi", "Jawad El Yamiq", "Yahia Attiyat Allah",
      "Selim Amallah", "Ilias Chair", "Adam Masina", "Anass Zaroury", "Zakaria Aboukhlal",
      "Ayoub El Kaabi", "Soufiane Rahimi", "Raja Casablanca", "Wydad Casablanca", "FAR Rabat",
      "Renaissance Sportive de Berkane", "Maghreb de Fès", "Hassania Agadir", "Difaa El Jadida",
      "Olympique Khouribga", "FUS Rabat", "Chabab Mohammédia", "Moghreb Tétouan", "Ittihad Tanger",
      "Kawkab Marrakech", "Union Touarga", "Younes Belhanda", "Mbark Boussoufa", "Adel Taarabt",
      "Marouane Chamakh", "Noureddine Naybet", "Mustapha Hadji", "Youssef Chippo", "Badou Zaki",
      "Mohamed Timoumi", "Abderrahim Goumri", "Hicham Arazi", "Younes El Aynaoui", "Jalal El Hamdaoui"
    ]
  },
  {
    "id": "expressions_darija",
    "name": "🗣️ Expressions Darija",
    "iconPath": "assets/images/darija.png",
    "isLocked": false,
    "words": [
      "Machi Mouchkil", "Bzaf", "Wakha", "Safi", "Chno", "Fin", "Kifach", "Mzyan", "Beslama",
      "Choukran", "Labas", "Besaha", "Barakallahoufik", "Inchallah", "Alhamdulillah", "Yallah",
      "Wesh", "Ach Galt", "Sma3ni", "Fhamtini", "Gha Nzidou", "Mazal", "Daba", "Ghir", "Bghit",
      "Ma3lich", "Mamnou3", "Darouri", "Walo", "Baraka", "Khayb", "Zine", "Mezyan Bzaf",
      "Ma3andich Mankoul", "Aji", "Sir", "Rja3", "Khoud", "3ti", "Goul", "Chouf", "Sma3",
      "Kteb", "Qra", "Kol", "Shrab", "N3as", "Fiq", "Gles", "Wqef", "Mchi", "Zid"
    ]
  },
  {
    "id": "culture_arabe",
    "name": "🕌 Culture Arabe",
    "iconPath": "assets/images/culture.png",
    "isLocked": true,
    "words": [
      "Ramadan", "Eid Al-Fitr", "Eid Al-Adha", "Hajj", "Umrah", "Kaaba", "Mecca", "Medina",
      "Quran", "Hadith", "Sunnah", "Mosque", "Minaret", "Mihrab", "Adhan", "Salah", "Wudu",
      "Zakat", "Sadaqah", "Halal", "Haram", "Hijab", "Niqab", "Abaya", "Thobe", "Kufi",
      "Oud", "Qanun", "Darbuka", "Ney", "Rebab", "Arabic Calligraphy", "Henna", "Kohl",
      "Mint Tea", "Dates", "Hummus", "Falafel", "Shawarma", "Baklava", "Kunafa", "Maamoul",
      "Iftara", "Suhoor", "Taraweeh", "Laylat Al-Qadr", "Ashura", "Mawlid", "Isra and Miraj"
    ]
  },
  {
    "id": "memes_maroc",
    "name": "😂 Mèmes Maroc",
    "iconPath": "assets/images/memes.png",
    "isLocked": true,
    "words": [
      "Tika Tika", "Sari Cool", "Niba", "Ikram Bellanova", "Mi Naima", "Hlib Lkhil", "Lcoupl",
      "Kebbour", "Chouftv", "Allali", "Aji T3allem", "Khay Khay", "Matqis Lihoum", "Ana Hna",
      "Siri Hna", "Fin Ghadi", "Chkoun Baghi", "Rah Mcha", "Ghalat", "Ma3arf", "Chhal",
      "Bezaf Lik", "Sir T9wed", "Khsek Tfhem", "Wach Nta", "Kifach Had Chi", "Fin Kayn",
      "Aji Chouf", "Ma3lich Sahbi", "Kolchi Bikhir", "Hadi Mochkila", "Wakha Haka", "Sir La7bal",
      "Jib Lihoum", "Rah 7sen", "Ma3endek Mandir", "Khliha 3la Rebbi", "Baraka Men Had Chi",
      "Ghir Nta", "Chkoun Gal Lik", "Mamzyanch", "Khouya Zine", "Safi Barka", "Daba Fhamt",
      "Aji Hna", "Sir Temma", "Wach Bsah", "Kolchi Mzyan", "Ma3lich A Sat"
    ]
  }
]
''';

  static List<CategoryModel> getCategories() {
    final List<dynamic> jsonList = json.decode(_categoriesJson);
    return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
