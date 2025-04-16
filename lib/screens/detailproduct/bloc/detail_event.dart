part of'detail_bloc.dart'; 


abstract class DetailEvent{
  const DetailEvent();
}

class DetailInitialEvent extends DetailEvent {
  final int productId;
  const DetailInitialEvent({
    required this.productId
  });
}

class DetailErrorScreenToLoginEvent extends DetailEvent {}

class DetailProductClickedEvent extends DetailEvent {
  final int productId;
  const DetailProductClickedEvent({
    required this.productId,
  });
}