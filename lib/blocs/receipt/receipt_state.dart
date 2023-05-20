part of 'receipt_bloc.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object> get props => [];
}

class ReceiptLoading extends ReceiptState {}

class ReceiptLoaded extends ReceiptState {
  final List<Checkout> receipts;

  const ReceiptLoaded({this.receipts = const <Checkout>[]});

  @override
  List<Object> get props => [receipts];
}

class ReceiptUnauthenticated extends ReceiptState {}
