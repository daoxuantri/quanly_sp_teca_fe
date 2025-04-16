import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quanly_sp_teca_fe/api/products.dart';
import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';


part 'detail_event.dart';

part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc() : super(DetailInitial()) {
    on<DetailInitialEvent>(detailInitialEvent);
    on<DetailErrorScreenToLoginEvent>(detailErrorScreenToLoginEvent);
    on<DetailProductClickedEvent>(detailProductClickedEvent);
  }

  Future<FutureOr<void>> detailInitialEvent(
      DetailInitialEvent event, Emitter<DetailState> emit) async {
    emit(DetailLoadingState());
    try {
      ProductDataModel detailProduct = await ApiServiceProducts().getDetailProduct(event.productId);
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

}
