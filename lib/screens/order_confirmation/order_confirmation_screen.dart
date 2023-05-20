import '/blocs/order_confirmation/order_confirmation_bloc.dart';
import '/repositories/checkout/checkout_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';

class OrderConfirmation extends StatelessWidget {
  static const String routeName = '/order-confirmation';

  static Route route({required String checkoutId}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<OrderConfirmationBloc>(
        create: (context) => OrderConfirmationBloc(
          checkoutRepository: context.read<CheckoutRepository>(),
        )..add(LoadOrderConfirmation(checkoutId: checkoutId)),
        child: OrderConfirmation(checkoutId: checkoutId),
      ),
    );
  }

  final String checkoutId;

  const OrderConfirmation({
    Key? key,
    required this.checkoutId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Order Confirmation'),
      bottomNavigationBar: const CustomNavBar(screen: routeName),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<OrderConfirmationBloc, OrderConfirmationState>(
        builder: (context, state) {
          if (state is OrderConfirmationLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is OrderConfirmationLoaded) {
            List<Product> products = state.checkout.cart.products;
            Map cart = state.checkout.cart.productQuantity(products);

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: Colors.red,
                        width: double.infinity,
                        height: 300,
                      ),
                      Positioned(
                        left: (MediaQuery.of(context).size.width - 100) / 2,
                        top: 125,
                        child: SvgPicture.asset(
                          'assets/svgs/garlands.svg',
                          height: 100,
                          width: 100,
                        ),
                      ),
                      Positioned(
                        top: 250,
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Your order is complete!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi ${state.checkout.user!.fullName},',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                            text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.black),
                          children: const <TextSpan>[
                            TextSpan(text: 'Thank you for purchasing on '),
                            TextSpan(
                                text: 'Zero To Unicorn',
                                style: TextStyle(color: Colors.red)),
                          ],
                        )),
                        const SizedBox(height: 20),
                        RichText(
                            text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.black),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'ORDER CODE: ',
                                style:
                                    TextStyle(fontWeight: FontWeight.normal)),
                            TextSpan(
                              text: checkoutId,
                            ),
                          ],
                        )),
                        OrderSummary(cart: state.checkout.cart),
                        const SizedBox(height: 20),
                        Text(
                          'ORDER DETAILS',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.black),
                        ),
                        const Divider(thickness: 2),
                        const SizedBox(height: 5),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cart.keys.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ProductCard.summary(
                              product: cart.keys.elementAt(index),
                              quantity: cart.values.elementAt(index),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text('Something went wrong.');
          }
        },
      ),
    );
  }
}
