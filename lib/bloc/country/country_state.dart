part of 'country_cubit.dart';

abstract class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object> get props => [];
}

class CountryInitial extends CountryState {}

class GetCountriesListState extends CountryState {
  final List<Countries> countries;
  GetCountriesListState(this.countries);
}
