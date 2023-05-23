import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

@immutable
class MiniCollection {
  final String assetName;
  final List<Product> products;

  const MiniCollection({
    required this.assetName,
    required this.products,
  });
}

@immutable
class Product {
  final String name;
  final Offset position;

  const Product({
    required this.name,
    required this.position,
  });
}

const collections = <MiniCollection>[
  MiniCollection(
    assetName: 'assets/unsplash/diego-sanchez-HXLz1ua76yA-unsplash.jpg',
    products: [
      Product(
        name: 'Dress',
        position: Offset(.2, .65),
      ),
      Product(
        name: 'Earrings',
        position: Offset(.6, .15),
      ),
      Product(
        name: 'Shoes',
        position: Offset(0.75, .9),
      ),
    ],
  ),
];
