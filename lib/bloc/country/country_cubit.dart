import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/countries.dart';
import '../../repository/countries_repository.dart';

part 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  final CountriesRepository countriesRepo;
  List<Countries> countryList = [];

  CountryCubit(this.countriesRepo) : super(CountryInitial());

  Future<List<Countries>> getCountriesList() async {
    await countriesRepo.getCountriesList().then((countries) {
      emit(GetCountriesListState(countries));
      this.countryList = countries;
    });
    return countryList;
  }
}
