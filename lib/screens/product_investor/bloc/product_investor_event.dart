part of 'product_investor_bloc.dart';

abstract class ProductInvestorEvent {
  const ProductInvestorEvent();
}

class ProductInvestorInitialEvent extends ProductInvestorEvent {}

class ProductInvestorSelectProjectEvent extends ProductInvestorEvent {
  final InvestorInfoModel project;
  const ProductInvestorSelectProjectEvent({required this.project});
}

class ProductInvestorAddProductEvent extends ProductInvestorEvent {
  final int idInvestor;
  final int priceEntriesId;
  final double priceNhap;
  final double priceBan;
  final int quantity;
  const ProductInvestorAddProductEvent({
    required this.idInvestor,
    required this.priceEntriesId,
    required this.priceNhap,
    required this.priceBan,
    required this.quantity,
  });
}

class ProductInvestorFetchPriceEntriesEvent extends ProductInvestorEvent {
  final int? projectId;
  const ProductInvestorFetchPriceEntriesEvent({this.projectId});
}

class ProductInvestorCancelAddProductEvent extends ProductInvestorEvent {}