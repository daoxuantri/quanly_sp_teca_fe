import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/product_investor.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';
import 'package:quanly_sp_teca_fe/model/product_investor/product_investor_model.dart';
import 'package:quanly_sp_teca_fe/model/price_entries/price_entries_data_model.dart';

part 'product_investor_event.dart';
part 'product_investor_state.dart';

class ProductInvestorBloc extends Bloc<ProductInvestorEvent, ProductInvestorState> {
  InvestorInfoModel? _selectedProject; // Lưu trữ selectedProject
  List<ProductInvestorModel>? _products; // Lưu trữ danh sách sản phẩm

  ProductInvestorBloc() : super(ProductInvestorInitial()) {
    on<ProductInvestorInitialEvent>(productInvestorInitialEvent);
    on<ProductInvestorSelectProjectEvent>(productInvestorSelectProjectEvent);
    on<ProductInvestorAddProductEvent>(productInvestorAddProductEvent);
    on<ProductInvestorFetchPriceEntriesEvent>(productInvestorFetchPriceEntriesEvent);
    on<ProductInvestorCancelAddProductEvent>(productInvestorCancelAddProductEvent);
  }

  Future<void> productInvestorInitialEvent(
      ProductInvestorInitialEvent event, Emitter<ProductInvestorState> emit) async {
    emit(ProductInvestorLoadingState());
    try {
      List<InvestorInfoModel> projects =
          await ApiServiceProductInvestor().getAllInvestorInfo();
      emit(ProductInvestorProjectsLoadedState(projects: projects));
    } catch (e) {
      emit(ProductInvestorErrorState(errorMessage: 'Không thể tải danh sách dự án: $e'));
    }
  }

  Future<void> productInvestorSelectProjectEvent(
      ProductInvestorSelectProjectEvent event, Emitter<ProductInvestorState> emit) async {
    emit(ProductInvestorLoadingState());
    try {
      List<ProductInvestorModel> products = await ApiServiceProductInvestor()
          .getProductsByInvestor(event.project.id!);
      _selectedProject = event.project;
      _products = products;
      emit(ProductInvestorProductsLoadedState(
        selectedProject: event.project,
        products: products,
      ));
    } catch (e) {
      emit(ProductInvestorErrorState(
          errorMessage: 'Không thể tải danh sách sản phẩm: $e'));
    }
  }

  Future<void> productInvestorAddProductEvent(
      ProductInvestorAddProductEvent event, Emitter<ProductInvestorState> emit) async {
    emit(ProductInvestorLoadingState());
    try {
      final message = await ApiServiceProductInvestor().createProductInvestor(
        event.idInvestor,
        event.priceEntriesId,
        event.priceNhap,
        event.priceBan,
        event.quantity,
      );
      List<ProductInvestorModel> products = await ApiServiceProductInvestor()
          .getProductsByInvestor(event.idInvestor);
      _products = products;
      emit(ProductInvestorProductsLoadedState(
        selectedProject: InvestorInfoModel(id: event.idInvestor),
        products: products,
      ));
      emit(ProductInvestorSuccessState(message: message));
    } catch (e) {
      emit(ProductInvestorErrorState(errorMessage: 'Không thể thêm sản phẩm: $e'));
    }
  }

  Future<void> productInvestorFetchPriceEntriesEvent(
      ProductInvestorFetchPriceEntriesEvent event, Emitter<ProductInvestorState> emit) async {
    emit(ProductInvestorLoadingState());
    try {
      List<PriceEntriesDataModel> priceEntries =
          await ApiServiceProductInvestor().getPriceEntries();
      print('Raw priceEntries: $priceEntries');
      emit(ProductInvestorPriceEntriesLoadedState(priceEntries: priceEntries));
    } catch (e) {
      emit(ProductInvestorPriceEntriesErrorState(
          errorMessage: 'Không thể tải danh sách giá: $e'));
    }
  }

  Future<void> productInvestorCancelAddProductEvent(
      ProductInvestorCancelAddProductEvent event, Emitter<ProductInvestorState> emit) async {
    if (_selectedProject != null && _products != null) {
      emit(ProductInvestorProductsLoadedState(
        selectedProject: _selectedProject!,
        products: _products!,
      ));
    } else {
      emit(ProductInvestorInitial());
    }
  }
}