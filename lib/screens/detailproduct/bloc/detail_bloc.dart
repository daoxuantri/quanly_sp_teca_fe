// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:quanly_sp_teca_fe/api/product_price.dart';
// import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';

// part 'detail_event.dart';
// part 'detail_state.dart';

// class DetailBloc extends Bloc<DetailEvent, DetailState> {
//   DetailBloc() : super(DetailInitial()) {
//     on<EditDetailMainProductClickedEvent>(editDetailMainProductClickedEvent);
//     on<DeleteProductClickedEvent>(deleteProductClickedEvent);
//   }

//   Future<void> editDetailMainProductClickedEvent(
//       EditDetailMainProductClickedEvent event, Emitter<DetailState> emit) async {
//     try {
//       String message = await ApiServiceProductPrice().updateDetailProductPrice(
//         event.productId,
//         event.code,
//         event.name,
//         event.specificProduct,
//         event.unit,
//         event.price,
//         event.priceDate,
//         event.origin,
//         event.brand,
//         event.supplier,
//         event.asker,
//         event.note,
//       );
//       emit(EditDetailMainProductClickedState(message: message));
//     } catch (e) {
//       String errorMessage = e.toString();
//       if (errorMessage.startsWith('Exception: ')) {
//         errorMessage = errorMessage.substring('Exception: '.length);
//       }
//       emit(DetailErrorState(errorMessage: errorMessage));
//     }
//   }

//   Future<void> deleteProductClickedEvent(
//       DeleteProductClickedEvent event, Emitter<DetailState> emit) async {
//     try {
//       String message = await ApiServiceProductPrice().deleteProductPrice(event.productId);
//       emit(DeleteProductClickedState(message: message));
//     } catch (e) {
//       String errorMessage = e.toString();
//       if (errorMessage.startsWith('Exception: ')) {
//         errorMessage = errorMessage.substring('Exception: '.length);
//       }
//       emit(DetailErrorState(errorMessage: errorMessage));
//     }
//   }
// }



import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/product_price.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc() : super(DetailInitial()) {
    on<EditDetailMainProductClickedEvent>(editDetailMainProductClickedEvent);
    on<DeleteProductClickedEvent>(deleteProductClickedEvent);
  }

  Future<void> editDetailMainProductClickedEvent(
      EditDetailMainProductClickedEvent event, Emitter<DetailState> emit) async {
    try {
      String message = await ApiServiceProductPrice().updateDetailProductPrice(
        event.productId,
        event.code,
        event.name ?? '',
        event.specificProduct ?? '',
        event.unit ?? '',
        event.price ?? 0, // Gán giá trị mặc định 0 nếu price là null
        event.priceDate ,
        event.origin ?? '',
        event.brand ?? '',
        event.supplier,
        event.asker,
        event.note ?? '',
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

  Future<void> deleteProductClickedEvent(
      DeleteProductClickedEvent event, Emitter<DetailState> emit) async {
    try {
      String message = await ApiServiceProductPrice().deleteProductPrice(event.productId);
      emit(DeleteProductClickedState(message: message));
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring('Exception: '.length);
      }
      emit(DetailErrorState(errorMessage: errorMessage));
    }
  }
}