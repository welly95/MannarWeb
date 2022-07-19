part of 'service_provider_cubit.dart';

abstract class ServiceProviderState extends Equatable {
  const ServiceProviderState();

  @override
  List<Object> get props => [];
}

class ServiceProviderInitial extends ServiceProviderState {}

class ServiceProviderLoginState extends ServiceProviderState {
  final bool statusOfLogin;
  ServiceProviderLoginState(this.statusOfLogin);
}

class GetServiceProviderProfileState extends ServiceProviderState {
  final ServiceProvider serviceProvider;
  GetServiceProviderProfileState(this.serviceProvider);
}

class SendLawyerQuickChatState extends ServiceProviderState {
  final bool statusOfSendingLawyerQuickChat;
  SendLawyerQuickChatState(this.statusOfSendingLawyerQuickChat);
}

class UpdateAvailableForServiceProviderState extends ServiceProviderState {
  final bool updateAvailableForServiceProvider;
  UpdateAvailableForServiceProviderState(this.updateAvailableForServiceProvider);
}

class GetQuickChatUsersState extends ServiceProviderState {
  final List<QuickChatUserModel> quickChatUserModel;
  GetQuickChatUsersState(this.quickChatUserModel);
}

class GetQuickChatForLawyerState extends ServiceProviderState {
  final List<QuickChatModel> quickChatModel;
  GetQuickChatForLawyerState(this.quickChatModel);
}

class StopQuickChatState extends ServiceProviderState {
  final bool statusOfStopQuickChat;
  StopQuickChatState(this.statusOfStopQuickChat);
}
