import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/models.dart';
import 'package:flutter_ecommerce_app/widgets/widgets.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const SplashScreen());
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushNamed(context, '/'),
    );

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            width: 125,
            height: 125,
          ),
        ),
        const SizedBox(height: 30),
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Text(
            'Zero To Unicorn',
            style: Theme.of(context).textTheme.headline2!.copyWith(
                  color: Colors.white,
                ),
          ),
        )
      ],
    ));
  }
}
