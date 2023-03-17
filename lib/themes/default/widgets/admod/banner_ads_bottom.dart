import 'package:flutter/material.dart';
import 'banner_ads.dart';

/// Banner Ads bottom
///
class BannerAdsBottom extends StatelessWidget {

  final Widget child;
  final int height;

  const BannerAdsBottom({Key? key, required this.child, this.height = 50}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Expanded(child: child), BannerAds(height: height)],
    );
  }
}