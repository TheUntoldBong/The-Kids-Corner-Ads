import 'dart:async';

import 'package:cirilla/constants/ads.dart';
import 'package:cirilla/service/ads_service.dart';
import 'package:cirilla/service/messaging.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin InterstitialAdsMixin<T extends StatefulWidget> on State<T> {

  AdRequest request = const AdRequest(
    keywords: keywords,
    contentUrl: contentUrl,
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  void showAds() {
    Timer.periodic(const Duration(seconds: adsPeriodicTimer), _showAds);
  }

  void _showAds(Timer timer) {
    if (timer.tick > adsPeriodicTimer && _interstitialAd != null) {
      _showInterstitialAd();
      timer.cancel();
    }
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdService.interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            avoidPrint('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            avoidPrint('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() async {
    if (_interstitialAd == null) {
      avoidPrint('Warning: attempt to show interstitial before loaded.');
      return;
    }

    SharedPreferences pref = await getSharedPref();
    bool hideAds = pref.getBool('hideAds') ?? false;

    if (hideAds) {
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => avoidPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        avoidPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        avoidPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }
}