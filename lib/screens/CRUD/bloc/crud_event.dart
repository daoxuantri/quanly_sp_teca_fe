part of "crud_bloc.dart";

abstract class CRUDEvent{
  const CRUDEvent();
}

class CRUDInitialEvent extends CRUDEvent {}

class CRUDErrorScreenToLoginEvent extends CRUDEvent {}

class CRUDProductClickedEvent extends CRUDEvent {
  final String productId;
  const CRUDProductClickedEvent({
    required this.productId,
  });
}