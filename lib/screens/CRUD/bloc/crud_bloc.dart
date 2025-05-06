import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/product_price.dart';
part 'crud_event.dart';
part 'crud_state.dart';

class CRUDBloc extends Bloc<CRUDEvent, CRUDState> {
  CRUDBloc() : super(CRUDInitial()) {
    on<CRUDInitialEvent>(crudInitialEvent);
    on<CRUDErrorScreenToLoginEvent>(crudErrorScreenToLoginEvent);
    on<CRUDProductClickedEvent>(crudProductClickedEvent);
    on<CRUDAddProductClickedEvent>(crudAddProductClickedEvent);
    on<CRUDInitialScreenEvent>(crudInitialScreenEvent);
  }

  Future<FutureOr<void>> crudInitialEvent(
      CRUDInitialEvent event, Emitter<CRUDState> emit) async {
    emit(CRUDLoadingState());
    
    try {
      // List<ProductDataModel> listproduct = await ApiServiceProducts().getAllProduct();
      // emit(CRUDLoadedSuccessState(listproduct: listproduct));
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


  FutureOr<void> crudInitialScreenEvent(
      CRUDInitialScreenEvent event, Emitter<CRUDState> emit) {
    emit(CRUDLoadingState());
    try{
       emit(CRUDInitialScreenState());
    }catch(e){

    }
  }

  Future<FutureOr<void>> crudAddProductClickedEvent(
      CRUDAddProductClickedEvent event, Emitter<CRUDState> emit) async {
    emit(CRUDLoadingState());
    try {
      String message = await ApiServiceProductPrice().addProductPrice(
        event.code, event.name, event.specific_product,event.unit, event.price,event.price_date,
        event.origin, event.brand, event.supplier,event.asker, event.note
      );
      emit(CRUDAddProductClickedState(message: message));
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('Phiên đăng nhập hết hạn')) {
        emit(CRUDErrorScreenToLoginState());
      } else {
        emit(CRUDErrorState(errorMessage: errorMessage));
      }
    }
  }
}