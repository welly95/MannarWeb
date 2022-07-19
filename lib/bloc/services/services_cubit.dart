import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mannar_web/models/notifications.dart';
import 'package:mannar_web/models/rateService.dart';
import 'package:mannar_web/models/techMessages.dart';
import '../../models/aboutUsModel.dart';
import '../../models/filter_data.dart';
import '../../models/sliders.dart';
import '../../repository/services_repository.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  FilterData filterData = FilterData();
  final ServicesRepo servicesRepo;
  AboutUsModel aboutUsModel = AboutUsModel();
  bool statusOfMessage = false;
  bool statusOfLogOut = false;
  bool statusOfRate = false;
  bool statusOfSendingTechMessage = false;
  List<Notifications> statusOfNotifi = [];
  List<Sliders> slidersList = [];
  List<RateService> rateServiceList = [];
  List<TechMessages> techMessages = [];

  ServicesCubit(this.servicesRepo) : super(ServicesInitial());

  Future<FilterData> getFilterData() async {
    await servicesRepo.filterData().then((jsonService) {
      emit(GetFilterData(jsonService));
      this.filterData = jsonService;
    });
    return filterData;
  }

  Future<bool> contactUsSendingMessage(String message, String token) async {
    await servicesRepo.contactUsSendingMessage(message, token).then((jsonService) {
      emit(ContactUsSendingMessageState(jsonService));
      this.statusOfMessage = jsonService;
    });
    return statusOfMessage;
  }

  Future<AboutUsModel> getAboutUs() async {
    await servicesRepo.getAboutUs().then((jsonService) {
      emit(GetAboutUsState(jsonService));
      this.aboutUsModel = jsonService;
    });
    return aboutUsModel;
  }

  Future<bool> logOut(String token) async {
    await servicesRepo.logOut(token).then((statusOfLogOut) {
      emit(LogOutState(statusOfLogOut));
      this.statusOfLogOut = statusOfLogOut;
    });
    return statusOfLogOut;
  }

  Future<bool> logOutLawyer(String token) async {
    await servicesRepo.logOutLawyer(token).then((statusOfLogOut) {
      emit(LogOutLawyerState(statusOfLogOut));
      this.statusOfLogOut = statusOfLogOut;
    });
    return statusOfLogOut;
  }

  Future<bool> rateAndCOmment(
      String token, String lawyerId, String lawyerRate, String serviceRate, String appRate, String comment) async {
    await servicesRepo.rateAndComment(token, lawyerId, lawyerRate, serviceRate, appRate, comment).then((statusOfRate) {
      emit(RateAndCommentState(statusOfRate));
      this.statusOfRate = statusOfRate;
    });
    return statusOfRate;
  }

  Future<List<Sliders>> getSliders() async {
    await servicesRepo.getSliders().then((slider) {
      emit(GetSlidersState(slider));
      this.slidersList = slider;
    });
    return slidersList;
  }

  Future<List<RateService>> getRateServices() async {
    await servicesRepo.getRateService().then((rateList) {
      emit(GetRateServicesState(rateList));
      this.rateServiceList = rateList;
    });
    return rateServiceList;
  }

  Future<List<Notifications>> getNotications(String token) async {
    await servicesRepo.getNotifications(token).then((statusOfNotifi) {
      emit(GetNotificationsState(statusOfNotifi));
      this.statusOfNotifi = statusOfNotifi;
    });
    return statusOfNotifi;
  }

  Future<List<TechMessages>> getTechMessages(String token) async {
    await servicesRepo.getTechMessages(token).then((messages) {
      emit(GetTechMessagesState(messages));
      this.techMessages = messages;
    });
    return techMessages;
  }

  Future<bool> sendTechMessage(String token, String message) async {
    await servicesRepo.sendTechMesage(token, message).then((statusOfSending) {
      emit(SendTechMessagesState(statusOfSending));
      this.statusOfSendingTechMessage = statusOfSending;
    });
    return statusOfSendingTechMessage;
  }
}
