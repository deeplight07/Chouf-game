
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logging/logging.dart';

class AdService {
  final Logger _log = Logger('AdService');
  
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  
  // Test IDs provided by user
  final String _interstitialAdUnitId = Platform.isAndroid 
      ? 'ca-app-pub-3940256099942544/1033173712' 
      : 'ca-app-pub-3940256099942544/4411468910'; // generic iOS test ID just in case
      
  final String _rewardedAdUnitId = Platform.isAndroid 
      ? 'ca-app-pub-3940256099942544/5224354917' 
      : 'ca-app-pub-3940256099942544/1712485313'; // generic iOS test ID

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _loadInterstitial();
    _loadRewarded();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _log.info('Interstitial Ad loaded');
        },
        onAdFailedToLoad: (error) {
          _log.warning('Interstitial Ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }
  
  void showInterstitial({Function? onClosed}) {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadInterstitial(); // Preload next one
          if (onClosed != null) onClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadInterstitial();
          if (onClosed != null) onClosed();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      _loadInterstitial();
      if (onClosed != null) onClosed();
    }
  }

  void _loadRewarded() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _log.info('Rewarded Ad loaded');
        },
        onAdFailedToLoad: (error) {
          _log.warning('Rewarded Ad failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewarded({required Function onUserEarnedReward, Function? onClosed}) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadRewarded();
          if (onClosed != null) onClosed();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadRewarded();
          if (onClosed != null) onClosed();
        },
      );
      
      _rewardedAd!.show(
        onUserEarnedReward: (adWithoutView, reward) {
          onUserEarnedReward();
        },
      );
      _rewardedAd = null;
    } else {
      _log.warning('Rewarded Ad not ready');
      _loadRewarded(); // Retry load
      // Optionally notify user ad is not ready
    }
  }
}
