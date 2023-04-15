import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '/blocs/blocs.dart';
import '/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => HomeScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Zero To Unicorn',
          automaticallyImplyLeading: false,
        ),
        bottomNavigationBar: const CustomNavBar(screen: routeName),
        body: Column(
          children: [
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CategoryLoaded) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: 1.5,
                      viewportFraction: 0.9,
                      enlargeCenterPage: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.height,
                    ),
                    items: state.categories
                        .map((category) => HeroCarouselCard(
                            item: ItemCarousel(
                              name: category.name,
                              imageUrl: category.imageUrl,
                              routeName: '/catalog',
                            ),
                            category: category,
                          ))
                        .toList(),
                  );
                } else {
                  return const Text('[Categories]/Something went wrong.');
                }
              },
            ),
            const SectionTitle(title: 'RECOMMENDED'),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductLoaded) {
                  return ProductCarousel(
                    products: state.products
                        .where((product) => product.isRecommended)
                        .toList(),
                  );
                } else {
                  return const Text('[Recommended]/Something went wrong.');
                }
              },
            ),
            const SectionTitle(title: 'MOST POPULAR'),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ProductLoaded) {
                  return ProductCarousel(
                    products: state.products
                        .where((product) => product.isPopular)
                        .toList(),
                  );
                } else {
                  return const Text('[MostPopular]/Something went wrong.');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

