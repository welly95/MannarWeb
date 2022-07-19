part of 'specialists_cubit.dart';

abstract class SpecialistsState extends Equatable {
  const SpecialistsState();

  @override
  List<Object> get props => [];
}

class SpecialistsInitial extends SpecialistsState {}

class GetSpecialistsState extends SpecialistsState {
  final List<SpecialistsModel> specialists;
  GetSpecialistsState(this.specialists);
}
