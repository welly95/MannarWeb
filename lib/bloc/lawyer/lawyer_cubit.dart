import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/lawyers.dart';
import '../../repository/lawyer_repository.dart';

part 'lawyer_state.dart';

class LawyerCubit extends Cubit<LawyerState> {
  final LawyerRepository lawyerRepo;
  List<Lawyer> lawyers = [];
  List<Lawyer> suggetionsLawyers = [];
  List<Lawyer> filteredLawyers = [];
  LawyerCubit(this.lawyerRepo) : super(LawyerInitial());

  Future<List<Lawyer>> getLawyersList(String lawyerName) async {
    await lawyerRepo.getLawyers(lawyerName).then((lawyers) {
      emit(GetLawyersState(lawyers));
      this.lawyers = lawyers;
    });
    return lawyers;
  }

  Future<List<Lawyer>> getSuggetionsLawyersList(int subId) async {
    await lawyerRepo.getSuggetionsLawyers(subId).then((lawyers) {
      emit(GetSuggetionsLawyersState(lawyers));
      this.suggetionsLawyers = lawyers;
    });
    return suggetionsLawyers;
  }

  Future<List<Lawyer>> getSuggetionsLawyersListByCourts(int subId) async {
    await lawyerRepo.getSuggetionsLawyersByCourts(subId).then((lawyers) {
      emit(GetSuggetionsLawyersByCourtsState(lawyers));
      this.suggetionsLawyers = lawyers;
    });
    return suggetionsLawyers;
  }

  Future<List<Lawyer>> getFilteredLawyersList(
      String country, String city, String type, List<int> mainDepartments, List<int> specialists) async {
    await lawyerRepo.filteredLawyers(country, city, type, mainDepartments, specialists).then((lawyers) {
      emit(GetFilteredLawyersState(lawyers));

      this.filteredLawyers = lawyers;
    });
    return filteredLawyers;
  }
}
