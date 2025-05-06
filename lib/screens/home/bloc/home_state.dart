part of 'home_bloc.dart';

abstract class HomeState {
  const HomeState();
}

abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<ProductPriceModel> listproduct;
  const HomeLoadedSuccessState({
    required this.listproduct,
  });
}

class HomeErrorState extends HomeState {
  final String errorMessage;
  const HomeErrorState({
    required this.errorMessage,
  });
}

class HomeErrorScreenToLoginState extends HomeActionState {}

class HomeProductClickedState extends HomeActionState {
  final ProductPriceModel product;
  HomeProductClickedState({
    required this.product,
  });
}

class HomeProductRemovedClickedState extends HomeActionState {
  final String message;
  HomeProductRemovedClickedState({
    required this.message,
  });
}

class HomeCreateProductSuccessState extends HomeActionState {
  final String message;
  HomeCreateProductSuccessState({
    required this.message,
  });
}