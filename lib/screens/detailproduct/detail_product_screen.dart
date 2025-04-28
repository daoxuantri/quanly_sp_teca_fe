// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
// import 'package:quanly_sp_teca_fe/screens/detailproduct/bloc/detail_bloc.dart';
// import 'package:quanly_sp_teca_fe/size_config.dart';
// import 'package:intl/intl.dart';

// class DetailProductScreen extends StatefulWidget {
//   static String routeName = '/detail-product';
//   const DetailProductScreen({super.key});

//   @override
//   State<DetailProductScreen> createState() => _DetailProductScreenState();
// }

// class _DetailProductScreenState extends State<DetailProductScreen> {
//   final DetailBloc detailBloc = DetailBloc();

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     final productId = ModalRoute.of(context)?.settings.arguments as int;
//     detailBloc.add(DetailInitialEvent(productId: productId));

//     return BlocConsumer<DetailBloc, DetailState>(
//       bloc: detailBloc,
//       listenWhen: (previous, current) => current is DetailActionState,
//       buildWhen: (previous, current) => current is! DetailActionState,
//       listener: (context, state) {},
//       builder: (context, state) {
//         if (state is DetailLoadingState) {
//           return const Center(child: LoadingScreen());
//         } else if (state is DetailLoadedSuccessState) {
//           final product = state.detailProduct;

//           return Scaffold(
//             appBar: AppBar(
//               title: const Text(
//                 'Chi Tiết Sản Phẩm',
//                 style: TextStyle(
//                   fontWeight: FontWeight.w600,
//                   fontSize: 20,
//                   color: Colors.white,
//                 ),
//               ),
//               centerTitle: true,
//               backgroundColor: Colors.teal.shade700,
//               foregroundColor: Colors.white,
//               elevation: 0,
//               flexibleSpace: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.teal.shade700, Colors.teal.shade500],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//               ),
//             ),
//             body: SingleChildScrollView(
//               padding: EdgeInsets.all(5),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Product Overview Section
//                   _buildSectionTitle('Thông Tin Sản Phẩm'),
//                   _buildInfoCard('Mã sản phẩm', product.code ?? 'Không có'),
//                   _buildInfoCard('Tên sản phẩm', product.name ?? 'Không có'),
//                   _buildInfoCard('Chi tiết sản phẩm',
//                       product.specificProduct ?? 'Không có thông tin'),
//                   _buildInfoCard('Đơn vị', product.unit ?? 'Không có'),
//                   _buildInfoCard('Ghi chú', product.note ?? 'Không có'),

