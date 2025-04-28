part of 'price_entries_bloc.dart';

abstract class PriceEntriesState {
  const PriceEntriesState();
}

abstract class PriceEntriesActionState extends PriceEntriesState {}

class PriceEntriesInitial extends PriceEntriesState {}

class PriceEntriesLoadingState extends PriceEntriesState {}

class PriceEntriesProductsLoadedState extends PriceEntriesState {
  final List<ProductDataModel> products;
  PriceEntriesProductsLoadedState({required this.products});
}

class PriceEntriesSuccessState extends PriceEntriesActionState {
  final String message;
  PriceEntriesSuccessState({required this.message});
}

class PriceEntriesErrorState extends PriceEntriesState {
  final String errorMessage;
  const PriceEntriesErrorState({required this.errorMessage});
}