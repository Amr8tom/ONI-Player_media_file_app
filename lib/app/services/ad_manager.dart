import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oniplayer/app/config/app_theme.dart';

class AdManager extends GetxService {
  static AdManager get to => Get.find();
  bool _interstitialAdLoaded = false;
  bool inited = false;
  String _interstitialAdId = "";
  String _nativeBannerAdId = "";
  bool isInvalidated = false;

  Future<AdManager> init(
      String interstitialAdId, String nativeBannerAdId) async {
    // printGreen("AdManager init");
    _interstitialAdId = interstitialAdId;
    _nativeBannerAdId = nativeBannerAdId;
    await FacebookAudienceNetwork.init();
    _loadFacebookInterstitialAd();
    inited = true;
    return this;
  }

  Widget getNativeBannerAd() {
    if (!inited && !isInvalidated) return Container();
    return FacebookNativeAd(
      placementId: _nativeBannerAdId,
      adType: NativeAdType.NATIVE_BANNER_AD,
      bannerAdSize: NativeBannerAdSize.HEIGHT_100,
      width: double.infinity,
      height: 100,
      backgroundColor: AppTheme.backgroundColor,
      titleColor: AppTheme.textColorLight,
      descriptionColor: AppTheme.textColorLight,
      buttonColor: AppTheme.primaryColor,
      buttonTitleColor: AppTheme.textColorLight,
      buttonBorderColor: AppTheme.primaryColor,
      keepAlive: true,
    );
  }

  void _loadFacebookInterstitialAd() {
    // printGreen("[AD] LOAD AD");
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: _interstitialAdId,
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          _interstitialAdLoaded = true;
          isInvalidated = false;
          // printRed("[AD] LOADED");
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          isInvalidated = true;
          _interstitialAdLoaded = false;
          _loadFacebookInterstitialAd();
        }
      },
    );
  }

  Future<void> showFacebookInterstitialAd() async {
    if (!inited) return;
    if (_interstitialAdLoaded) {
      await FacebookInterstitialAd.showInterstitialAd();
      _loadFacebookInterstitialAd();
      _interstitialAdLoaded = false;
    }
  }
}
