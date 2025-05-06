// import 'package:flutter/material.dart';
// import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart'; 
// import 'package:quanly_sp_teca_fe/size_config.dart';

// void showFilterDialog(
//   BuildContext context,
//   List<ProductPriceModel> products,
//   String selectedBrand,
//   String selectedProvider,
//   Function(String, String) onApply,
// ) {
//   String tempBrand = selectedBrand;
//   String tempProvider = selectedProvider;

//   showModalBottomSheet(
//     context: context,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (_) => Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade50, Colors.white],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             "Lọc sản phẩm",
//             style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue.shade900,
//                 ),
//           ),
//           SizedBox(height: getProportionateScreenHeight(16)),
//           DropdownButtonFormField<String>(
//             value: tempBrand,
//             items: [
//               const DropdownMenuItem(value: 'Tất cả', child: Text('Tất cả')),
//               ...products
//                   .map((p) => p.brand ?? '')
//                   .toSet()
//                   .map((e) => DropdownMenuItem(value: e, child: Text(e))),
//             ],
//             onChanged: (val) => tempBrand = val!,
//             decoration: InputDecoration(
//               labelText: "Lọc theo nhãn hiệu",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//           ),
//           SizedBox(height: getProportionateScreenHeight(16)),
//           DropdownButtonFormField<String>(
//             value: tempProvider,
//             items: [
//               const DropdownMenuItem(value: 'Tất cả', child: Text('Tất cả')),
//               ...products.map((p) => p.supplier ?? '').toSet().map((e) {
//                 return DropdownMenuItem(
//                   value: e, // Giữ nguyên giá trị gốc
//                   child: Text(
//                     truncateWithEllipsis(20, e), // Cắt ngắn văn bản hiển thị
//                     style: const TextStyle(
//                       fontSize: 14, // Đảm bảo kích thước chữ phù hợp
//                       overflow: TextOverflow.ellipsis, // Đề phòng trường hợp vẫn overflow
//                     ),
//                   ),
//                 );
//               }),
//             ],
//             onChanged: (val) => tempProvider = val!,
//             decoration: InputDecoration(
//               labelText: "Nhà cung cấp",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               filled: true,
//               fillColor: Colors.white,
//             ),
//           ),
//           SizedBox(height: getProportionateScreenHeight(24)),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue.shade700,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//             ),
//             onPressed: () {
//               onApply(tempBrand, tempProvider);
//               Navigator.pop(context);
//             },
//             child: const Text(
//               "Áp dụng",
//               style: TextStyle(fontSize: 16, color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// // Hàm truncateWithEllipsis để cắt ngắn văn bản
// String truncateWithEllipsis(int cutoff, String text) {
//   return (text.length <= cutoff) ? text : '${text.substring(0, cutoff)}...';
// }



import 'package:flutter/material.dart';
import 'package:quanly_sp_teca_fe/model/product_price/product_price_model.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

void showFilterDialog(
  BuildContext context,
  List<ProductPriceModel> products,
  String selectedSortOption,
  Function(String) onApply,
) {
  String tempSortOption = selectedSortOption;
  final sortOptions = [
    'Không sắp xếp',
    'Sắp xếp theo ngày (gần nhất trước)',
  ];

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Lọc theo tiêu chí",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
          ),
          SizedBox(height: getProportionateScreenHeight(16)),
          DropdownButtonFormField<String>(
            value: tempSortOption,
            items: sortOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ))
                .toList(),
            onChanged: (val) => tempSortOption = val!,
            decoration: InputDecoration(
              labelText: "Sắp xếp theo",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(24)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () {
              onApply(tempSortOption);
              Navigator.pop(context);
            },
            child: const Text(
              "Áp dụng",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}