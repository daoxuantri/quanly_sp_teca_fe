part of 'detail_bloc.dart';


abstract class DetailState{
  const DetailState();
}

abstract class DetailActionState extends DetailState {}

class DetailInitial extends DetailState {}

class DetailLoadingState extends DetailState {}

class DetailLoadedSuccessState extends DetailState {
  final DetailProductData detailProduct;
  const DetailLoadedSuccessState({
    required this.detailProduct
  });
}

class DetailErrorState extends DetailState {
  final String errorMessage;
  const DetailErrorState({
    required this.errorMessage,
  });
}

class DetailErrorScreenToLoginState extends DetailActionState {}

class DetailProductClickedState extends DetailActionState {
  final int productId;
  DetailProductClickedState({
    required this.productId,
  });
}

class EditDetailMainProductClickedState extends DetailActionState {
  final String message;
  EditDetailMainProductClickedState({
    required this.message,
  });
}
class DeletePriceEntriesClickedState extends DetailActionState {
  final String message;
  DeletePriceEntriesClickedState({
    required this.message,
  });
}




