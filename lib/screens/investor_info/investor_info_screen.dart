import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quanly_sp_teca_fe/components_buttons/snackbar.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';
import 'package:quanly_sp_teca_fe/screens/investor_info/bloc/investor_info_bloc.dart';
import 'package:quanly_sp_teca_fe/size_config.dart';

class InvestorInfoScreen extends StatefulWidget {
  static String routeName = "/investor-info";

  const InvestorInfoScreen({super.key});

  @override
  State<InvestorInfoScreen> createState() => _InvestorInfoScreenState();
}

class _InvestorInfoScreenState extends State<InvestorInfoScreen> {
  final InvestorInfoBloc investorInfoBloc = InvestorInfoBloc();

  @override
  void initState() {
    super.initState();
    investorInfoBloc.add(InvestorInfoInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BlocConsumer<InvestorInfoBloc, InvestorInfoState>(
      bloc: investorInfoBloc,
      listenWhen: (previous, current) => current is InvestorInfoActionState,
      buildWhen: (previous, current) => current is! InvestorInfoActionState,
      listener: (context, state) {
        if (state is InvestorInfoSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBarLoginSuccess(state.message),
          );
        } else if (state is InvestorInfoErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ ${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is InvestorInfoLoadingState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Quản lý dự án' ,style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            ),
            body: const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            ),
          );
        } else if (state is InvestorInfoErrorState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Quản lý dự án',style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            ),
            body: Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          );
        }

        List<InvestorInfoModel> projects = [];
        if (state is InvestorInfoLoadedState) {
          projects = state.projects;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Quản lý dự án',style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue.shade700,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddProjectDialog(context),
            backgroundColor: Colors.blue.shade700,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: projects.isEmpty
                ? const Center(
                    child: Text(
                      'Không có dự án nào',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : AnimatedList(
                    initialItemCount: projects.length,
                    itemBuilder: (context, index, animation) {
                      final project = projects[index];
                      return FadeTransition(
                        opacity: animation,
                        child: _buildProjectCard(context, project),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  Widget _buildProjectCard(BuildContext context, InvestorInfoModel project) {
    // Định dạng ngày giao hàng thành DD/MM/YYYY
    String formattedDate = 'Không có';
    if (project.deliveryDate != null) {
      try {
        final date = DateTime.parse(project.deliveryDate!);
        formattedDate = DateFormat('dd/MM/yyyy').format(date);
      } catch (e) {
        formattedDate = project.deliveryDate!;
      }
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          project.projectName ?? 'Không có tên',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Ngày giao: $formattedDate',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditProjectDialog(context, project),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDeleteProject(context, project),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Thêm dự án mới',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên dự án',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Ngày giao hàng (YYYY-MM-DD)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty || dateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng nhập đầy đủ thông tin'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      // Kiểm tra định dạng ngày YYYY-MM-DD
                      final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                      if (!datePattern.hasMatch(dateController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ngày giao hàng phải có định dạng YYYY-MM-DD'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      investorInfoBloc.add(InvestorInfoAddProjectEvent(
                        projectName: nameController.text,
                        deliveryDate: dateController.text,
                      ));
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Thêm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProjectDialog(BuildContext context, InvestorInfoModel project) {
    final nameController = TextEditingController(text: project.projectName);
    final dateController = TextEditingController(text: project.deliveryDate);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chỉnh sửa dự án',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Tên dự án',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: 'Ngày giao hàng (YYYY-MM-DD)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty || dateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vui lòng nhập đầy đủ thông tin'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      // Kiểm tra định dạng ngày YYYY-MM-DD
                      final datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                      if (!datePattern.hasMatch(dateController.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Ngày giao hàng phải có định dạng YYYY-MM-DD'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      investorInfoBloc.add(InvestorInfoUpdateProjectEvent(
                        projectId: project.id!,
                        projectName: nameController.text,
                        deliveryDate: dateController.text,
                      ));
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cập nhật'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteProject(BuildContext context, InvestorInfoModel project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa dự án này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              investorInfoBloc.add(InvestorInfoDeleteProjectEvent(
                projectId: project.id!,
                projectName: project.projectName ?? '',
                deliveryDate: project.deliveryDate ?? '',
              ));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}