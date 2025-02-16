// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'dart:io';
//
// import '../service/AdManager.dart';
//
// class MediumNativeAd extends StatefulWidget {
//   const MediumNativeAd({super.key});
//
//   @override
//   State<MediumNativeAd> createState() => _MediumNativeAdState();
// }
//
// class _MediumNativeAdState extends State<MediumNativeAd> {
//   NativeAd? _nativeAd;
//   bool _isAdLoaded = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAd();
//   }
//
//   void _loadAd() {
//     _nativeAd = NativeAd(
//       adUnitId: AdHelper.adUnitId,
//       request: const AdRequest(),
//       listener: NativeAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _isAdLoaded = true;
//           });
//         },
//         onAdFailedToLoad: (ad, error) {
//           ad.dispose();
//           print('Native Ad failed to load: $error');
//         },
//         onAdClicked: (ad) {},
//         onAdImpression: (ad) {},
//         onAdClosed: (ad) {},
//         onAdOpened: (ad) {},
//         onAdWillDismissScreen: (ad) {},
//       ),
//       nativeTemplateStyle: NativeTemplateStyle(
//         templateType: TemplateType.medium, // Medium size template
//         cornerRadius: 10.0, // Rounded corners
//         callToActionTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.white,
//           backgroundColor: Colors.blue,
//           style: NativeTemplateFontStyle.monospace,
//           size: 16.0,
//         ),
//         primaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.black,
//           backgroundColor: Colors.transparent,
//           style: NativeTemplateFontStyle.normal,
//           size: 18.0,
//         ),
//         secondaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.grey,
//           backgroundColor: Colors.transparent,
//           style: NativeTemplateFontStyle.italic,
//           size: 14.0,
//         ),
//         tertiaryTextStyle: NativeTemplateTextStyle(
//           textColor: Colors.grey,
//           backgroundColor: Colors.transparent,
//           style: NativeTemplateFontStyle.normal,
//           size: 12.0,
//         ),
//       ),
//     )..load();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _isAdLoaded && _nativeAd != null
//         ? Container(
//             height: 300, // Medium size height
//             margin: const EdgeInsets.symmetric(vertical: 10),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Colors.grey[200],
//             ),
//             child: AdWidget(ad: _nativeAd!),
//           )
//         : const SizedBox.shrink(); // Hide if ad is not loaded
//   }
//
//   @override
//   void dispose() {
//     _nativeAd?.dispose();
//     super.dispose();
//   }
// }
