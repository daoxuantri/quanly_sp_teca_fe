// part of 'project_detail_bloc.dart';

// abstract class ProjectDetailState {
//   const ProjectDetailState();
// }

// abstract class ProjectDetailActionState extends ProjectDetailState {}

// class ProjectDetailInitial extends ProjectDetailState {}

// class ProjectDetailLoadingState extends ProjectDetailState {}

// class ProjectDetailSuccessState extends ProjectDetailActionState {
//   final String message;
//   ProjectDetailSuccessState({required this.message});
// }

// class ProjectDetailErrorState extends ProjectDetailActionState {
//   final String errorMessage;
//   ProjectDetailErrorState({required this.errorMessage});
// }

// class ProjectDetailProductsLoadedState extends ProjectDetailState {
//   final List<ProductInvestorModel> products;
//   final String? successMessage;
//   const ProjectDetailProductsLoadedState({
//     required this.products,
//     this.successMessage,
//   });
// }

// class ProjectDetailPriceEntriesLoadedState extends ProjectDetailState {
//   final List<ProductPriceModel> priceEntries;
//   final List<ProductInvestorModel> products;
//   const ProjectDetailPriceEntriesLoadedState({
//     required this.priceEntries,
//     required this.products,
//   });
// }

// class ProjectDetailPriceEntriesErrorState extends ProjectDetailActionState {
//   final String errorMessage;
//   ProjectDetailPriceEntriesErrorState({required this.errorMessage});
// }


part of 'project_detail_bloc.dart';

abstract class ProjectDetailState {
  const ProjectDetailState();
}

abstract class ProjectDetailActionState extends ProjectDetailState {}

class ProjectDetailInitial extends ProjectDetailState {}

class ProjectDetailLoadingState extends ProjectDetailState {}

class ProjectDetailSuccessState extends ProjectDetailActionState {
  final String message;
  ProjectDetailSuccessState({required this.message});
}

class ProjectDetailErrorState extends ProjectDetailActionState {
  final String errorMessage;
  ProjectDetailErrorState({required this.errorMessage});
}

class ProjectDetailProductsLoadedState extends ProjectDetailState {
  final List<ProductInvestorModel> products;
  final String? successMessage;
  const ProjectDetailProductsLoadedState({
    required this.products,
    this.successMessage,
  });
}

class ProjectDetailPriceEntriesLoadedState extends ProjectDetailState {
  final List<ProductPriceModel> priceEntries;
  final List<ProductInvestorModel> products;
  const ProjectDetailPriceEntriesLoadedState({
    required this.priceEntries,
    required this.products,
  });
}

class ProjectDetailPriceEntriesErrorState extends ProjectDetailActionState {
  final String errorMessage;
  ProjectDetailPriceEntriesErrorState({required this.errorMessage});
}

class ProjectDetailCreateProductSuccessState extends ProjectDetailActionState {
  final String message;
  final List<ProductPriceModel> priceEntries;
  final List<ProductInvestorModel> products;
   ProjectDetailCreateProductSuccessState({
    required this.message,
    required this.priceEntries,
    required this.products,
  });
}
