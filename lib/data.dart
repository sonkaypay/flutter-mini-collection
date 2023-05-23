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
  MiniCollection(
    assetName: 'assets/unsplash/freestocks-A11MXTzUhLE-unsplash.jpg',
    products: [
      Product(
        name: 'iPhone',
        position: Offset(.3, .5),
      ),
      Product(
        name: 'Apple Watch',
        position: Offset(.65, .45),
      ),
    ],
  ),
  MiniCollection(
    assetName: 'assets/unsplash/roman-bozhko-PypjzKTUqLo-unsplash.jpg',
    products: [
      Product(
        name: 'iMac',
        position: Offset(.85, .6),
      ),
      Product(
        name: 'Calendar',
        position: Offset(.8, .05),
      ),
      Product(
        name: 'Desk',
        position: Offset(.1, .88),
      ),
      Product(
        name: 'Chair',
        position: Offset(.45, .9),
      ),
    ],
  ),
];
