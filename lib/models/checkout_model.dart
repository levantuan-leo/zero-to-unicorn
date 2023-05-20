import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '/blocs/payment/payment_bloc.dart';
import '/models/models.dart';

class Checkout extends Equatable {
  final String id;
  final User? user;
  final Cart cart;
  final DateTime? createAt;
  final PaymentMethod paymentMethod;
  final String? paymentMethodId;
  final bool isPaymentSuccessful;
  final bool isOrderSuccessful;
  final bool isCancel;

  Checkout(
      {this.id = '',
      this.user = User.empty,
      required this.cart,
      this.paymentMethod = PaymentMethod.credit_card,
      this.isPaymentSuccessful = false,
      this.isOrderSuccessful = false,
      this.isCancel = false,
      this.paymentMethodId,
      createAt})
      : createAt = createAt ?? DateTime.now();

  Checkout copyWith({
    String? id,
    User? user,
    Cart? cart,
    PaymentMethod? paymentMethod,
    String? paymentMethodId,
    bool? isPaymentSuccessful,
    bool? isOrderSuccessful,
  }) {
    return Checkout(
      id: id ?? this.id,
      user: user ?? this.user,
      cart: cart ?? this.cart,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      isPaymentSuccessful: isPaymentSuccessful ?? this.isPaymentSuccessful,
      isOrderSuccessful: isOrderSuccessful ?? this.isOrderSuccessful,
    );
  }

  static Checkout fromSnapshot(DocumentSnapshot snap) {
    Checkout checkout = Checkout(
      id: snap.id,
      user: User.fromJson(snap['user']),
      cart: Cart.fromJson(snap['cart']),
      paymentMethod: PaymentMethod.values.firstWhere(
        (value) {
          return value.toString().split('.').last == snap['paymentMethod'];
        },
      ),
      paymentMethodId: snap['paymentMethodId'],
      isPaymentSuccessful: snap['isPaymentSuccessful'],
      isOrderSuccessful: snap['isOrderSuccessful'],
      isCancel: snap['isCancel'],
      createAt: (snap['createAt'] as Timestamp).toDate(),
    );

    return checkout;
  }

  int get total {
    double subtotal =
        cart.products.fold(0, (total, current) => total + current.price);
    if (subtotal >= 30.0) {
      return (subtotal * 100).toInt();
    } else {
      return ((subtotal + 10.0) * 100).toInt();
    }
  }

  List<Map<String, dynamic>> get items {
    List<Map<String, dynamic>> _items = List.empty();
    for (var element in cart.products) {
      _items.add({element.id: element});
    }

    return _items;
  }

  @override
  List<Object?> get props => [
        id,
        user,
        cart,
        paymentMethod,
        paymentMethodId,
        isPaymentSuccessful,
        isOrderSuccessful,
      ];

  Map<String, Object> toDocument() {
    return {
      'user': user?.toDocument() ?? User.empty.toDocument(),
      'cart': cart.toDocument(),
      'paymentMethod': paymentMethod.name,
      'paymentMethodId': paymentMethodId ?? '',
      'isPaymentSuccessful': isPaymentSuccessful,
      'isOrderSuccessful': isOrderSuccessful,
      'isCancel': isCancel,
      'createAt': createAt?.toUtc() ?? '',
    };
  }

  static Checkout fromJson(
    Map<String, dynamic> json, [
    String? id,
  ]) {
    Checkout checkout = Checkout(
      id: id ?? json['id'],
      user: User.fromJson(json['user']),
      cart: Cart.fromJson(json['cart']),
      paymentMethod: PaymentMethod.values.firstWhere(
        (value) {
          return value.toString().split('.').last == json['paymentMethod'];
        },
      ),
      paymentMethodId: json['paymentMethodId'],
      isPaymentSuccessful: json['isPaymentSuccessful'],
      isOrderSuccessful: json['isOrderSuccessful'],
      isCancel: json['isCancel'],
      createAt: (json['createAt'] as Timestamp).toDate(),
    );
    return checkout;
  }
}
