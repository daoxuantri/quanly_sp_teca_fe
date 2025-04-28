part of 'price_entries_bloc.dart';

abstract class PriceEntriesEvent {
  const PriceEntriesEvent();
}

class PriceEntriesLoadProductsEvent extends PriceEntriesEvent {}

class PriceEntriesSubmitEvent extends PriceEntriesEvent {
  final int productId;
  final double price;
  final String origin;
  final String brand;
  final String supplier;
  final String priceDate;
  final String asker;
  final String note;

  const PriceEntriesSubmitEvent({
    required this.productId,
    required this.price,
    required this.origin,
    required this.brand,
    required this.supplier,
    required this.priceDate,
    required this.asker,
    required this.note,
  });
}