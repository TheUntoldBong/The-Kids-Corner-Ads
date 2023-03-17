import 'package:cirilla/mixins/mixins.dart';
import 'package:cirilla/store/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RewardAds extends StatefulWidget {

  final Widget child;
  final bool show;

  const RewardAds({Key? key, required this.child, this.show = false}) : super(key: key);

  @override
  State<RewardAds> createState() => _RewardAdsState();
}

class _RewardAdsState extends State<RewardAds> with ShowRewardedAdsMixin {

  bool _showAds = false;

  void show() {
    showAds((ad, reward) {
      if (reward.amount > 0) {
        setState(() {
          _showAds = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    AuthStore authStore = Provider.of<AuthStore>(context);
    bool hideAds = authStore.user?.options?.hideAds ?? false;
    setState(() {
      _showAds = !hideAds;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showAds && widget.show) _showMessage(),
      ],
    );
  }

  Widget _showMessage() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('What video to hide Ads'),
          TextButton(onPressed: show, child: const Text('Show Ads'))
        ],
      ),
    );
  }
}
