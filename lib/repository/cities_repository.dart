import 'web_services.dart';

import '../models/cities.dart';

class CitiesRepository {
  final WebServices webServices;
  CitiesRepository(this.webServices);

  Future<List<List<Cities>>> getCitiesList() async {
    final cities = await webServices.getCitiesList();
    return cities.map((citiesList) => citiesList.map((cities) => Cities.fromJson(cities)).toList()).toList();
    // print('Cities from repo getCitiesList is ------->' + cities.country![0].toString());
  }
}
