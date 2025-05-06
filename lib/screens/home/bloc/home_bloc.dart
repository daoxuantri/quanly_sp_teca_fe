import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/product_price.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeErrorScreenToLoginEvent>(homeErrorScreenToLoginEvent);
    on<HomeProductClickedEvent>(homeProductClickedEvent);
    on<HomeProductRemovedClickedEvent>(homeProductRemovedClickedEvent);
    on<HomeCreateProductEvent>(homeCreateProductEvent);
  }

  Future<FutureOr<void>> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      List<ProductPriceModel> listproduct =
          await ApiServiceProductPrice().getAllProduct();
      emit(HomeLoadedSuccessState(listproduct: listproduct));
    } catch (e) {
      String failToken = e.toString();
      if (failToken.startsWith('Exception: ')) {
        failToken = failToken.substring('Exception: '.length);
      }
      print('Error in homeInitialEvent: $failToken');
      emit(HomeErrorState(errorMessage: failToken));
    }
  }

  Future<FutureOr<void>> homeProductRemovedClickedEvent(
      HomeProductRemovedClickedEvent event, Emitter<HomeState> emit) async {
    String? message = await ApiServiceProductPrice().deleteProductPrice(event.productId);
    emit(HomeProductRemovedClickedState(message: message));
  }

  Future<FutureOr<void>> homeCreateProductEvent(
      HomeCreateProductEvent event, Emitter<HomeState> emit) async {
    try {
      String message = await ApiServiceProductPrice().addProductPrice(
        event.code,
        event.name ?? '',
        event.specificProduct ?? '',
        event.unit ?? '',
        event.price ?? 0,
        event.priceDate ?? '',
        event.origin ?? '',
        event.brand ?? '',
        event.supplier,
        event.asker,
        event.note ?? '',
      );
      emit(HomeCreateProductSuccessState(message: message));
    } catch (e) {
      emit(HomeErrorState(errorMessage: 'Không thể tạo sản phẩm: $e'));
    }
  }

  FutureOr<void> homeErrorScreenToLoginEvent(
      HomeErrorScreenToLoginEvent event, Emitter<HomeState> emit) {
    emit(HomeErrorScreenToLoginState());
  }

  FutureOr<void> homeProductClickedEvent(
      HomeProductClickedEvent event, Emitter<HomeState> emit) {
    emit(HomeProductClickedState(product: event.product));
  }
}