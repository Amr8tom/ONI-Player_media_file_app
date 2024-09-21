class RConfigModel {
  final bool adsEnabled;

  String fInterstitialAdId;

  String fNativeBannerAdId;
  // final String oneSignalAppId;

  RConfigModel({
    required this.adsEnabled,
    required this.fInterstitialAdId,
    required this.fNativeBannerAdId,
    // required this.oneSignalAppId,
  });

  factory RConfigModel.fromJson(Map<String, dynamic> json) {
    return RConfigModel(
      adsEnabled: json['ads']['enabled'],
      fInterstitialAdId: json['ads']['finterstitialAdId'],
      fNativeBannerAdId: json['ads']['fnativeBannerAdId'],
      // oneSignalAppId: json['oneSignal']['appId'],
    );
  }

  // empty constructor
  factory RConfigModel.empty() {
    return RConfigModel(
      adsEnabled: false,
      fInterstitialAdId: '',
      fNativeBannerAdId: '',
      // oneSignalAppId: '',
    );
  }
}
