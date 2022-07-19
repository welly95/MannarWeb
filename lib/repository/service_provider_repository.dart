import '../../models/quick_chat_model.dart';
import '../../models/quick_chat_user_model.dart';

import 'web_services.dart';

import '../models/service_provider.dart';

class ServiceProviderRepository {
  final WebServices webServices;
  ServiceProviderRepository(this.webServices);

  Future<bool> serviceProviderLogin(String email, String password) async {
    bool statusOfLogin = await webServices.loginLawyer(email, password);
    print('Status from repo ServiceProviderLogin is --------->' + statusOfLogin.toString());
    return statusOfLogin;
  }

  Future<ServiceProvider> getServiceProviderProfile(String token) async {
    ServiceProvider serviceProvider = await webServices.getLawyerProfile(token);
    print('serviceProvider from repo getServiceProviderProfile is --------->' + serviceProvider.toString());
    return serviceProvider;
  }

  Future<bool> sendLawyerQuickMessage(String token, String message, String userId) async {
    bool statusOfSendingLawyerQuickMessage = await webServices.sendLawyerQuickMessage(token, message, userId);
    print('Status from repo sendLawyerQuickMessage is --------->' + statusOfSendingLawyerQuickMessage.toString());
    return statusOfSendingLawyerQuickMessage;
  }

  Future<bool> updateAvailableForServiceProvider(String token, String statusNumber) async {
    bool statusOfupdateAvailableForServiceProvider =
        await webServices.updateAvailableForServiceProvider(token, statusNumber);
    print('Status from repo updateAvailableForServiceProvider is --------->' +
        statusOfupdateAvailableForServiceProvider.toString());
    return statusOfupdateAvailableForServiceProvider;
  }

  Future<List<QuickChatUserModel>> getQuickChatUser(String token) async {
    final quickChatUsers = await webServices.getQuickChatUsers(token);
    return quickChatUsers.map((quickChatUserModel) => QuickChatUserModel.fromJson(quickChatUserModel)).toList();
  }

  Future<List<QuickChatModel>> getQuickChatForLawyer(String token, String userId) async {
    final quickChatForLawyer = await webServices.getQuickChatForLawyer(token, userId);
    return quickChatForLawyer.map((quickChatModel) => QuickChatModel.fromJson(quickChatModel)).toList();
  }

  Future<bool> stopQuickChat(String token, String userId) async {
    bool statusOfStoppingQuickChat = await webServices.stopQuickChat(token, userId);
    print('Status from repo stopQuickChat is --------->' + statusOfStoppingQuickChat.toString());
    return statusOfStoppingQuickChat;
  }
}
