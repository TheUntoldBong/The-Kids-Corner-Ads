import 'dart:async';

import 'package:cirilla/constants/ads.dart';
import 'package:cirilla/service/ads_service.dart';
import 'package:cirilla/service/messaging.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin RewardedInterstitialAdsMixin<T extends StatefulWidget> on State<T> {
  AdRequest request = const AdRequest(
    keywords: keywords,
    contentUrl: contentUrl,
    nonPersonalizedAds: true,
  );

  RewardedInterstitialAd? _rewardedInterstitialAd;
  int _numRewardedInterstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    _createRewardedInterstitialAd();
  }

  void showAds() {
    Timer.periodic(const Duration(seconds: 1), _showAds);
  }

  void _showAds(Timer timer) {
    if (timer.tick > adsPeriodicTimer && _rewardedInterstitialAd != null) {
      _showRewardedInterstitialAd();
      timer.cancel();
    }
  }

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: AdService.rewardedInterstitialAdUnitId,
        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            avoidPrint('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            avoidPrint('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() async {
    if (_rewardedInterstitialAd == null) {
      avoidPrint('Warning: attempt to show rewarded interstitial before loaded.');
      return;
    }

    SharedPreferences pref = await getSharedPref();
    bool hideAds = pref.getBool('hideAds') ?? false;

    if (hideAds) {
      return;
    }

    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
              avoidPrint('$ad onAdShowedFullScreenContent.'),
          onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
            avoidPrint('$ad onAdDismissedFullScreenContent.');
            ad.dispose();
            _createRewardedInterstitialAd();
          },
          onAdFailedToShowFullScreenContent:
              (RewardedInterstitialAd ad, AdError error) {
            avoidPrint('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            _createRewardedInterstitialAd();
          },
        );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          avoidPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedInterstitialAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedInterstitialAd?.dispose();
  }
}