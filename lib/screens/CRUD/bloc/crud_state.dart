part of 'crud_bloc.dart';

abstract class CRUDState {
  const CRUDState();
}

abstract class CRUDActionState extends CRUDState {}

class CRUDInitial extends CRUDState {}


class CRUDInitialScreenState extends CRUDState {}
class CRUDLoadingState extends CRUDState {}

class CRUDLoadedSuccessState extends CRUDState {
  // final List<ProductDataModel> listproduct;
  // const CRUDLoadedSuccessState({
  //   required this.listproduct
  // });
}

class CRUDErrorState extends CRUDState {
  final String errorMessage;
  const CRUDErrorState({
    required this.errorMessage,
  });
}

class CRUDErrorScreenToLoginState extends CRUDActionState {}

class CRUDProductClickedState extends CRUDActionState {
  final String productId;
  CRUDProductClickedState({
    required this.productId,
  });
}

class CRUDAddProductClickedState extends CRUDActionState {
  final String message;
    CRUDAddProductClickedState({
    required this.message,
  });
}