import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/quick_chat_model.dart';
import '../../models/quick_chat_user_model.dart';
import '../../models/service_provider.dart';
import '../../repository/service_provider_repository.dart';

part 'service_provider_state.dart';

class ServiceProviderCubit extends Cubit<ServiceProviderState> {
  final ServiceProviderRepository serviceProviderRepo;
  ServiceProvider serviceProvider = ServiceProvider();
  bool statusOfLogin = false;
  bool statusOfSendingLawyerQuickChat = false;
  bool statusOfupdateAvailableForServiceProvider = false;
  bool statusOfStoppingQuickChat = false;
  List<QuickChatUserModel> quickChatUserModel = [];
  List<QuickChatModel> quickChatModel = [];

  ServiceProviderCubit(this.serviceProviderRepo) : super(ServiceProviderInitial());

  Future<bool> serviceProviderLogin(String email, String password) async {
    await serviceProviderRepo.serviceProviderLogin(email, password).then((jsonUser) {
      emit(ServiceProviderLoginState(jsonUser));
      this.statusOfLogin = jsonUser;
    });
    return statusOfLogin;
  }

  Future<ServiceProvider> getServiceProviderProfile(String token) async {
    await serviceProviderRepo.getServiceProviderProfile(token).then((jsonUser) {
      emit(GetServiceProviderProfileState(jsonUser));
      this.serviceProvider = jsonUser;
    });
    return serviceProvider;
  }

  Future<bool> sendLawyerQuickMessage(String token, String message, String userId) async {
    await serviceProviderRepo.sendLawyerQuickMessage(token, message, userId).then((jsonUser) {
      emit(SendLawyerQuickChatState(jsonUser));
      this.statusOfSendingLawyerQuickChat = jsonUser;
    });
    return statusOfSendingLawyerQuickChat;
  }

  Future<bool> updateAvailableForServiceProvider(String token, String statusNumber) async {
    await serviceProviderRepo.updateAvailableForServiceProvider(token, statusNumber).then((jsonUser) {
      emit(UpdateAvailableForServiceProviderState(jsonUser));
      this.statusOfupdateAvailableForServiceProvider = jsonUser;
    });
    return statusOfupdateAvailableForServiceProvider;
  }

  Future<List<QuickChatUserModel>> getQuickChatUsers(String token) async {
    await serviceProviderRepo.getQuickChatUser(token).then((quickChatUserModel) {
      emit(GetQuickChatUsersState(quickChatUserModel));
      this.quickChatUserModel = quickChatUserModel;
    });
    return quickChatUserModel;
  }

  Future<List<QuickChatModel>> getQuickChatForLawyer(String token, String userId) async {
    await serviceProviderRepo.getQuickChatForLawyer(token, userId).then((quickChatModel) {
      emit(GetQuickChatForLawyerState(quickChatModel));
      this.quickChatModel = quickChatModel;
    });
    return quickChatModel;
  }

  Future<bool> stopQuickChat(String token, String userId) async {
    await serviceProviderRepo.stopQuickChat(token, userId).then((statusOfStopping) {
      emit(StopQuickChatState(statusOfStopping));
      this.statusOfStoppingQuickChat = statusOfStopping;
    });
    return statusOfStoppingQuickChat;
  }
}
