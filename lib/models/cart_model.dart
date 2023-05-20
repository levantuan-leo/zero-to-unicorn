import 'package:equatable/equatable.dart';

import '/models/product_model.dart';

class Cart extends Equatable {
  final List<Product> products;

  const Cart({this.products = const <Product>[]});

  @override
  List<Object?> get props => [products];

  Map<String, dynamic> toDocument() {
    Map cartMap = productQuantity(this.products);
    Map<String, dynamic> products = {};
    for (Product element in cartMap.keys) {
      Map<String, dynamic> product = {};
      product['product'] = element.toDocument();
      product['quantity'] = cartMap[element];
      products[element.id] = product;
    }

    return {
      'products': products,
      'deliveryFee': deliveryFeeString,
      'subtotal': subtotalString,
      'total': totalString
    };
  }

  static Cart fromJson(Map<String, dynamic> json) {
    Map productsMap = (json['products'] as Map);
    List productsList = [];
    for (var key in productsMap.keys) {
      for (var i = 0; i < productsMap[key]['quantity']; i++) {
        productsList.add(productsMap[key]['product']);
      }
    }
    Cart cart = Cart(
      products:
          productsList
          .map((product) => Product.fromJson(product))
          .toList(),
    );
    return cart;
  }

  Map productQuantity(products) {
    var quantity = {};

    products.forEach((product) {
      if (!quantity.containsKey(product)) {
        quantity[product] = 1;
      } else {
        quantity[product] += 1;
      }
    });

    return quantity;
  }

  double get subtotal =>
      products.fold(0, (total, current) => total + current.price);

  double deliveryFee(subtotal) {
    if (subtotal >= 30.0) {
      return 0.0;
    } else {
      return 10.0;
    }
  }

  String freeDelivery(subtotal) {
    if (subtotal >= 30.0) {
      return 'You have Free Delivery';
    } else {
      double missing = 30.0 - subtotal;
      return 'Add \$${missing.toStringAsFixed(2)} for FREE Delivery';
    }
  }

  double total(subtotal, deliveryFee) {
    return subtotal + deliveryFee(subtotal);
  }

  String get deliveryFeeString => deliveryFee(subtotal).toStringAsFixed(2);

  String get subtotalString => subtotal.toStringAsFixed(2);

  String get totalString => total(subtotal, deliveryFee).toStringAsFixed(2);

  String get freeDeliveryString => freeDelivery(subtotal);
}
