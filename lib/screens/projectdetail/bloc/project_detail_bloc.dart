// import 'package:bloc/bloc.dart';
// import 'package:quanly_sp_teca_fe/api/product_investor.dart';
// import 'package:quanly_sp_teca_fe/model/product_investor/product_investor_model.dart';
// import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';

// part 'project_detail_event.dart';
// part 'project_detail_state.dart';

// class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
//   final ApiServiceProductInvestor _productApi = ApiServiceProductInvestor();

//   ProjectDetailBloc() : super(ProjectDetailInitial()) {
//     on<ProjectDetailInitialEvent>(_onInitial);
//     on<ProjectDetailFetchProductsEvent>(_onFetchProducts);
//     on<ProjectDetailFetchPriceEntriesEvent>(_onFetchPriceEntries);
//     on<ProjectDetailAddProductEvent>(_onAddProduct);
//     on<ProjectDetailDeleteProductEvent>(_onDeleteProduct);
//     on<ProjectDetailCancelAddProductEvent>(_onCancelAddProduct);
//   }

//   Future<void> _onInitial(
//       ProjectDetailInitialEvent event, Emitter<ProjectDetailState> emit) async {
//     emit(ProjectDetailLoadingState());
//     try {
//       final products = await _productApi.getProductsByInvestor(event.projectId);
//       emit(ProjectDetailProductsLoadedState(products: products));
//     } catch (e) {
//       emit(ProjectDetailErrorState(
//           errorMessage: 'Lỗi khi tải danh sách sản phẩm: $e'));
//     }
//   }

//   Future<void> _onFetchProducts(ProjectDetailFetchProductsEvent event,
//       Emitter<ProjectDetailState> emit) async {
//     emit(ProjectDetailLoadingState());
//     try {
//       final products = await _productApi.getProductsByInvestor(event.projectId);
//       emit(ProjectDetailProductsLoadedState(products: products));
//     } catch (e) {
//       emit(ProjectDetailErrorState(
//           errorMessage: 'Không thể tải danh sách sản phẩm: $e'));
//     }
//   }

//   Future<void> _onFetchPriceEntries(ProjectDetailFetchPriceEntriesEvent event,
//       Emitter<ProjectDetailState> emit) async {
//     emit(ProjectDetailLoadingState());
//     try {
//       final priceEntries = await _productApi.getPriceEntries();
//       final products =
//           await _productApi.getProductsByInvestor(event.projectId!);
//       emit(ProjectDetailPriceEntriesLoadedState(
//         priceEntries: priceEntries,
//         products: products,
//       ));
//     } catch (e) {
//       emit(ProjectDetailPriceEntriesErrorState(
//           errorMessage: 'Không thể tải danh sách giá: $e'));
//     }
//   }

//   Future<void> _onAddProduct(ProjectDetailAddProductEvent event,
//       Emitter<ProjectDetailState> emit) async {
//     emit(ProjectDetailLoadingState());
//     try {
//       final message = await _productApi.createProductInvestor(
//         event.idInvestor,
//         event.priceEntriesId,
//         event.priceNhap,
//         event.priceBan,
//         event.quantity,
//       );
//       print('Product added successfully: $message');

//       // Optional: Add a slight delay to ensure backend sync
//       await Future.delayed(const Duration(milliseconds: 500));

//       final products =
//           await _productApi.getProductsByInvestor(event.idInvestor);
//       print(
//           'Fetched products for idInvestor ${event.idInvestor}: ${products.length} products');
//       print('Products: ${products.map((p) => p.toJson()).toList()}');

//       emit(ProjectDetailProductsLoadedState(products: products, successMessage: message));
//     } catch (e) {
//       print('Error adding product: $e');
//       emit(
//           ProjectDetailErrorState(errorMessage: 'Không thể thêm sản phẩm: $e'));
//     }
//   }

//   Future<void> _onDeleteProduct(ProjectDetailDeleteProductEvent event,
//       Emitter<ProjectDetailState> emit) async {
//     emit(ProjectDetailLoadingState());
//     try {
//       final message =
//           await _productApi.deleteProductInvestorById(event.productId);
//       final products = await _productApi.getProductsByInvestor(event.projectId);
//       emit(ProjectDetailProductsLoadedState(
//         products: products,
//         successMessage: message, // Thêm message vào trạng thái này nếu cần
//       ));
//     } catch (e) {
//       emit(ProjectDetailErrorState(errorMessage: 'Không thể xóa sản phẩm: $e'));
//     }
//   }

//   Future<void> _onCancelAddProduct(ProjectDetailCancelAddProductEvent event,
//       Emitter<ProjectDetailState> emit) async {
//     final currentState = state;
//     if (currentState is ProjectDetailPriceEntriesLoadedState) {
//       emit(ProjectDetailProductsLoadedState(products: currentState.products));
//     }
//   }
// }



import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/product_investor.dart';
import 'package:quanly_sp_teca_fe/api/product_price.dart';
import 'package:quanly_sp_teca_fe/model/product_investor/product_investor_model.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';

part 'project_detail_event.dart';
part 'project_detail_state.dart';

class ProjectDetailBloc extends Bloc<ProjectDetailEvent, ProjectDetailState> {
  final ApiServiceProductInvestor _productApi = ApiServiceProductInvestor();
  final ApiServiceProductPrice _productPriceApi = ApiServiceProductPrice();

