part of 'courts_cubit.dart';

abstract class CourtsState extends Equatable {
  const CourtsState();

  @override
  List<Object> get props => [];
}

class CourtsInitial extends CourtsState {}

class GetCourtsState extends CourtsState {
  final List<Courts> courts;
  GetCourtsState(this.courts);
}
