import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_ecommerce_app/models/firebase_dynamic_link.dart';
import '/blocs/blocs.dart';
import '/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const HomeScreen(),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseDynamicLink.initDynamicLink(context);
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
        bottomNavigationBar: const CustomNavBar(screen: HomeScreen.routeName),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              SizedBox(height: 20),
              SearchBox(),
              _HeroCarousel(),
              SizedBox(height: 10),
              SectionTitle(title: 'Recommended'),
              _ProductCarousel(isPopular: false),
              SectionTitle(title: 'Most Popular'),
              _ProductCarousel(isPopular: true),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCarousel extends StatelessWidget {
  const _ProductCarousel({
    Key? key,
    required this.isPopular,
  }) : super(key: key);

  final bool isPopular;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is ProductLoaded) {
          var products = (isPopular)
              ? state.products.where((product) => product.isPopular).toList()
              : state.products
                  .where((product) => product.isRecommended)
                  .toList();
          return Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 165,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: ProductCard.catalog(product: products[index]),
                  );
                },
              ),
            ),
          );
        } else {
          return const Text('Something went wrong.');
        }
      },
    );
  }
}

class _HeroCarousel extends StatelessWidget {
  const _HeroCarousel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
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
                .map((category) => HeroCarouselCard(category: category))
                .toList(),
          );
        } else {
          return const Text('Something went wrong.');
        }
      },
    );
  }
}
