part of 'home_bloc.dart';


abstract class HomeState{
  const HomeState();
}

abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<ProductDataModel> listproduct;
  const HomeLoadedSuccessState({
    required this.listproduct
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
  final String productId;
  HomeProductClickedState({
    required this.productId,
  });
}

