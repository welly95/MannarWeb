import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/cities.dart';
import '../../repository/cities_repository.dart';

part 'cities_state.dart';

class CitiesCubit extends Cubit<CitiesState> {
  final CitiesRepository citiesRepo;
  List<List<Cities>> citiesList = [];

  CitiesCubit(this.citiesRepo) : super(CitiesInitial());

  Future<List<List<Cities>>> getCitiesList() async {
    await citiesRepo.getCitiesList().then((cities) {
      emit(GetCitiesListState(cities));
      this.citiesList = cities;
    });
    return citiesList;
  }
}
