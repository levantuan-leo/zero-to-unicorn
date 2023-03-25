import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_app/models/models.dart';

import '../../widgets/widgets.dart';

class WishlistScreen extends StatelessWidget {
  static const String routeName = '/wishlist';

  const WishlistScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const WishlistScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Wishlist'),
      bottomNavigationBar: const CustomNavBar(),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: 2.2),
          itemCount: Product.products.length,
          itemBuilder: (BuildContext context, int index) {
            return Center(
              child: ProductCard(
                product: Product.products[index],
                widthFactor: 1.1,
                leftPosition: 100,
                isWishlist: true,
              ),
            );
          }),
    );
  }
}
