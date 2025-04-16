part of'home_bloc.dart'; 


abstract class HomeEvent{
  const HomeEvent();
}

class HomeInitialEvent extends HomeEvent {
}

class HomeErrorScreenToLoginEvent extends HomeEvent {}

class HomeProductClickedEvent extends HomeEvent {
  final int productId;
  const HomeProductClickedEvent({
    required this.productId,
  });
}