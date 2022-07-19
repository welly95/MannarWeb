part of 'services_cubit.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object> get props => [];
}

class ServicesInitial extends ServicesState {}

class GetFilterData extends ServicesState {
  final FilterData filterData;
  GetFilterData(this.filterData);
}

class ContactUsSendingMessageState extends ServicesState {
  final bool statusOfMessage;
  ContactUsSendingMessageState(this.statusOfMessage);
}

class GetAboutUsState extends ServicesState {
  final AboutUsModel aboutUsModel;
  GetAboutUsState(this.aboutUsModel);
}

class LogOutState extends ServicesState {
  final bool statusOfLogOut;
  LogOutState(this.statusOfLogOut);
}

class LogOutLawyerState extends ServicesState {
  final bool statusOfLogOut;
  LogOutLawyerState(this.statusOfLogOut);
}

class RateAndCommentState extends ServicesState {
  final bool statusOfRate;
  RateAndCommentState(this.statusOfRate);
}

class GetSlidersState extends ServicesState {
  final List<Sliders> sliders;
  GetSlidersState(this.sliders);
}

class GetRateServicesState extends ServicesState {
  final List<RateService> rateList;
  GetRateServicesState(this.rateList);
}

class GetNotificationsState extends ServicesState {
  final List<Notifications> statusOfNotifi;
  GetNotificationsState(this.statusOfNotifi);
}

class GetTechMessagesState extends ServicesState {
  final List<TechMessages> techMessages;
  GetTechMessagesState(this.techMessages);
}

class SendTechMessagesState extends ServicesState {
  final bool statusOfSendingTechMessage;
  SendTechMessagesState(this.statusOfSendingTechMessage);
}
