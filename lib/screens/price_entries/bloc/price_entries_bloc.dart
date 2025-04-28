import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/price_entries.dart';
import 'package:quanly_sp_teca_fe/api/products.dart';
import 'package:quanly_sp_teca_fe/model/product/product_data_model.dart';

part 'price_entries_event.dart';
part 'price_entries_state.dart';

class PriceEntriesBloc extends Bloc<PriceEntriesEvent, PriceEntriesState> {
  PriceEntriesBloc() : super(PriceEntriesInitial()) {
    on<PriceEntriesLoadProductsEvent>(priceEntriesLoadProductsEvent);
    on<PriceEntriesSubmitEvent>(priceEntriesSubmitEvent);
  }

  Future<FutureOr<void>> priceEntriesLoadProductsEvent(
      PriceEntriesLoadProductsEvent event, Emitter<PriceEntriesState> emit) async {
    try {
      emit(PriceEntriesLoadingState());
      List<ProductDataModel> products = await ApiServiceProducts().getAllProduct();
      emit(PriceEntriesProductsLoadedState(products: products));
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      emit(PriceEntriesErrorState(errorMessage: errorMessage));
    }
  }

  Future<FutureOr<void>> priceEntriesSubmitEvent(
      PriceEntriesSubmitEvent event, Emitter<PriceEntriesState> emit) async {
    try {
      emit(PriceEntriesLoadingState());
      String message = await ApiServicePriceEntries().addPriceEntries(
        event.productId,
        event.price,
        event.origin,
        event.brand,
        event.supplier,
        event.priceDate,
        event.asker,
        event.note,
      );
      emit(PriceEntriesSuccessState(message: message));
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      emit(PriceEntriesErrorState(errorMessage: errorMessage));
    }
  }
}