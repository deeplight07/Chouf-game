
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
      "Badr Hari", "Hicham El Guerrouj", "Nawal El Moutawakel", "Mohamed Rabii", "Dizzy Dros",
      "Fadwa Taleb", "Leila Hadioui", "Sanaa Akroud", "Latifa Raafat", "Houcine Slaoui",
      "Abdelhadi Belkhayat", "Nass El Ghiwane", "Jil Jilala", "Hamid Inerzaf", "Amina Rachid",
      "Fnaïre", "ElGrandeToto", "Loubna Abidar", "Dounia Boutazout", "Manal",
      "Mohamed Choubi", "Said Taghmaoui", "Lubna Azabal", "Saida Charaf", "Omar Lotfi",
      "Abdelaziz Stati", "Mehdi Nassouli", "Muslim", "Dj Van", "Soprano"
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
      "Batbout", "Harcha", "Briouats", "Ghriba", "Sellou", "Kaab el Ghazal", "Makrout",
      "Rghaif", "Trid", "Seffa Medfouna", "Kefta Mkaouara", "Matlouh",
      "Khobz Dyal Dar", "Amlou", "Smen", "Kesra", "Maakouda", "Loubia", "Khlii",
      "Sfenj", "Fekkas", "Kaak", "Mhancha", "Raib",
      "Jben", "Azemit", "Cornes de Gazelle", "Cigares aux Amandes", "Briwat",
      "Shlada", "Kemia", "Tangia", "Kseksou Bidaoui", "Chermoula"
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
      "Nador", "Settat", "Berrechid", "Khemisset", "Inezgane",
      "Ksar El Kebir", "Larache", "Guelmim", "Khenifra", "Berkane", "Taourirt",
      "Oued Zem", "El Kelaa des Sraghna", "Sidi Slimane",
      "Errachidia", "Taroudant",
      "Sefrou", "Essaouira", "Fnideq", "Tiznit", "Tan-Tan", "Ouarzazate", "Dakhla",
      "Chefchaouen", "Asilah", "Ifrane", "Merzouga", "Cap Spartel",
      "Cascades d'Ouzoud", "Gorges du Todra", "Erg Chebbi", "Volubilis", "Legzira", "Aït Benhaddou"
    ]
  },
  {
    "id": "films_series_maroc",
    "name": "🎬 Films & Séries Maroc",
    "iconPath": "assets/images/cinema.png",
    "isLocked": true,
    "words": [
      "Casanegra", "Ali Zaoua", "Les Chevaux de Dieu", "Marock", "Much Loved", "Zero", "Razzia",
      "WWW", "Burnout", "Adam", "Le Grand Voyage", "Mille Mois",
      "Death for Sale", "Goodbye Morocco", "Sofia", "The Unknown Saint",
      "Lalla Laaroussa", "Rachid Show", "Hdidane", "Nass Mlah City", "Dada Massimo",
      "Sallamt Oum El Kheir", "Al Khawa", "Omar M'Gatel",
      "Salamat Abou Lbnat", "Lhaja Lbatla", "Dar Lghezlane", "Hyati", "Bab Al Hara",
      "Moulay Abdelaziz La Porte", "L'Orchestre des Aveugles", "Le Miracle du Saint Inconnu",
      "Road to Kabul", "Hors La Loi", "Volubilis",
      "Nass El Ghiwane", "Itto", "La Chambre Noire", "Pegase", "Mimosas",
      "Aïta", "Amours Voilées", "Mektoub", "Bled Number One",
      "Fatima", "Kenza f Douar", "Lalla Fatima", "Hayat",
      "La Grande Maison", "Kif Kif"
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
      "Selim Amallah", "Ilias Chair", "Anass Zaroury", "Zakaria Aboukhlal",
      "Ayoub El Kaabi", "Soufiane Rahimi", "Raja Casablanca", "Wydad Casablanca", "FAR Rabat",
      "Renaissance Sportive de Berkane", "Maghreb de Fès", "Hassania Agadir", "Difaa El Jadida",
      "Olympique Khouribga", "FUS Rabat", "Chabab Mohammédia", "Moghreb Tétouan", "Ittihad Tanger",
      "Kawkab Marrakech", "Younes Belhanda", "Mbark Boussoufa", "Adel Taarabt",
      "Marouane Chamakh", "Noureddine Naybet", "Mustapha Hadji", "Youssef Chippo", "Badou Zaki",
      "Mohamed Timoumi", "Abderrahim Goumri", "Hicham Arazi", "Younes El Aynaoui",
      "Tariq Koulibaly", "Soufiane El Bakkali", "Abdeslam Ouaddou", "Nabil Dirar"
    ]
  },
  {
    "id": "expressions_darija",
    "name": "🗣️ Expressions Darija",
    "iconPath": "assets/images/darija.png",
    "isLocked": false,
    "words": [
      "Machi Mouchkil", "Bzaf", "Wakha", "Safi", "Mzyan", "Beslama",
      "Choukran", "Labas", "Besaha", "Barakallahoufik", "Inchallah", "Yallah",
      "Wesh", "Sma3ni", "Fhamtini", "Mazal", "Ma3lich", "Walo",
      "Khayb", "Mezyan Bzaf", "Ma3andich Mankoul",
      "Bach N7awlou", "Rah Kayn Chi Haja", "Makayn La Klam",
      "Wach Bsah", "Moul L7anout", "La La La",
      "Ma3endek Ma Ddir", "Hit Bghit", "Sir A Wlidi",
      "Kolchi Mzyan", "L7al S3ib", "3ayq",
      "Machi B7al B7al", "Ewa Safi", "Chnou Had L3iba",
      "Wallah La Normal", "3la Slama", "Kanchof W Kansket",
      "Daba Daba", "Kayen Nass", "Khask Tdir Chi Haja",
      "F Blasti", "Bezzaf 3lik", "Sma3 Lihoum",
      "Had Chi Normal", "Rass Lmal", "Khliha 3la Rebbi",
      "Ndir Ach", "Fin Mchiw Had Nnas"
    ]
  },
  {
    "id": "culture_arabe",
    "name": "🕌 Culture Arabe",
    "iconPath": "assets/images/culture.png",
    "isLocked": true,
    "words": [
      "Ramadan", "Eid Al-Fitr", "Eid Al-Adha", "Hajj", "Umrah", "Kaaba", "Mecca", "Medina",
      "Quran", "Adhan", "Salah", "Zakat", "Halal", "Haram", "Hijab",
      "Oud", "Darbuka", "Arabic Calligraphy", "Henna", "Kohl",
      "Hummus", "Falafel", "Shawarma", "Baklava", "Kunafa", "Maamoul",
      "Iftar", "Suhoor", "Taraweeh", "Laylat Al-Qadr", "Mawlid",
      "Fairuz", "Oum Kalthoum", "Abdel Halim Hafez", "Warda",
      "Amr Diab", "Nancy Ajram", "Tamer Hosny", "Mohamed Abdu", "Kadim Al Sahir",
      "Mahshi", "Mansaf", "Tabbouleh", "Dabke", "Nargilé",
      "Souq", "Hammam", "Riad", "Zellige", "Moucharabieh", "Mouqarnas"
    ]
  },
  {
    "id": "memes_maroc",
    "name": "😂 Mèmes Maroc",
    "iconPath": "assets/images/memes.png",
    "isLocked": true,
    "words": [
      "Tika Tika", "Chouftv", "Allali", "Ikram Bellanova", "Mi Naima",
      "Kebbour", "Niba", "Sari Cool", "Hlib Lkhil",
      "Ewa Safi", "Wallah La Normal", "3la Slama",
      "Bzaaaaaf", "Kolchi Mzyan Kolchi Mzyan", "L7al S3ib",
      "Machi B7al B7al", "3ayq", "Kanchof W Kansket",
      "Baye Lahcen", "Aba L3fia", "Sir A Wlidi",
      "Chnou Had L3iba", "Had Chi Normal", "Ma Fhemtch",
      "Wach Bsah", "Ana Ghir Kan3ref", "Kayen Nass Makhssin",
      "Moul L7anout", "Rass Lmal Dirha",
      "Bach N7awlou", "Rah Kayn Chi Haja", "Makayn La Klam",
      "Dima Dima", "La Normale", "Kifach Hada",
      "Sahbi Dyal Chi", "Ndir Ach B7al", "Khouya Zine",
      "Safi Barka", "Daba Fhamt", "Wach Nta Bikhir",
      "Ma3lich A Sat", "Ghir Ntuma", "Fin Ghadi B Had Soura3a",
      "Tbarkallah 3lik", "Hadi Mochkila", "Khsek Tfhem Mzyan",
      "Had Jil", "3aychine Zine", "Chouf Chouf"
    ]
  }
]
''';

  static List<CategoryModel> getCategories() {
    final List<dynamic> jsonList = json.decode(_categoriesJson);
    return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
  }
}
