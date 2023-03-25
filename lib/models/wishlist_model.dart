import 'package:equatable/equatable.dart';
import 'package:flutter_ecommerce_app/models/models.dart';

class Wishlist extends Equatable {
  final List<Product> products;

  const Wishlist({this.products = const <Product>[]});

  @override
  List<Object?> get props => [products];
}
