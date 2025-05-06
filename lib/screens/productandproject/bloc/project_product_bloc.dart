import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/investor_info.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';

part 'project_product_event.dart';
part 'project_product_state.dart';

class ProjectProductBloc extends Bloc<ProjectProductEvent, ProjectProductState> {
  final ApiServiceInvestorInfo _investorApi = ApiServiceInvestorInfo();

  ProjectProductBloc() : super(ProjectProductInitial()) {
    on<ProjectProductInitialEvent>(_onInitial);
    on<ProjectProductAddProjectEvent>(_onAddProject);
    on<ProjectProductUpdateProjectEvent>(_onUpdateProject);
    on<ProjectProductDeleteProjectEvent>(_onDeleteProject);
  }

  Future<void> _onInitial(
      ProjectProductInitialEvent event, Emitter<ProjectProductState> emit) async {
    emit(ProjectProductLoadingState());
    try {
      final projects = await _investorApi.getAllInvestorInfo();
      emit(ProjectProductProjectsLoadedState(projects: projects));
    } catch (e) {
      emit(ProjectProductErrorState(errorMessage: 'Lỗi khi tải danh sách dự án: $e'));
    }
  }

  Future<void> _onAddProject(
      ProjectProductAddProjectEvent event, Emitter<ProjectProductState> emit) async {
    emit(ProjectProductLoadingState());
    try {
      final message = await _investorApi.createInvestorInfo(
        event.projectCode,
        event.name,
        event.startDate,
        event.endDate,
        event.supervisor,
        event.status,
      );
      final projects = await _investorApi.getAllInvestorInfo();
      emit(ProjectProductProjectsLoadedState(projects: projects));
      emit(ProjectProductSuccessState(message: message));
    } catch (e) {
      emit(ProjectProductErrorState(errorMessage: 'Lỗi khi thêm dự án: $e'));
    }
  }

  Future<void> _onUpdateProject(
      ProjectProductUpdateProjectEvent event, Emitter<ProjectProductState> emit) async {
    emit(ProjectProductLoadingState());
    try {
      final message = await _investorApi.updateInvestorInfo(
        event.projectId,
        event.projectCode,
        event.name,
        event.startDate,
        event.endDate,
        event.supervisor,
        event.status,
      );
      final projects = await _investorApi.getAllInvestorInfo();
      emit(ProjectProductProjectsLoadedState(projects: projects));
      emit(ProjectProductSuccessState(message: message));
    } catch (e) {
      emit(ProjectProductErrorState(errorMessage: 'Lỗi khi cập nhật dự án: $e'));
    }
  }

  Future<void> _onDeleteProject(
      ProjectProductDeleteProjectEvent event, Emitter<ProjectProductState> emit) async {
    emit(ProjectProductLoadingState());
    try {
      final message = await _investorApi.deleteInvestorInfo(event.projectId);
      final projects = await _investorApi.getAllInvestorInfo();
      emit(ProjectProductProjectsLoadedState(projects: projects));
      emit(ProjectProductSuccessState(message: message));
    } catch (e) {
      emit(ProjectProductErrorState(errorMessage: 'Lỗi khi xóa dự án: $e'));
    }
  }
}