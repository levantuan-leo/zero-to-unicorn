import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/blocs/blocs.dart';
import 'package:flutter_ecommerce_app/models/models.dart';
import 'package:flutter_ecommerce_app/repositories/repositories.dart';
import 'package:intl/intl.dart';
import '/widgets/widgets.dart';

class ReceiptScreen extends StatefulWidget {
  static const String routeName = '/receipts';

  const ReceiptScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ReceiptBloc>(
        create: (context) => ReceiptBloc(
          authBloc: BlocProvider.of<AuthBloc>(context),
          checkoutRepository: context.read<CheckoutRepository>(),
        )..add(
            LoadReceipts(context.read<AuthBloc>().state.authUser),
          ),
        child: const ReceiptScreen(),
      ),
    );
  }

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final Map<String, bool> expandList = {};

  Widget _buildButtons(
      {isPaymentSuccessful: false, isCancel: false, isOrderSuccessful: false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        isCancel || isPaymentSuccessful
            ? ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: Colors.red,
                ),
                child: const Text('Order again'),
              )
            : const SizedBox(),
        isOrderSuccessful && !isCancel && !isPaymentSuccessful
            ? Row(children: [
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Cancel')),
                const SizedBox(
                  width: 5,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Received'),
                )
              ])
            : const SizedBox(),
      ],
    );
  }

  Widget _buildStatus(
      {isPaymentSuccessful: false, isCancel: false, isOrderSuccessful: false}) {
    return Row(
      children: [
        Icon(
          Icons.circle,
          color: isCancel
              ? Colors.red
              : (isPaymentSuccessful ? Colors.green : Colors.amber),
          size: 15,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          isCancel
              ? 'Canceled'
              : isPaymentSuccessful
                  ? 'Successful'
                  : 'Not payment',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.black),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Receipt',
          hideActions: true,
        ),
        bottomNavigationBar:
            const CustomNavBar(screen: ReceiptScreen.routeName),
        body: BlocBuilder<ReceiptBloc, ReceiptState>(
          builder: (context, state) {
            if (state is ReceiptLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
            if (state is ReceiptLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: state.receipts.isNotEmpty
                    ? SingleChildScrollView(
                        child: ExpansionPanelList(
                          expansionCallback: (int index, bool isExpanded) {
                            setState(() {
                              expandList[state.receipts[index].id] =
                                  !isExpanded;
                            });
                          },
                          children: state.receipts
                              .map<ExpansionPanel>((Checkout checkout) {
                            final cart = checkout.cart
                                .productQuantity(checkout.cart.products);
                            return ExpansionPanel(
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return ListTile(
                                    title: RichText(
                                        text: TextSpan(
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5!
                                          .copyWith(color: Colors.black),
                                      children: <TextSpan>[
                                        const TextSpan(
                                            text: 'ORDER CODE: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal)),
                                        TextSpan(
                                          text: checkout.id,
                                        ),
                                      ],
                                    )),
                                    subtitle: Text(
                                      DateFormat("dd-MM-yyyy").format(
                                          checkout.createAt ?? DateTime.now()),
                                    ));
                              },
                              body: SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(children: <Widget>[
                                    _buildStatus(
                                        isCancel: checkout.isCancel,
                                        isOrderSuccessful:
                                            checkout.isOrderSuccessful,
                                        isPaymentSuccessful:
                                            checkout.isPaymentSuccessful),
                                    const SizedBox(height: 5),
                                    ListView.builder(
                                      itemCount: cart.keys.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return ProductCard.summary(
                                          product: cart.keys.elementAt(index),
                                          quantity:
                                              cart.values.elementAt(index),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    _buildButtons(
                                        isCancel: checkout.isCancel,
                                        isOrderSuccessful:
                                            checkout.isOrderSuccessful,
                                        isPaymentSuccessful:
                                            checkout.isPaymentSuccessful),
                                  ])),
                              isExpanded: expandList[checkout.id] ?? false,
                            );
                          }).toList(),
                        ),
                      )
                    : const EmptyData(
                        title: "Your Receipt is empty!",
                      ),
              );
            }
            if (state is ReceiptUnauthenticated) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'You are not logged in!',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.red,
                      fixedSize: const Size(200, 40),
                    ),
                    child: Text(
                      'Log In',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                      context.read<AuthRepository>().signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      backgroundColor: Colors.white,
                      fixedSize: const Size(200, 40),
                    ),
                    child: Text(
                      'Sign Up',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ],
              );
            }
            return const Text('Something went wrong!');
          },
        ));
  }
}
