part of 'cities_cubit.dart';

abstract class CitiesState extends Equatable {
  const CitiesState();

  @override
  List<Object> get props => [];
}

class CitiesInitial extends CitiesState {}

class GetCitiesListState extends CitiesState {
  final List<List<Cities>> cities;
  GetCitiesListState(this.cities);
}
