import 'package:bloc/bloc.dart';
import 'package:mannar_web/models/lawyers.dart';
import '../../models/quick_chat_model.dart';
import '../../models/user.dart';
import '../../repository/user_repository.dart';
import 'package:equatable/equatable.dart';
part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepo;
  User user = User();
  bool statusOfRegister = false;
  bool statusOfVerification = false;
  bool statusOfResendingOTP = false;
  bool statusOfLogin = false;
  bool statusOfChangingPassword = false;
  bool statusOfForgettingPassword = false;
  bool statusOfResettingPassword = false;
  bool statusOfEditing = false;
  bool statusOfUserSendingQuickChat = false;
Lawyer lawyer = Lawyer(
    id: 0,
    name: '',
    phone: '',
    email: '',
    countryId: 0,
    type: '',
    token: '',
    cityId: 0,
    bio: '',
    image: '',
    internalExternal: '',
    details: '',
    rate: 0,
    rateList: [],
    experience: '',
    licenseNum: 0,
    licenseDate: '',
    createdAt: '',
    updatedAt: '',
    imageurl: '',
    appointments: [],
    main: [],
    subs: [],
    specialists: [],
  );  List<QuickChatModel> quickChatModel = [];

  UserCubit(this.userRepo) : super(UserInitial());

  Future<bool> registerUser(String imageUrl, String name, String email, String phoneNumber, String password) async {
    await userRepo.registerUser(imageUrl, name, email, phoneNumber, password).then((jsonUser) {
      emit(UserRegisterState(jsonUser));
      this.statusOfRegister = jsonUser;
    });
    return statusOfRegister;
  }

  Future<bool> verifiyOTP(String otp, String email, String password) async {
    await userRepo.verifyOTP(otp, email, password).then((jsonUser) {
      emit(UserVerificationOTPState(jsonUser));
      this.statusOfVerification = jsonUser;
    });
    return statusOfVerification;
  }

  Future<bool> resendingOTP(String phoneNumber) async {
    await userRepo.resendOTP(phoneNumber).then((jsonUser) {
      emit(UserResendingOTPState(jsonUser));
      this.statusOfResendingOTP = jsonUser;
    });
    return statusOfResendingOTP;
  }

  Future<bool> loginUser(String email, String password) async {
    await userRepo.loginUser(email, password).then((jsonUser) {
      emit(UserLoginState(jsonUser));
      this.statusOfLogin = jsonUser;
    });
    return statusOfLogin;
  }

  Future<User> getProfileUser(String token) async {
    await userRepo.getUserProfile(token).then((jsonUser) {
      emit(GetProfileUserState(jsonUser));
      this.user = jsonUser;
    });
    return user;
  }

  Future<bool> completeProfile(String imageUrl, String name, String email, String phoneNumber, String age,
      String countryId, String token) async {
    await userRepo.completeProfile(imageUrl, name, email, phoneNumber, age, countryId, token).then((jsonUser) {
      emit(CompleteProfileState(jsonUser));
      this.statusOfEditing = jsonUser;
    });
    return statusOfEditing;
  }

  Future<bool> changePassword(String oldPassword, String newPassword, String token) async {
    await userRepo.changePassword(oldPassword, newPassword, token).then((jsonUser) {
      emit(ChangePasswordState(jsonUser));
      this.statusOfChangingPassword = jsonUser;
    });
    return statusOfChangingPassword;
  }

  Future<bool> forgetPasswod(String phoneNumber, String token) async {
    await userRepo.forgetPassword(phoneNumber, token).then((jsonUser) {
      emit(ForgetPasswordState(jsonUser));
      this.statusOfForgettingPassword = jsonUser;
    });
    return statusOfForgettingPassword;
  }

  Future<bool> resetPasswod(String code, String newPassword, String token) async {
    await userRepo.resetPassword(code, newPassword, token).then((jsonUser) {
      emit(ResetPasswordState(jsonUser));
      this.statusOfResettingPassword = jsonUser;
    });
    return statusOfResettingPassword;
  }

  Future<bool> editProfile(String imageUrl, String name, String email, String phoneNumber, String token) async {
    await userRepo.editProfile(imageUrl, name, email, phoneNumber, token).then((jsonUser) {
      emit(EditProfileState(jsonUser));
      this.statusOfEditing = jsonUser;
    });
    return statusOfEditing;
  }

  Future<bool> sendUserQuickChat(String token, String message, String lawyerId) async {
    await userRepo.sendUserQuickMessage(token, message, lawyerId).then((jsonUser) {
      emit(SendUserQuickChatState(jsonUser));
      this.statusOfUserSendingQuickChat = jsonUser;
    });
    return statusOfUserSendingQuickChat;
  }

  Future<Lawyer> getAvailableLawyers(String token) async {
    await userRepo.getAvailableLawyers(token).then((jsonUser) {
      emit(GetAvailableLawyersState(jsonUser));
      this.lawyer = jsonUser;
    });
    return lawyer;
  }

  Future<List<QuickChatModel>> getQuickChatForUser(String token) async {
    await userRepo.getQuickChatForUser(token).then((quickChatModel) {
      emit(GetQuickChatForUser(quickChatModel));
      this.quickChatModel = quickChatModel;
    });
    return quickChatModel;
  }
}
