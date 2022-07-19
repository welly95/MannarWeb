part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserRegisterState extends UserState {
  final bool statusOfRegister;
  UserRegisterState(this.statusOfRegister);
}

class UserVerificationOTPState extends UserState {
  final bool statusOfVerification;
  UserVerificationOTPState(this.statusOfVerification);
}

class UserResendingOTPState extends UserState {
  final bool statusOfResendingOTP;
  UserResendingOTPState(this.statusOfResendingOTP);
}

class UserLoginState extends UserState {
  final bool statusOfLogin;
  UserLoginState(this.statusOfLogin);
}

class GetProfileUserState extends UserState {
  final User user;
  GetProfileUserState(this.user);
}

class CompleteProfileState extends UserState {
  final bool statusOfEditing;
  CompleteProfileState(this.statusOfEditing);
}

class ChangePasswordState extends UserState {
  final bool status;
  ChangePasswordState(this.status);
}

class ForgetPasswordState extends UserState {
  final bool status;
  ForgetPasswordState(this.status);
}

class ResetPasswordState extends UserState {
  final bool status;
  ResetPasswordState(this.status);
}

class EditProfileState extends UserState {
  final bool statusOfEditing;
  EditProfileState(this.statusOfEditing);
}

class SendUserQuickChatState extends UserState {
  final bool statusOfUserSendingQuickChat;
  SendUserQuickChatState(this.statusOfUserSendingQuickChat);
}

class GetAvailableLawyersState extends UserState {
  final Lawyer lawyer;
  GetAvailableLawyersState(this.lawyer);
}

class GetQuickChatForUser extends UserState {
  final List<QuickChatModel> quickChatModel;
  GetQuickChatForUser(this.quickChatModel);
}
