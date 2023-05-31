import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

@immutable
class MiniCollection {
  final double aspectRatio;
  final String assetName;
  final String blurHash;
  final List<Product> products;

  const MiniCollection({
    required this.aspectRatio,
    required this.assetName,
    required this.blurHash,
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
    aspectRatio: 2629.0 / 4679.0,
    assetName: 'assets/unsplash/diego-sanchez-HXLz1ua76yA-unsplash.jpg',
    blurHash: 'LBF=s[?G*0I;9bbuITIU58D%s8-o',
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
    aspectRatio: 4790.0 / 3193.0,
    assetName: 'assets/unsplash/freestocks-A11MXTzUhLE-unsplash.jpg',
    blurHash: 'L5KB2V0000?w0K?v?H0000tRDi-q',
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
    aspectRatio: 7806.0 / 5304.0,
    assetName: 'assets/unsplash/roman-bozhko-PypjzKTUqLo-unsplash.jpg',
    blurHash: 'LzLXb{~qIUWUo#t7WAV@V@WBofj]',
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
