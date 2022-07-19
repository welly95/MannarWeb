import 'package:mannar_web/models/notifications.dart';
import 'package:mannar_web/models/rateService.dart';
import 'package:mannar_web/models/techMessages.dart';

import '../../models/aboutUsModel.dart';
import '../../models/filter_data.dart';
import '../../models/sliders.dart';
import '../../repository/web_services.dart';

class ServicesRepo {
  final WebServices webServices;
  ServicesRepo(this.webServices);

  Future<FilterData> filterData() async {
    FilterData filterData = await webServices.filterData();
    print('filterData from repo filterData is --------->' + filterData.toString());
    return filterData;
  }

  Future<bool> contactUsSendingMessage(String message, String token) async {
    bool statusOfMessage = await webServices.contactUsSendMessage(message, token);
    print('Status from repo contactUsSendingMessage is --------->' + statusOfMessage.toString());
    return statusOfMessage;
  }

  Future<AboutUsModel> getAboutUs() async {
    AboutUsModel aboutUsModel = await webServices.getAboutUs();
    print('model from repo getAboutUs is --------->' + aboutUsModel.toString());
    return aboutUsModel;
  }

  Future<bool> logOut(String token) async {
    bool statusOfLogOut = await webServices.logOut(token);
    print('Status from repo LogOut is --------->' + statusOfLogOut.toString());
    return statusOfLogOut;
  }

  Future<bool> logOutLawyer(String token) async {
    bool statusOfLogOut = await webServices.logOutLawyer(token);
    print('Status from repo LogOut is --------->' + statusOfLogOut.toString());
    return statusOfLogOut;
  }

  Future<bool> rateAndComment(
      String token, String lawyerId, String lawyerRate, String serviceRate, String appRate, String comment) async {
    bool statusOfRate = await webServices.rateAndComment(token, lawyerId, lawyerRate, serviceRate, appRate, comment);
    print('Status from repo RateAndComment is --------->' + statusOfRate.toString());
    return statusOfRate;
  }

  Future<List<Sliders>> getSliders() async {
    final sliders = await webServices.getSliders();
    print('Sliders from Repo is ---->' + sliders.toString());
    return sliders.map((slider) => Sliders.fromJson(slider)).toList();
  }

  Future<List<RateService>> getRateService() async {
    final rateList = await webServices.getRateService();
    print('rateList from Repo is ---->' + rateList.toString());
    return rateList.map((rate) => RateService.fromJson(rate)).toList();
  }

  Future<List<Notifications>> getNotifications(String token) async {
    final statusOfNotifi = await webServices.getNotifications(token);
    print('Notifications is : ' + statusOfNotifi.toString());
    return statusOfNotifi.map((notifi) => Notifications.fromJson(notifi)).toList();
  }

  Future<List<TechMessages>> getTechMessages(String token) async {
    final messages = await webServices.getTechMessages(token);
    return messages.map((message) => TechMessages.fromJson(message)).toList().reversed.toList();
  }

  Future<bool> sendTechMesage(String token, String message) async {
    final statusOfSendingTechMessage = await webServices.sendTechMessage(token, message);
    return statusOfSendingTechMessage;
  }
}
