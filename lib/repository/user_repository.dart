import '../../models/quick_chat_model.dart';

import '../models/lawyers.dart';
import 'web_services.dart';

import '../models/user.dart';

class UserRepository {
  final WebServices webServices;
  UserRepository(this.webServices);

  Future<bool> registerUser(String imageUrl, String name, String email, String phoneNumber, String password) async {
    bool statusOfRegister = await webServices.registerNewUser(imageUrl, name, email, phoneNumber, password);
    print('Status from repo RegisterUser is --------->' + statusOfRegister.toString());
    return statusOfRegister;
  }

  Future<bool> verifyOTP(String otp, String email, String password) async {
    bool statusOfVerification = await webServices.verifyOTP(otp, email, password);
    print('Status from repo verifyOTP is --------->' + statusOfVerification.toString());
    return statusOfVerification;
  }

  Future<bool> resendOTP(String phoneNumber) async {
    bool statusOfResending = await webServices.resendOTP(phoneNumber);
    print('Status from repo ResendingOTP is --------->' + statusOfResending.toString());
    return statusOfResending;
  }

  Future<bool> loginUser(String email, String password) async {
    bool statusOfLogin = await webServices.loginUser(email, password);
    print('Status from repo LoginUser is --------->' + statusOfLogin.toString());
    return statusOfLogin;
  }

  Future<User> getUserProfile(String token) async {
    User user = await webServices.getProfile(token);
    print('user from repo getUserProfile is --------->' + user.toString());
    return user;
  }

  Future<bool> completeProfile(String imageUrl, String name, String email, String phoneNumber, String age,
      String countryId, String token) async {
    bool statusOfEditing = await webServices.completeProfile(imageUrl, name, email, phoneNumber, age, countryId, token);
    print('Status from repo EditUser is --------->' + statusOfEditing.toString());
    return statusOfEditing;
  }

  Future<bool> changePassword(String oldPassword, String newPassword, String token) async {
    bool status = await webServices.changePassword(oldPassword, newPassword, token);
    print('Status from repo ChangePassword is --------->' + status.toString());
    return status;
  }

  Future<bool> forgetPassword(String phoneNumber, String token) async {
    bool status = await webServices.forgetPassword(phoneNumber, token);
    print('Status from repo forgetPassword is --------->' + status.toString());
    return status;
  }

  Future<bool> resetPassword(String code, String newPassword, String token) async {
    bool status = await webServices.resetPassword(code, newPassword, token);
    print('Status from repo resetPassword is --------->' + status.toString());
    return status;
  }

  Future<bool> editProfile(String imageUrl, String name, String email, String phoneNumber, String token) async {
    bool statusOfEditing = await webServices.editProfile(imageUrl, name, email, phoneNumber, token);
    print('Status from repo EditUser is --------->' + statusOfEditing.toString());
    return statusOfEditing;
  }

  Future<bool> sendUserQuickMessage(String token, String message, String lawyerId) async {
    bool statusOfUserSendingQuickMessage = await webServices.sendUserQuickMessage(token, message, lawyerId);
    print('Status from repo sendUserQuickMessage is --------->' + statusOfUserSendingQuickMessage.toString());
    return statusOfUserSendingQuickMessage;
  }

  Future<Lawyer> getAvailableLawyers(String token) async {
    Lawyer lawyer = await webServices.getAvailableLawyers(token);
    print('Status from repo getAvailableLawyers is --------->' + lawyer.toString());
    return lawyer;
  }

  Future<List<QuickChatModel>> getQuickChatForUser(String token) async {
    final quickChatForUser = await webServices.getQuickChatForUser(token);
    return quickChatForUser.map((quickChatModel) => QuickChatModel.fromJson(quickChatModel)).toList();
  }
}
