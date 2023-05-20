part of 'receipt_bloc.dart';

abstract class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object?> get props => [];
}

class LoadReceipts extends ReceiptEvent {
  final auth.User? authUser;

  const LoadReceipts(this.authUser);

  @override
  List<Object?> get props => [authUser];
}

class UpdateReceipts extends ReceiptEvent {
  final List<Checkout> receipts;

  const UpdateReceipts({required this.receipts});

  @override
  List<Object> get props => [receipts];
}