  ProjectDetailBloc() : super(ProjectDetailInitial()) {
    on<ProjectDetailInitialEvent>(_onInitial);
    on<ProjectDetailFetchProductsEvent>(_onFetchProducts);
    on<ProjectDetailFetchPriceEntriesEvent>(_onFetchPriceEntries);
    on<ProjectDetailAddProductEvent>(_onAddProduct);
    on<ProjectDetailDeleteProductEvent>(_onDeleteProduct);
    on<ProjectDetailCancelAddProductEvent>(_onCancelAddProduct);
    on<ProjectDetailCreateProductEvent>(_onCreateProduct);
  }

  Future<void> _onInitial(
      ProjectDetailInitialEvent event, Emitter<ProjectDetailState> emit) async {
    emit(ProjectDetailLoadingState());
    try {
      final products = await _productApi.getProductsByInvestor(event.projectId);
      emit(ProjectDetailProductsLoadedState(products: products));
    } catch (e) {
      emit(ProjectDetailErrorState(
          errorMessage: 'Lỗi khi tải danh sách sản phẩm: $e'));
    }
  }

  Future<void> _onFetchProducts(ProjectDetailFetchProductsEvent event,
      Emitter<ProjectDetailState> emit) async {
    emit(ProjectDetailLoadingState());
    try {
      final products = await _productApi.getProductsByInvestor(event.projectId);
      emit(ProjectDetailProductsLoadedState(products: products));
    } catch (e) {
      emit(ProjectDetailErrorState(
          errorMessage: 'Không thể tải danh sách sản phẩm: $e'));
    }
  }

  Future<void> _onFetchPriceEntries(ProjectDetailFetchPriceEntriesEvent event,
      Emitter<ProjectDetailState> emit) async {
    emit(ProjectDetailLoadingState());
    try {
      final priceEntries = await _productApi.getPriceEntries();
      final products =
          await _productApi.getProductsByInvestor(event.projectId!);
      emit(ProjectDetailPriceEntriesLoadedState(
        priceEntries: priceEntries,
        products: products,
      ));
    } catch (e) {
      emit(ProjectDetailPriceEntriesErrorState(
          errorMessage: 'Không thể tải danh sách giá: $e'));
    }
  }

  Future<void> _onAddProduct(ProjectDetailAddProductEvent event,
      Emitter<ProjectDetailState> emit) async {
    emit(ProjectDetailLoadingState());
    try {
      final message = await _productApi.createProductInvestor(
        event.idInvestor,
        event.priceEntriesId,
        event.priceNhap,
        event.priceBan,
        event.quantity,
      );
      print('Product added successfully: $message');

      // Optional: Add a slight delay to ensure backend sync
      await Future.delayed(const Duration(milliseconds: 500));

      final products =
          await _productApi.getProductsByInvestor(event.idInvestor);
      print(
          'Fetched products for idInvestor ${event.idInvestor}: ${products.length} products');
      print('Products: ${products.map((p) => p.toJson()).toList()}');

      emit(ProjectDetailProductsLoadedState(products: products, successMessage: message));
    } catch (e) {
      print('Error adding product: $e');
      emit(
          ProjectDetailErrorState(errorMessage: 'Không thể thêm sản phẩm: $e'));
    }
  }

  Future<void> _onDeleteProduct(ProjectDetailDeleteProductEvent event,
      Emitter<ProjectDetailState> emit) async {
    emit(ProjectDetailLoadingState());
    try {
      final message =
          await _productApi.deleteProductInvestorById(event.productId);
      final products = await _productApi.getProductsByInvestor(event.projectId);
      emit(ProjectDetailProductsLoadedState(
        products: products,
        successMessage: message,
      ));
    } catch (e) {
      emit(ProjectDetailErrorState(errorMessage: 'Không thể xóa sản phẩm: $e'));
    }
  }

  Future<void> _onCancelAddProduct(ProjectDetailCancelAddProductEvent event,
      Emitter<ProjectDetailState> emit) async {
    final currentState = state;
    if (currentState is ProjectDetailPriceEntriesLoadedState) {
      emit(ProjectDetailProductsLoadedState(products: currentState.products));
    }
  }

  Future<void> _onCreateProduct(
      ProjectDetailCreateProductEvent event, Emitter<ProjectDetailState> emit) async {
    emit(ProjectDetailLoadingState());
    try {
      String message = await _productPriceApi.addProductPrice(
        event.code,
        event.name ?? '',
        event.specificProduct ?? '',
        event.unit ?? '',
        event.price ?? 0,
        event.priceDate ?? '01/01/2001',
        event.origin ?? '',
        event.brand ?? '',
        event.supplier ?? '',
        event.asker ?? '',
        event.note ?? '',
      );
      print('Product created successfully: $message');

      // Tải lại danh sách giá và sản phẩm
      final priceEntries = await _productApi.getPriceEntries();
      final products = await _productApi.getProductsByInvestor(event.projectId);

      emit(ProjectDetailCreateProductSuccessState(
        message: message,
        priceEntries: priceEntries,
        products: products,
      ));
    } catch (e) {
      print('Error creating product: $e');
      emit(ProjectDetailErrorState(errorMessage: 'Không thể tạo sản phẩm: $e'));
    }
  }
}
