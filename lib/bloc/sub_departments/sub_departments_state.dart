part of 'sub_departments_cubit.dart';

abstract class SubDepartmentsState extends Equatable {
  const SubDepartmentsState();

  @override
  List<Object> get props => [];
}

class SubDepartmentsInitial extends SubDepartmentsState {}

class GetSubDepartmentsFromMainState extends SubDepartmentsState {
  final List<SubDepartments> subDepartments;
  GetSubDepartmentsFromMainState(this.subDepartments);
}

class GetSubDepartmentsFromCourtState extends SubDepartmentsState {
  final List<SubDepartments> subDepartments;
  GetSubDepartmentsFromCourtState(this.subDepartments);
}

class GetQuestionsFromMainState extends SubDepartmentsState {
  final List<Questions> questions;
  GetQuestionsFromMainState(this.questions);
}

class GetQuestionsFromCourtState extends SubDepartmentsState {
  final List<Questions> questions;
  GetQuestionsFromCourtState(this.questions);
}
