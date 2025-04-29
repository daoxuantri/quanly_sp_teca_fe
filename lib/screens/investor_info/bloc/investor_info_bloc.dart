import 'package:bloc/bloc.dart';
import 'package:quanly_sp_teca_fe/api/investor_info.dart';
import 'package:quanly_sp_teca_fe/model/investor_info/investor_info_model.dart';

part 'investor_info_event.dart';
part 'investor_info_state.dart';

class InvestorInfoBloc extends Bloc<InvestorInfoEvent, InvestorInfoState> {
  InvestorInfoBloc() : super(InvestorInfoInitial()) {
    on<InvestorInfoInitialEvent>(investorInfoInitialEvent);
    on<InvestorInfoAddProjectEvent>(investorInfoAddProjectEvent);
    on<InvestorInfoUpdateProjectEvent>(investorInfoUpdateProjectEvent);
    on<InvestorInfoDeleteProjectEvent>(investorInfoDeleteProjectEvent);
  }

  Future<void> investorInfoInitialEvent(
      InvestorInfoInitialEvent event, Emitter<InvestorInfoState> emit) async {
    emit(InvestorInfoLoadingState());
    try {
      List<InvestorInfoModel> projects =
          await ApiServiceInvestorInfo().getAllInvestorInfo();
      emit(InvestorInfoLoadedState(projects: projects));
    } catch (e) {
      emit(InvestorInfoErrorState(errorMessage: 'Lỗi khi tải danh sách dự án: $e'));
    }
  }

  Future<void> investorInfoAddProjectEvent(
      InvestorInfoAddProjectEvent event, Emitter<InvestorInfoState> emit) async {
    emit(InvestorInfoLoadingState());
    try {
      final message = await ApiServiceInvestorInfo().createInvestorInfo(
        event.deliveryDate,
        event.projectName,
      );
      List<InvestorInfoModel> projects =
          await ApiServiceInvestorInfo().getAllInvestorInfo();
      emit(InvestorInfoLoadedState(projects: projects));
      emit(InvestorInfoSuccessState(message: message));
    } catch (e) {
      emit(InvestorInfoErrorState(errorMessage: 'Lỗi khi thêm dự án: $e'));
    }
  }

  Future<void> investorInfoUpdateProjectEvent(
      InvestorInfoUpdateProjectEvent event, Emitter<InvestorInfoState> emit) async {
    emit(InvestorInfoLoadingState());
    try {
      final message = await ApiServiceInvestorInfo().updateInvestorInfo(
        event.projectId,
        event.deliveryDate,
        event.projectName,
      );
      List<InvestorInfoModel> projects =
          await ApiServiceInvestorInfo().getAllInvestorInfo();
      emit(InvestorInfoLoadedState(projects: projects));
      emit(InvestorInfoSuccessState(message: message));
    } catch (e) {
      emit(InvestorInfoErrorState(errorMessage: 'Lỗi khi cập nhật dự án: $e'));
    }
  }

  Future<void> investorInfoDeleteProjectEvent(
      InvestorInfoDeleteProjectEvent event, Emitter<InvestorInfoState> emit) async {
    emit(InvestorInfoLoadingState());
    try {
      final message = await ApiServiceInvestorInfo().deleteInvestorInfo(
        event.projectId
      );
      List<InvestorInfoModel> projects =
          await ApiServiceInvestorInfo().getAllInvestorInfo();
      emit(InvestorInfoLoadedState(projects: projects));
      emit(InvestorInfoSuccessState(message: message));
    } catch (e) {
      emit(InvestorInfoErrorState(errorMessage: 'Lỗi khi xóa dự án: $e'));
    }
  }
}