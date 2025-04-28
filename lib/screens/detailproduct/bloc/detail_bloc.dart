import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/price_entries.dart';
import 'package:quanly_sp_teca_fe/api/products.dart';
import 'package:quanly_sp_teca_fe/model/product/detail/detail_product_data_model.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc() : super(DetailInitial()) {
    on<DetailInitialEvent>(detailInitialEvent);
    on<DetailErrorScreenToLoginEvent>(detailErrorScreenToLoginEvent);
    on<DetailProductClickedEvent>(detailProductClickedEvent);
    on<EditDetailMainProductClickedEvent>(editDetailMainProductClickedEvent);
    on<DeletePriceEntriesClickedEvent>(deletePriceEntriesClickedEvent);
  }

  Future<FutureOr<void>> detailInitialEvent(
      DetailInitialEvent event, Emitter<DetailState> emit) async {
    try {
      DetailProductData detailProduct =
          await ApiServiceProducts().getDetailProduct(event.productId);
      emit(DetailLoadedSuccessState(detailProduct: detailProduct));
    } catch (e) {
      String failToken = e.toString();
      if (failToken.startsWith('Exception: ')) {
        failToken = failToken.substring('Exception: '.length);
      }
      emit(DetailErrorState(errorMessage: failToken));
    }
  }

  FutureOr<void> detailErrorScreenToLoginEvent(
      DetailErrorScreenToLoginEvent event, Emitter<DetailState> emit) {
    emit(DetailErrorScreenToLoginState());
  }

  FutureOr<void> detailProductClickedEvent(
      DetailProductClickedEvent event, Emitter<DetailState> emit) {
    emit(DetailProductClickedState(productId: event.productId));
  }

  // Chỉnh sửa thông tin chính
  Future<void> editDetailMainProductClickedEvent(
      EditDetailMainProductClickedEvent event, Emitter<DetailState> emit) async {
    try {
      String message = await ApiServiceProducts().updateMainProduct(
        event.productId,
        event.code,
        event.name,
        event.specificProduct,
        event.unit,
        event.note,
      );
      emit(EditDetailMainProductClickedState(message: message));
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      emit(DetailErrorState(errorMessage: errorMessage));
    }
  }

  Future<void> deletePriceEntriesClickedEvent(
      DeletePriceEntriesClickedEvent event, Emitter<DetailState> emit) async {
    try {
      print('Xóa sản phẩm');
      print(event.idPriceEntries);
      String message = await ApiServicePriceEntries().deletePriceEntries(event.idPriceEntries);
      emit(DeletePriceEntriesClickedState(message: message));
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      emit(DetailErrorState(errorMessage: errorMessage));
    }
  }
}