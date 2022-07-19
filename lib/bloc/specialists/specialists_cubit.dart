import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/specialists_model.dart';
import '../../repository/specialists_repository.dart';

part 'specialists_state.dart';

class SpecialistsCubit extends Cubit<SpecialistsState> {
  final SpecialistsRepository specialistsRepo;
  List<SpecialistsModel> specialistsList = [];
  SpecialistsCubit(this.specialistsRepo) : super(SpecialistsInitial());

  Future<List<SpecialistsModel>> getSpecialists() async {
    await specialistsRepo.getSpecialists().then((specialists) {
      emit(GetSpecialistsState(specialists));
      this.specialistsList = specialists;
    });
    return specialistsList;
  }
}
