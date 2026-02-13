
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'services/ad_service.dart';
import 'services/audio_service.dart';
import 'services/game_manager.dart';
import 'services/sensor_service.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  final adService = AdService();
  final audioService = AudioService();
  final sensorService = SensorService();
  final storageService = StorageService();

  await adService.initialize();
  await storageService.initialize();
  
  // Set preferred orientations for the app (Portrait by default)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<AdService>.value(value: adService),
        Provider<AudioService>.value(value: audioService),
        Provider<SensorService>.value(value: sensorService),
        Provider<StorageService>.value(value: storageService),
        ChangeNotifierProvider(
          create: (_) => GameManager(sensorService, audioService),
        ),
      ],
      child: const ChoufGameApp(),
    ),
  );
}

class ChoufGameApp extends StatelessWidget {
  const ChoufGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chouf Game',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
