import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ecommerce_app/blocs/blocs.dart';
import 'package:flutter_ecommerce_app/models/models.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final PaymentBloc _paymentBloc;
  StreamSubscription? _paymentSubscription;

  CartBloc({required PaymentBloc paymentBloc})
      : _paymentBloc = paymentBloc,
        super(CartLoading()) {
    on<StartCart>(_onStartCart);
    on<AddProductToCart>(_onAddProductToCart);
    on<RemoveProductFromCart>(_onRemoveProductFromCart);
    on<ClearProductFromCart>(_onClearProductFromCart);

    _paymentSubscription = _paymentBloc.stream.listen(
      (state) {
        if (state.status == PaymentStatus.success) {
          add(const ClearProductFromCart());
        }
      },
    );
  }

  void _onStartCart(
    StartCart event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      await Future<void>.delayed(const Duration(seconds: 1));
      emit(
        const CartLoaded(),
      );
    } catch (_) {
      emit(CartError());
    }
  }

  void _onAddProductToCart(
    AddProductToCart event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      try {
        emit(
          CartLoaded(
            cart: Cart(
              products: List.from((state as CartLoaded).cart.products)
                ..add(event.product),
            ),
          ),
        );
      } on Exception {
        emit(CartError());
      }
    }
  }

  void _onRemoveProductFromCart(
    RemoveProductFromCart event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      try {
        emit(
          CartLoaded(
            cart: Cart(
              products: List.from((state as CartLoaded).cart.products)
                ..remove(event.product),
            ),
          ),
        );
      } on Exception {
        emit(CartError());
      }
    }
  }

  void _onClearProductFromCart(
    ClearProductFromCart event,
    Emitter<CartState> emit,
  ) async {
    if (state is CartLoaded) {
      try {
        emit(
          const CartLoaded(
            cart: Cart(
              products: [],
            ),
          ),
        );
      } on Exception {
        emit(CartError());
      }
    }
  }

  @override
  Future<void> close() async {
    _paymentSubscription?.cancel();
    super.close();
  }
}


