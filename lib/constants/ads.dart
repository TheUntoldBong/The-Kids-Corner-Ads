///
/// Words or phrases describing the current user activity.
///
const List<String> keywords = ['foo', 'bar'];

/// URL string for a webpage whose content matches the app’s primary content.
///
/// This webpage content is used for targeting and brand safety purposes.
///
const String contentUrl = 'http://foo.com/bar.html';

///
/// Max Failed Load Attempts Ads
///
const int maxFailedLoadAttempts = 3;

///
/// The time Interstitial Ads showing
///
const int adsPeriodicTimer = 1;

///
/// Banner ads unit ID
///
const String bannerAdUnitIdAndroid = 'ca-app-pub-3940256099942544/6300978111';
const String bannerAdUnitIdiOS = 'ca-app-pub-3940256099942544/2934735716';

///
/// Interstitial ads unit ID
///
const String interstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/1033173712';
const String interstitialAdUnitIdiOS = 'ca-app-pub-3940256099942544/4411468910';

///
/// Rewarded Ads unit ID
///
const String rewardedAdUnitIdAndroid = 'ca-app-pub-3940256099942544/5224354917';
const String rewardedAdUnitIdiOS = 'ca-app-pub-3940256099942544/1712485313';

///
/// Rewarded Interstitial Ads unit ID
///
const String rewardedInterstitialAdUnitIdAndroid = 'ca-app-pub-3940256099942544/5354046379';
const String rewardedInterstitialAdUnitIdiOS = 'ca-app-pub-3940256099942544/6978759866';

/// This configs for hide/show Ads banner in bottom screen, or above bottom app bar
///
/// You can add this code to any Scaffold widget to show banner
///
/// ```dart
///   persistentFooterButtons: persistentFooterButtons(Provider.of<AuthStore>(context)),
/// ```
///
const Map<String, bool> bannerAdsOptions = {
  'home': true,
  'post_list': true,
  'post_category': true,
  'post_author': true,
  'post': true,
};

/// This configs for hide/show Ads banner in bottom screen, or above bottom app bar
///
/// You can add InterstitialAdsMixin mixin to any screen then call function showAds();
///
const Map<String, bool> interstitialAdsOptions = {
  'home': true,
};

/// This options for hide/show Reward ads feature
///
const Map<String, bool> rewardAdsOptions = {
  'post': true,
};