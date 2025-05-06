part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeInitialEvent extends HomeEvent {}

class HomeErrorScreenToLoginEvent extends HomeEvent {}

class HomeProductClickedEvent extends HomeEvent {
  final ProductPriceModel product;
  const HomeProductClickedEvent({
    required this.product,
  });
}

class HomeProductRemovedClickedEvent extends HomeEvent {
  final int productId;
  const HomeProductRemovedClickedEvent({
    required this.productId,
  });
}

class HomeCreateProductEvent extends HomeEvent {
  final String code;
  final String? name;
  final String? specificProduct;
  final String? unit;
  final int? price;
  final String? priceDate;
  final String? origin;
  final String? brand;
  final String supplier;
  final String asker;
  final String? note;

  const HomeCreateProductEvent({
    required this.code,
    this.name,
    this.specificProduct,
    this.unit,
    this.price,
    this.priceDate,
    this.origin,
    this.brand,
    required this.supplier,
    required this.asker,
    this.note,
  });
}