import 'package:equatable/equatable.dart';
import 'package:flutter_ecommerce_app/models/models.dart';

class Wishlist extends Equatable {
  final List<Product> products;

  const Wishlist({this.products = const <Product>[]});

  bool isWishlist(Product product) {
    var p = products.where((element) => product.id == element.id);
    if (p.isNotEmpty) return true;
    return false;
  }

  @override
  List<Object?> get props => [products];
}
