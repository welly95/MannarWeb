import 'web_services.dart';

import '../models/countries.dart';

class CountriesRepository {
  final WebServices webServices;
  CountriesRepository(this.webServices);

  Future<List<Countries>> getCountriesList() async {
    final countries = await webServices.getCountriesList();
    return countries.map((country) => Countries.fromJson(country)).toList();
    // print('Countries from repo getCountriesList is ------->' + countries.country![0].toString());
  }
}
