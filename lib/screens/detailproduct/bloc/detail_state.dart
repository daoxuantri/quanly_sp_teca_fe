part of 'detail_bloc.dart';

abstract class DetailState {
  const DetailState();
}

abstract class DetailActionState extends DetailState {}

class DetailInitial extends DetailState {}

class DetailErrorState extends DetailState {
  final String errorMessage;
  const DetailErrorState({
    required this.errorMessage,
  });
}

class EditDetailMainProductClickedState extends DetailActionState {
  final String message;
  EditDetailMainProductClickedState({
    required this.message,
  });
}

class DeleteProductClickedState extends DetailActionState {
  final String message;
  DeleteProductClickedState({
    required this.message,
  });
}