import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/models.dart';

import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Zero To Unicorn'),
      bottomNavigationBar: const CustomNavBar(),
      body: Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 1.5,
              viewportFraction: 0.9,
              enlargeCenterPage: true,
              // enableInfiniteScroll: false,
              enlargeStrategy: CenterPageEnlargeStrategy.height,
              // initialPage: 2,
              // autoPlay: true,
            ),
            items: Category.categories
                .map((category) => HeroCarouselCard(
                    item: ItemCarousel(
                        name: category.name,
                        imageUrl: category.imageUrl,
                        routeName: '/catalog')))
                .toList(),
          ),
          const SectionTitle(title: 'RECOMMENDED'),
          ProductCarousel(
            products: Product.products
                .where((product) => product.isRecommended)
                .toList(),
          ),
          const SectionTitle(title: 'MOST POPULAR'),
          ProductCarousel(
            products:
                Product.products.where((product) => product.isPopular).toList(),
          ),
        ],
      ),
    );
  }
}
