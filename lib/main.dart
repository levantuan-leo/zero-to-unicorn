import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/config/app_router.dart';
import 'package:flutter_ecommerce_app/repositories/repositories.dart';
import 'package:flutter_ecommerce_app/screens/screens.dart';
import 'package:flutter_ecommerce_app/simple_bloc_observer.dart';

import 'blocs/blocs.dart';
import 'config/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => WishlistBloc()..add(StartWishlist()),
          ),
          BlocProvider(
            create: (_) => CartBloc()..add(StartCart()),
          ),
          BlocProvider(
            create: (_) =>
                CategoryBloc(categoryRepository: CategoryRepository())
                  ..add(LoadCategories()),
          ),
          BlocProvider(
            create: (_) => PaymentBloc()..add(LoadPaymentMethod()),
          ),
          BlocProvider(
            create: (context) => CheckoutBloc(
              cartBloc: context.read<CartBloc>(),
              paymentBloc: context.read<PaymentBloc>(),
              checkoutRepository: CheckoutRepository(),
            ),
          ),
          BlocProvider(
            create: (_) => ProductBloc(
              productRepository: ProductRepository(),
            )..add(LoadProducts()),
          )
        ],
        child: MaterialApp(
          title: 'Zero To Unicorn',
          theme: theme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,
        ));
  }
}
