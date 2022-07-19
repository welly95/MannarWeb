part of 'lawyer_cubit.dart';

abstract class LawyerState extends Equatable {
  const LawyerState();

  @override
  List<Object> get props => [];
}

class LawyerInitial extends LawyerState {}

class GetLawyersState extends LawyerState {
  final List<Lawyer> lawyerList;
  GetLawyersState(this.lawyerList);
}

class GetSuggetionsLawyersState extends LawyerState {
  final List<Lawyer> suggetionLawyer;
  GetSuggetionsLawyersState(this.suggetionLawyer);
}

class GetSuggetionsLawyersByCourtsState extends LawyerState {
  final List<Lawyer> suggetionLawyer;
  GetSuggetionsLawyersByCourtsState(this.suggetionLawyer);
}

class GetFilteredLawyersState extends LawyerState {
  final List<Lawyer> filteredLawyers;
  GetFilteredLawyersState(this.filteredLawyers);
}
