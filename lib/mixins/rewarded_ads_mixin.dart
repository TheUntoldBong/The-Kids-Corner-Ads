import 'dart:async';

import 'package:cirilla/constants/ads.dart';
import 'package:cirilla/service/ads_service.dart';
import 'package:cirilla/service/service.dart';
import 'package:cirilla/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin RewardedAdsMixin<T extends StatefulWidget> on State<T> {
  AdRequest request = const AdRequest(
    keywords: keywords,
    contentUrl: contentUrl,
    nonPersonalizedAds: true,
  );

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    _createRewardedAd();
  }

  void showAds() {
    Timer.periodic(const Duration(seconds: 1), _showAds);
  }

  void _showAds(Timer timer) {
    if (timer.tick > adsPeriodicTimer && _rewardedAd != null) {
      _showRewardedAd();
      timer.cancel();
    }
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdService.rewardedAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            avoidPrint('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            avoidPrint('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() async {
    if (_rewardedAd == null) {
      avoidPrint('Warning: attempt to show rewarded before loaded.');
      return;
    }

    SharedPreferences pref = await getSharedPref();
    bool hideAds = pref.getBool('hideAds') ?? false;

    if (hideAds) {
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => avoidPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        avoidPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        avoidPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      avoidPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedAd?.dispose();
  }
}

mixin ShowRewardedAdsMixin<T extends StatefulWidget> on State<T> {
  AdRequest request = const AdRequest(
    keywords: keywords,
    contentUrl: contentUrl,
    nonPersonalizedAds: true,
  );

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    _createRewardedAd();
  }

  void showAds(OnUserEarnedRewardCallback onUserEarnedRewardCallback) {
    _showRewardedAd(onUserEarnedRewardCallback);
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdService.rewardedAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            avoidPrint('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            avoidPrint('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd(OnUserEarnedRewardCallback onUserEarnedRewardCallback) async {
    if (_rewardedAd == null) {
      avoidPrint('Warning: attempt to show rewarded before loaded.');
      return;
    }

    SharedPreferences pref = await getSharedPref();
    bool hideAds = pref.getBool('hideAds') ?? false;

    if (hideAds) {
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => avoidPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        avoidPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        avoidPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      avoidPrint('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      onUserEarnedRewardCallback(ad, reward);
    });
    _rewardedAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    _rewardedAd?.dispose();
  }
}