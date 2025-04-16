import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/products.dart';
import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';


part 'crud_event.dart';

part 'crud_state.dart';

class CRUDBloc extends Bloc<CRUDEvent, CRUDState> {
 CRUDBloc() : super(CRUDInitial()) {
    on<CRUDInitialEvent>(crudInitialEvent);
    on<CRUDErrorScreenToLoginEvent>(crudErrorScreenToLoginEvent);
    on<CRUDProductClickedEvent>(crudProductClickedEvent);
  }

  Future<FutureOr<void>> crudInitialEvent(
      CRUDInitialEvent event, Emitter<CRUDState> emit) async {
    emit(CRUDLoadingState());
    try {
      List<ProductDataModel> listproduct = await ApiServiceProducts().getAllProduct();
      emit(CRUDLoadedSuccessState(listproduct: listproduct));
    } catch (e) {
      String failToken = e.toString();
      if (failToken.startsWith('Exception: ')) {
        failToken = failToken.substring('Exception: '.length);
      }
      emit(CRUDErrorState(errorMessage: failToken));
    }
  }

  FutureOr<void> crudErrorScreenToLoginEvent(
      CRUDErrorScreenToLoginEvent event, Emitter<CRUDState> emit) {
    emit(CRUDErrorScreenToLoginState());
  }

  FutureOr<void> crudProductClickedEvent(
      CRUDProductClickedEvent event, Emitter<CRUDState> emit) {
    emit(CRUDProductClickedState(productId: event.productId));
  }

}
