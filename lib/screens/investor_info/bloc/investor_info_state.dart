part of 'investor_info_bloc.dart';

abstract class InvestorInfoState {
  const InvestorInfoState();
}

abstract class InvestorInfoActionState extends InvestorInfoState {}

class InvestorInfoInitial extends InvestorInfoState {}

class InvestorInfoLoadingState extends InvestorInfoState {}

class InvestorInfoSuccessState extends InvestorInfoActionState {
  final String message;
  InvestorInfoSuccessState({required this.message});
}

class InvestorInfoErrorState extends InvestorInfoActionState {
  final String errorMessage;
  InvestorInfoErrorState({required this.errorMessage});
}

class InvestorInfoLoadedState extends InvestorInfoState {
  final List<InvestorInfoModel> projects;
  const InvestorInfoLoadedState({required this.projects});
}