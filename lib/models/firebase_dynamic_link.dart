import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/models.dart';
import 'package:flutter_ecommerce_app/screens/screens.dart';

final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
final FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

class FirebaseDynamicLink {
  static Future<String> createDynamicLink(bool short, Product product) async {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://example.com/product?id=${product.id}"),
      uriPrefix: "https://zerotounicorn.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.example.flutter_ecommerce_app",
        minimumVersion: 30,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.example.app.ios",
        appStoreId: "123456789",
        minimumVersion: "1.0.1",
      ),
      // googleAnalyticsParameters: const GoogleAnalyticsParameters(
      //   source: "twitter",
      //   medium: "social",
      //   campaign: "example-promo",
      // ),
      // socialMetaTagParameters: SocialMetaTagParameters(
      //   title: "Example of a Dynamic Link",
      //   imageUrl: Uri.parse("https://example.com/image.png"),
      // ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(dynamicLinkParams);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(dynamicLinkParams);
    }

    return url.toString();
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      final Uri deepLink = dynamicLinkData.link;

      bool isProduct = deepLink.pathSegments.contains('product');
      if (isProduct) {
        String? id = deepLink.queryParameters['id'];

        try {
          await _firebaseFirestore
              .collection("products")
              .doc(id)
              .get()
              .then((snapshot) {
            Product product = Product.fromSnapshot(snapshot);

            return Navigator.pushNamed(
              context,
              ProductScreen.routeName,
              arguments: product,
            );
          });
        } catch (e) {
          print(e);
        }
      } else {
        return;
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      bool isProduct = deepLink.pathSegments.contains('product');
      if (isProduct) {
        String? id = deepLink.queryParameters['id'];

        try {
          await _firebaseFirestore
              .collection("products")
              .doc(id)
              .get()
              .then((snapshot) {
            Product product = Product.fromSnapshot(snapshot);

            return Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductScreen(
                          product: product,
                        )));
          });
        } catch (e) {
          print(e);
        }
      } else {
        return;
      }
    }
  }
}
