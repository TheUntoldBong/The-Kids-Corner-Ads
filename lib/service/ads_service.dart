import 'dart:async';
import 'dart:io';

import 'package:cirilla/constants/ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  Future<InitializationStatus> initialization;

  AdService(this.initialization);

  static String get bannerAdUnitId => Platform.isAndroid ? bannerAdUnitIdAndroid : bannerAdUnitIdiOS;

  static String get interstitialAdUnitId => Platform.isAndroid ? interstitialAdUnitIdAndroid : interstitialAdUnitIdiOS;

  static String get rewardedAdUnitId => Platform.isAndroid ? rewardedAdUnitIdAndroid : rewardedAdUnitIdiOS;

  static String get rewardedInterstitialAdUnitId =>
      Platform.isAndroid ? rewardedInterstitialAdUnitIdAndroid : rewardedInterstitialAdUnitIdiOS;
}
