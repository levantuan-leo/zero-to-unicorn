import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_ecommerce_app/blocs/blocs.dart';
import 'package:flutter_ecommerce_app/models/models.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_ecommerce_app/repositories/repositories.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptBloc extends Bloc<ReceiptEvent, ReceiptState> {
  final CheckoutRepository _checkoutRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _authSubscription;
  StreamSubscription? _checkoutSubscription;

  ReceiptBloc(
      {required CheckoutRepository checkoutRepository,
      required AuthBloc authBloc})
      : _authBloc = authBloc,
        _checkoutRepository = checkoutRepository,
        super(ReceiptLoading()) {
    on<LoadReceipts>(_onLoadReceipts);
    on<UpdateReceipts>(_onUpdateReceipts);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user is AuthUserChanged) {
        if (state.user != null) {
          add(LoadReceipts(state.authUser));
        }
      }
    });
  }

  void _onLoadReceipts(
    LoadReceipts event,
    Emitter<ReceiptState> emit,
  ) {
    if (event.authUser != null) {
      _checkoutRepository
          .getAllCheckoutByUser(event.authUser!.uid)
          .listen((receipts) {
        add(
          UpdateReceipts(receipts: receipts),
        );
      });
    } else {
      emit(ReceiptUnauthenticated());
    }
  }

  void _onUpdateReceipts(
    UpdateReceipts event,
    Emitter<ReceiptState> emit,
  ) {
    emit(
      ReceiptLoaded(receipts: event.receipts),
    );
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    _checkoutSubscription?.cancel();
    super.close();
  }
}
