import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
import 'package:quanly_sp_teca_fe/screens/detailproduct/bloc/detail_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class DetailProductScreen extends StatefulWidget {
  static String routeName = '/detail-product';
  const DetailProductScreen({super.key});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final DetailBloc detailBloc = DetailBloc();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final productId = ModalRoute.of(context)?.settings.arguments as int;
    detailBloc.add(DetailInitialEvent(productId: productId));

    return BlocConsumer<DetailBloc, DetailState>(
      bloc: detailBloc,
      listenWhen: (previous, current) => current is DetailActionState,
      buildWhen: (previous, current) => current is! DetailActionState,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DetailLoadingState) {
          return const Center(child: LoadingScreen());
        } else if (state is DetailLoadedSuccessState) {
          final product = state.detailProduct;

          return Scaffold(
            appBar: AppBar(
              title: const Text('Chi tiết sản phẩm', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),),
              backgroundColor: Colors.blue.shade700,
              elevation: 2,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16,5,16,16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard('Tên sản phẩm', product.name ?? 'Không có'),
                  _buildInfoCard('Mã sản phẩm', product.code ?? 'Không có'),
                  _buildInfoCard('Xuất xứ', product.origin ?? 'Không có'),
                  _buildInfoCard('Thương hiệu', product.brand ?? 'Không có'),
                  _buildInfoCard('Đơn vị', product.unit ?? 'Không có'),
                  _buildInfoCard('Ngày giá', product.priceDate ?? 'Không có'),
                  _buildInfoCard('Nhà cung cấp', product.supplier ?? 'Không có'),
                  _buildInfoCard('Ghi chú', product.note ?? 'Không có'),
                  _buildPriceCard(product.price?.toDouble() ?? 0.0),
                ],
              ),
            ),
          );
        } else if (state is DetailErrorState) {
          return Center(child: Text(state.errorMessage));
        } else {
          return const Center(child: Text('Đã xảy ra lỗi'));
        }
      },
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.label_important_outline, color: Colors.teal),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: TextStyle(fontWeight: FontWeight.w500),),
      ),
    );
  }

  Widget _buildPriceCard(double price) {
    return Card(
      color: Colors.green.shade100,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.monetization_on, color: Colors.green),
        title: const Text('Giá'),
        subtitle: Text(
          '${price.toStringAsFixed(0)} VND',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
        ),
      ),
    );
  }
}
