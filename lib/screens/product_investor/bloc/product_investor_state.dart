part of 'product_investor_bloc.dart';

abstract class ProductInvestorState {
  const ProductInvestorState();
}

abstract class ProductInvestorActionState extends ProductInvestorState {}

class ProductInvestorInitial extends ProductInvestorState {}

class ProductInvestorLoadingState extends ProductInvestorState {}

class ProductInvestorSuccessState extends ProductInvestorActionState {
  final String message;
  ProductInvestorSuccessState({required this.message});
}

class ProductInvestorErrorState extends ProductInvestorActionState {
  final String errorMessage;
  ProductInvestorErrorState({required this.errorMessage});
}

class ProductInvestorProjectsLoadedState extends ProductInvestorState {
  final List<InvestorInfoModel> projects;
  const ProductInvestorProjectsLoadedState({required this.projects});
}

class ProductInvestorProductsLoadedState extends ProductInvestorState {
  final InvestorInfoModel selectedProject;
  final List<ProductInvestorModel> products;
  const ProductInvestorProductsLoadedState({
    required this.selectedProject,
    required this.products,
  });
}

class ProductInvestorPriceEntriesLoadedState extends ProductInvestorState {
  final List<PriceEntriesDataModel> priceEntries;
  const ProductInvestorPriceEntriesLoadedState({required this.priceEntries});
}

class ProductInvestorPriceEntriesErrorState extends ProductInvestorActionState {
  final String errorMessage;
  ProductInvestorPriceEntriesErrorState({required this.errorMessage});
}