//                   // Price Entries Section
//                   const SizedBox(height: 16),
//                   _buildSectionTitle('Lịch Sử Giá'),
//                   if (product.priceEntries?.isNotEmpty ?? false)
//                     ...product.priceEntries!.asMap().entries.map((entry) {
//                       final index = entry.key;
//                       final priceEntry = entry.value;
//                       return _buildPriceEntryCard(
//                         index + 1,
//                         priceEntry.price?.toDouble() ?? 0.0,
//                         priceEntry.supplier ?? 'Không có',
//                         priceEntry.priceDate,
//                         priceEntry.asker ?? 'Không có',
//                         priceEntry.origin ?? 'Không có',
//                         priceEntry.brand ?? 'Không có',
//                         priceEntry.note ?? 'Không có',
//                       );
//                     }).toList()
//                   else
//                     _buildEmptyCard('Chưa có thông tin giá'),
//                 ],
//               ),
//             ),
//           );
//         } else if (state is DetailErrorState) {
//           return Center(
//             child: Text(
//               state.errorMessage,
//               style: const TextStyle(color: Colors.red, fontSize: 16),
//             ),
//           );
//         } else {
//           return const Center(
//             child: Text(
//               'Đã xảy ra lỗi',
//               style: TextStyle(color: Colors.red, fontSize: 16),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: Colors.teal,
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard(String title, String value) {
//     bool isEmptyValue = value == 'Không có' || value == 'Không có thông tin';

//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: Icon(
//           Icons.label_important_outline,
//           color: Colors.teal.shade600,
//           size: 28,
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.w600,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Text(
//           value,
//           style: TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: 14,
//             color: isEmptyValue ? Colors.red.shade400 : Colors.grey.shade800,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildPriceEntryCard(
//     int index,
//     double price,
//     String supplier,
//     String? priceDate,
//     String asker,
//     String origin,
//     String brand,
//     String note,
//   ) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       child: ExpansionTile(
//         leading: CircleAvatar(
//           backgroundColor: Colors.teal.shade100,
//           child: Text(
//             '#$index',
//             style: TextStyle(
//               color: Colors.teal.shade800,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         title: Text(
//           '${price.toStringAsFixed(0)} VND',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: Colors.green.shade700,
//           ),
//         ),
//         subtitle: Text(
//           supplier,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey.shade600,
//           ),
//         ),
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildInfoRow('Ngày hỏi giá',
//                     priceDate != null
//                         ? DateFormat('dd/MM/yyyy')
//                             .format(DateTime.parse(priceDate))
//                         : 'Không có'),
//                 _buildInfoRow('Người hỏi giá', asker),
//                 _buildInfoRow('Xuất xứ', origin),
//                 _buildInfoRow('Thương hiệu', brand),
//                 _buildInfoRow('Ghi chú', note),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoRow(String label, String value) {
//     bool isEmptyValue = value == 'Không có' || value == 'Không có thông tin';
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isEmptyValue ? Colors.red.shade400 : Colors.grey.shade800,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEmptyCard(String message) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       margin: const EdgeInsets.symmetric(vertical: 6),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: Text(
//             message,
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey.shade600,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:quanly_sp_teca_fe/components_buttons/loading.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/screens/detailproduct/bloc/detail_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';
import 'package:intl/intl.dart';

class DetailProductScreen extends StatefulWidget {
  static String routeName = '/detail-product';
  const DetailProductScreen({super.key});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  final DetailBloc detailBloc = DetailBloc();
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  late TextEditingController _specificProductController;
  late TextEditingController _unitController;
  late TextEditingController _noteController;
  late FocusNode _codeFocusNode;
  late FocusNode _nameFocusNode;
  late FocusNode _specificProductFocusNode;
  late FocusNode _unitFocusNode;
  late FocusNode _noteFocusNode;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _nameController = TextEditingController();
    _specificProductController = TextEditingController();
    _unitController = TextEditingController();
    _noteController = TextEditingController();
    _codeFocusNode = FocusNode();
    _nameFocusNode = FocusNode();
    _specificProductFocusNode = FocusNode();
    _unitFocusNode = FocusNode();
    _noteFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _specificProductController.dispose();
    _unitController.dispose();
    _noteController.dispose();
    _codeFocusNode.dispose();
    _nameFocusNode.dispose();
    _specificProductFocusNode.dispose();
    _unitFocusNode.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

  void _unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context, int index) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Xác nhận xóa',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.teal),
        ),
        content: Text(
          'Bạn có chắc muốn xóa lịch sử giá số #$index?',
          style: TextStyle(color: Colors.grey.shade800),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.teal),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final productId = ModalRoute.of(context)?.settings.arguments as int;
    detailBloc.add(DetailInitialEvent(productId: productId));

    return BlocConsumer<DetailBloc, DetailState>(
      bloc: detailBloc,
      listenWhen: (previous, current) => current is DetailActionState,
      buildWhen: (previous, current) => current is! DetailActionState,
      listener: (context, state) {
        if (state is EditDetailMainProductClickedState) {
          final successState = state as EditDetailMainProductClickedState;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(successState.message),
          );
          setState(() {
            isEditing = false; // Thoát chế độ chỉnh sửa
            detailBloc.add(DetailInitialEvent(productId: productId));
          });
          
        }else if (state is DeletePriceEntriesClickedState){
          final successState = state as DeletePriceEntriesClickedState;
           ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(successState.message),
          );
          setState(() {
            detailBloc.add(DetailInitialEvent(productId: productId));
          });
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case DetailLoadingState:
            return Center(child: LoadingScreen());
          case DetailLoadedSuccessState:
            final successState = state as DetailLoadedSuccessState;

            _codeController.text = successState.detailProduct.code ?? '';
            _nameController.text = successState.detailProduct.name ?? '';
            _specificProductController.text = successState.detailProduct.specificProduct ?? '';
            _unitController.text = successState.detailProduct.unit ?? '';
            _noteController.text = successState.detailProduct.note ?? '';

            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: const Text(
                  'Chi tiết sản phẩm',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade700, Colors.teal.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(isEditing ? Icons.save : Icons.edit),
                    onPressed: () {
                      if (isEditing) {
                        if (_formKey.currentState!.validate()) {
                          detailBloc.add(EditDetailMainProductClickedEvent(
                            productId: productId,
                            code: _codeController.text,
                            name: _nameController.text,
                            specificProduct: _specificProductController.text,
                            unit: _unitController.text,
                            note: _noteController.text,
                          ));
                        }
                      } else {
                        setState(() {
                          isEditing = true;
                          _unfocus();
                        });
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                  ),
                  if (isEditing)
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          isEditing = false;
                          _codeController.text = successState.detailProduct.code ?? '';
                          _nameController.text = successState.detailProduct.name ?? '';
                          _specificProductController.text = successState.detailProduct.specificProduct ?? '';
                          _unitController.text = successState.detailProduct.unit ?? '';
                          _noteController.text = successState.detailProduct.note ?? '';
                          _unfocus();
                        });
                      },
                    ),
                ],
              ),
              body: SafeArea(
                child: GestureDetector(
                  onTap: _unfocus,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Thông Tin Sản Phẩm'),
                          _buildInfoCard('Mã sản phẩm', _codeController, isEditing, _codeFocusNode),
                          _buildInfoCard('Tên sản phẩm', _nameController, isEditing, _nameFocusNode),
                          _buildInfoCard('Chi tiết sản phẩm', _specificProductController, isEditing, _specificProductFocusNode),
                          _buildInfoCard('Đơn vị', _unitController, isEditing, _unitFocusNode),
                          _buildInfoCard('Ghi chú', _noteController, isEditing, _noteFocusNode),
                          const SizedBox(height: 16),
                          _buildSectionTitle('Lịch Sử Giá'),
                          if (successState.detailProduct.priceEntries?.isNotEmpty ?? false)
                            ...successState.detailProduct.priceEntries!.asMap().entries.map((entry) {
                              final index = entry.key;
                              final priceEntry = entry.value;
                              return _buildPriceEntryCard(
                                index + 1,
                                priceEntry.price?.toDouble() ?? 0.0,
                                priceEntry.supplier ?? 'Không có',
                                priceEntry.priceDate,
                                priceEntry.asker ?? 'Không có',
                                priceEntry.origin ?? 'Không có',
                                priceEntry.brand ?? 'Không có',
                                priceEntry.note ?? 'Không có',
                                priceEntry.id, // Giả định priceEntry có thuộc tính id
                              );
                            }).toList()
                          else
                            _buildEmptyCard('Chưa có thông tin giá'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          case DetailErrorState:
            final successState = state as DetailErrorState;
            return Center(
              child: Text(
                successState.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          default:
            return Center(child: LoadingScreen());
        }
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.teal,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, TextEditingController controller, bool isEditing, FocusNode focusNode) {
    bool isEmptyValue = controller.text.isEmpty || controller.text == 'Không có';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          Icons.label_important_outline,
          color: Colors.teal.shade600,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: isEditing
            ? TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  isDense: true,
                ),
                maxLines: title == 'Chi tiết sản phẩm' || title == 'Ghi chú' ? 2 : 1,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).nextFocus();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập $title';
                  }
                  return null;
                },
              )
            : Text(
                controller.text.isEmpty ? 'Không có' : controller.text,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: isEmptyValue ? Colors.red.shade400 : Colors.grey.shade800,
                ),
              ),
      ),
    );
  }

  Widget _buildPriceEntryCard(
    int index,
    double price,
    String supplier,
    String? priceDate,
    String asker,
    String origin,
    String brand,
    String note,
    int? priceEntryId, // Thêm tham số để lưu ID của priceEntry
  ) {
    return Slidable(
      key: ValueKey(index),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.26, // Độ rộng của nút xóa
        children: [
          SlidableAction(
            onPressed: (context) async {
              final confirm = await _showDeleteConfirmationDialog(context, index);
              if (confirm == true) {
                detailBloc.add(DeletePriceEntriesClickedEvent(
                  idPriceEntries: priceEntryId ?? 0,  // Gửi ID hoặc index
                ));
              }
            },
            backgroundColor: Colors.red.shade600,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Xóa',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ExpansionTile(
          leading: CircleAvatar(
            backgroundColor: Colors.teal.shade100,
            child: Text(
              '#$index',
              style: TextStyle(
                color: Colors.teal.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            '${price.toStringAsFixed(0)} VND',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          subtitle: Text(
            supplier,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(
                      'Ngày hỏi giá',
                      priceDate != null
                          ? DateFormat('dd/MM/yyyy').format(DateTime.parse(priceDate))
                          : 'Không có'),
                  _buildInfoRow('Người hỏi giá', asker),
                  _buildInfoRow('Xuất xứ', origin),
                  _buildInfoRow('Thương hiệu', brand),
                  _buildInfoRow('Ghi chú', note),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    bool isEmptyValue = value == 'Không có' || value == 'Không có thông tin';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: isEmptyValue ? Colors.red.shade400 : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}