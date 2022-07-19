import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/aboutUsModel.dart';
import '../models/countries.dart';
import '../models/filter_data.dart';
import '../models/lawyers.dart';
import '../models/service_provider.dart';
import '../models/user.dart';

class WebServices {
  late Dio dio;
  late SharedPreferences _pref;
  List<List<dynamic>> listOfCities = [];

  WebServices() {
    BaseOptions options = BaseOptions(
        baseUrl: 'https://manar.alliedcon.net/api/',
        receiveDataWhenStatusError: true,
        connectTimeout: 20 * 1000,
        receiveTimeout: 20 * 1000,
        responseType: ResponseType.json,
        contentType: "application/json",
        headers: {
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
          "Access-Control-Allow-Headers":
              "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "GET, HEAD, POST, OPTIONS"
        });

    dio = Dio(options);
  }

  //-------------------------User Requests-------------------------------------

  Future<bool> registerNewUser(String imageUrl, String name, String email, String phoneNumber, String password) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'register',
        data: {
          "image": imageUrl,
          'name': name,
          'email': email,
          'phone': phoneNumber,
          'password': password,
        },
      );
      if (response.data['status'] == true) {
        return response.data['status'];
      } else {
        _pref.setString('errorOfReg', response.data['message']);

        return response.data['status'];
      }
    } on DioError catch (e) {
      print('error from Register is --------->' + e.toString());
      return false;
    }
  }

  Future<bool> verifyOTP(String otp, String email, String password) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'verify',
        data: {
          "code": otp,
        },
      );
      if (response.data['status'] == true) {
        await loginUser(email, password).then((value) {
          return value;
        });
      } else {
        _pref.setString('errorOfOTP', response.data['message']);

        return response.data['status'];
      }
      return response.data['status'];
    } on DioError catch (e) {
      print('error from Verification is --------->' + e.toString());
      return false;
    }
  }

  Future<bool> resendOTP(String phoneNumber) async {
    try {
      Response response = await dio.post(
        'phone_code',
        data: {
          "phone": phoneNumber,
        },
      );

      return response.data['status'];
    } on DioError catch (e) {
      print('error from ResendingOTP is --------->' + e.toString());
      return false;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'login',
        data: {
          'login': email,
          'password': password,
        },
      );
      if (response.data['status'] == true) {
        print('User is -------->' + response.data['data']['user'].toString());

        await _pref
            .setString(
          'userToken',
          response.data['data']['user']['token'],
        )
            .then((_) async {
          await _pref.setString(
            'userId',
            response.data['data']['user']['id'].toString(),
          );
          await _pref.setString('userName', response.data['data']['user']['name']);
          await _pref.setBool('isLoggedIn', true);
          await _pref.setBool('isUser', true);
          print(_pref.getBool('isUser'));
          User.fromJson(response.data['data']['user']);
        });
      } else {
        _pref.setString('errorOfLogin', response.data['message']);

        return response.data['status'];
      }

      return response.data['status'];
    } on DioError catch (e) {
      print('error from Login -------->' + e.toString());
      return false;
    }
  }

  Future<User> getProfile(String token) async {
    try {
      Response response = await dio.get(
        'profile',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      return User.fromJson(response.data['data']);
    } on DioError catch (e) {
      print(e.toString());
      return User();
    }
  }

  Future<bool> completeProfile(
    String imageUrl,
    String name,
    String email,
    String phoneNumber,
    String age,
    String countryId,
    String token,
  ) async {
    try {
      Response response = await dio.post(
        'editInfo',
        data: {
          "image": imageUrl,
          'name': name,
          'email': email,
          'phone': phoneNumber,
          'age': age,
          'country_id': countryId,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      print('Edit Profile for User is -------->' + response.data.toString());
      // User.fromJson(response.data);
      _pref.setString('errorOfCompleteProfile', response.data['message']);

      return response.data['status'];
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword, String token) async {
    _pref = await SharedPreferences.getInstance();
    try {
      Response response = await dio.post(
        'changePassword',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      print('Status in ChangePassword is -------->' + response.data['status'].toString());
      _pref.setString('errorOfChangePassword', response.data['message'] ?? '');

      return response.data['status'];
    } on DioError catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> forgetPassword(String phoneNumber, String token) async {
    _pref = await SharedPreferences.getInstance();
    try {
      Response response = await dio.post(
        'forgetPassword',
        data: {
          'phone': phoneNumber,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      print('Status in forgetPassword is -------->' + response.data['status'].toString());
      _pref.setString('errorOfChangePassword', response.data['message'] ?? '');

      return response.data['status'];
    } on DioError catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(String code, String newPassword, String token) async {
    _pref = await SharedPreferences.getInstance();
    try {
      Response response = await dio.post(
        'resetPassword',
        data: {
          'code': code,
          'password': newPassword,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      print('Status in resetPassword is -------->' + response.data['status'].toString());
      _pref.setString('errorOfChangePassword', response.data['message'] ?? '');

      return response.data['status'];
    } on DioError catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> editProfile(String imageUrl, String name, String email, String phoneNumber, String token) async {
    _pref = await SharedPreferences.getInstance();
    try {
      Response response = await dio.post(
        'editInfo',
        data: {
          "image": imageUrl,
          'name': name,
          'email': email,
          'phone': phoneNumber,
          'country_id': 1,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      print('Edit Profile for User is -------->' + response.data.toString());
      // User.fromJson(response.data);
      _pref.setString('errorOfEditProfile', response.data['message'] ?? '');

      return response.data['status'];
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return false;
    }
  }

  Future<Lawyer> getAvailableLawyers(String token) async {
    try {
      Response response = await dio.post(
        'get_available_lawyer',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      if (response.data['status'] == true) {
        return Lawyer.fromJson(response.data['data']['lawyer']);
      } else {
        return Lawyer(
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
        );
      }
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return Lawyer(
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
      );
    }
  }

  Future<List<dynamic>> getQuickChatForUser(String token) async {
    try {
      Response response = await dio.post(
        'get_chat_with_lawyer',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      return response.data['chats'];
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return [];
    }
  }

  Future<bool> sendUserQuickMessage(String token, String message, String lawyerId) async {
    try {
      Response response = await dio.post(
        'send_message',
        data: {
          'message': message,
          'lawyer_id': lawyerId,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      if (response.data['message'] == 'success') {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return false;
    }
  }

  //---------------------------------------------------------------

  //-------------------------ServiceProvider Requests-------------------------------------

  Future<bool> loginLawyer(String email, String password) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'lawyer_login',
        data: {
          'login': email,
          'password': password,
        },
      );
      if (response.data['status'] == true) {
        print('Lawyer is -------->' + response.data['data']['lawyer'].toString());

        await _pref
            .setString(
          'lawyerToken',
          response.data['data']['lawyer']['token'],
        )
            .then((_) async {
          await _pref.setString(
            'lawyerId',
            response.data['data']['lawyer']['id'].toString(),
          );
          await _pref.setBool('isLoggedIn', true);
          await _pref.setBool('isUser', false);
          ServiceProvider.fromJson(response.data['data']['lawyer']);
        });
      } else {
        _pref.setString('errorOfLogin', response.data['message'] ?? '');

        return response.data['status'];
      }

      return response.data['status'];
    } on DioError catch (e) {
      print('error from Lawyer Login -------->' + e.toString());
      return false;
    }
  }

  Future<ServiceProvider> getLawyerProfile(String token) async {
    try {
      Response response = await dio.get(
        'lawyer_profile',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      return ServiceProvider.fromJson(response.data['lawyer']);
    } on DioError catch (e) {
      print(e.toString());
      return ServiceProvider();
    }
  }

  Future<bool> updateAvailableForServiceProvider(String token, String statusNumber) async {
    try {
      Response response = await dio.post(
        'update_available',
        data: {
          'is_available': statusNumber,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      if (response.data['message'] == 'success') {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return false;
    }
  }

  Future<List<dynamic>> getQuickChatUsers(String token) async {
    try {
      Response response = await dio.post(
        'messages',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      return response.data['users'];
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getQuickChatForLawyer(String token, String userId) async {
    try {
      Response response = await dio.post(
        'user_messages',
        data: {
          'user_id': userId,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      return response.data['chats'];
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return [];
    }
  }

  Future<bool> sendLawyerQuickMessage(String token, String message, String userId) async {
    try {
      Response response = await dio.post(
        'lawyer_send_message',
        data: {
          'message': message,
          'user_id': userId,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      if (response.data['message'] == 'success') {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return false;
    }
  }

  Future<bool> stopQuickChat(String token, String userId) async {
    try {
      Response response = await dio.post(
        'stop_chat',
        data: {
          'user_id': userId,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      if (response.data['message'] == 'success') {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('error is --------->' + e.toString());
      return false;
    }
  }

  //---------------------------------------------------------------

  //-------------------------Departments Requests-------------------------------------

  Future<List<dynamic>> getMainDepartments() async {
    try {
      Response response = await dio.get(
        'departments',
      );
      return response.data['departments'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getCourts(int mainId) async {
    try {
      Response response = await dio.get(
        'courts/${mainId.toString()}',
      );
      return response.data['courts'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getSubDepartmentsFromMain(int mainId) async {
    try {
      Response response = await dio.get(
        'subs/${mainId.toString()}',
      );
      return response.data['departments'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getSubDepartmentsFromCourt(int courtId) async {
    try {
      Response response = await dio.get(
        'cases/${courtId.toString()}',
      );
      return response.data['cases'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getQuestionsFromMain(int mainId, int index) async {
    try {
      Response response = await dio.get(
        'subs/${mainId.toString()}',
      );
      return response.data['departments'][index]['questions'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getQuestionsFromCourt(int courtId, int index) async {
    try {
      Response response = await dio.get(
        'cases/${courtId.toString()}',
      );
      return response.data['cases'][index]['questions'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  //---------------------------------------------------------------

  //-------------------------Lawyer Requests-------------------------------------

  Future<List<dynamic>> getLawyers(String lawyerName) async {
    try {
      Response response = await dio.post('searchlawyerbyname', data: {
        'name': lawyerName,
      });
      return response.data['lawyers'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getLawyersBySubDepartments(int subId) async {
    try {
      Response response = await dio.get(
        'getLawyersbySub/${subId.toString()}',
      );
      return response.data['lawyers'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getLawyersByCourts(int subId) async {
    try {
      Response response = await dio.get(
        'getLawyersbyCourt/${subId.toString()}',
      );
      return response.data['lawyers'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getCountriesList() async {
    try {
      Response response = await dio.get(
        'countries',
      );
      return response.data['countries'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<List<dynamic>>> getCitiesList() async {
    var countries = await getCountriesList();
    var countriesList = countries.map((country) => Countries.fromJson(country)).toList();
    try {
      for (var country in countriesList) {
        Response response = await dio.get(
          'cities/' + country.id!.toString(),
        );
        listOfCities.add(response.data['cities']);
      }
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }

    return listOfCities;
  }

  Future<List<dynamic>> filteredLawyers(
      String country, String city, String type, List<int> mainDepartments, List<int> specialists) async {
    try {
      Response response = await dio.post(
        'searchlawyer',
        data: {
          'country': country,
          'city': city,
          'type': type,
          'main': mainDepartments,
          'specialists[]': specialists,
        },
      );
      return response.data['lawyers'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  //---------------------------------------------------------------

  //-------------------------Booking Services Requestes-------------------------
  Future<String> bookingServiceWeb(String token, String appointmentId, String lawyerId, String mainId, String subId,
      String date, String courtQuestion, String wayToCommunicate, String courtId, String pay, List answers) async {
    _pref = await SharedPreferences.getInstance();

    var params = {
      "appointment_id": appointmentId,
      "lawyer_id": lawyerId,
      "service_id": mainId,
      "sub_id": subId,
      "date": date,
      "court_question": courtQuestion,
      "way_to_communicate": wayToCommunicate,
      "court_id": courtId,
      "pay": pay,
      "answers": answers,
    };
    try {
      Response response = await dio.post(
        'booking_web',
        data: jsonEncode(params),
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      _pref.setString('bookingId', response.data['booking_id'].toString());

      return response.data['message'];
    } on DioError catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<List<dynamic>> getBookings(String token) async {
    try {
      Response response = await dio.post(
        'getBookings',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      return response.data['bookings'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<String> bookingServiceWithoutLawyer(
      String token, String mainId, String courtId, String subId, String courtAnswer, List answers) async {
    _pref = await SharedPreferences.getInstance();
    var params = {
      "service_id": mainId,
      "court_id": courtId,
      "sub_service_id": subId,
      "court_answer": courtAnswer,
      "answers": answers,
    };
    try {
      Response response = await dio.post(
        'serviceBookingWeb',
        data: jsonEncode(params),
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      _pref.setString('bookingId', response.data['booking_id'].toString());
      return response.data['message'];
    } on DioError catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<List<dynamic>> getBookingsWithoutLawyers(String token) async {
    try {
      Response response = await dio.post(
        'getServiceBooking',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      return response.data['data'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> verifyPayment(String token, String bookingId, String paymentId) async {
    try {
      Response response = await dio.post(
        'verify_payment',
        data: {
          "booking_id": bookingId,
          "payment_id": paymentId,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );

      return response.data['status'];
    } on DioError catch (e) {
      print('error from verifyPayment is --------->' + e.toString());
      return false;
    }
  }

  Future<bool> verifyServicePayment(String token, String bookingId, String paymentId) async {
    try {
      Response response = await dio.post(
        'verify_payment_service',
        data: {
          "booking_id": bookingId,
          "payment_id": paymentId,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );

      return response.data['status'];
    } on DioError catch (e) {
      print('error from verifyPayment is --------->' + e.toString());
      return false;
    }
  }

  Future<String> updateBookingService(String token, String bookingId, String appointmentId, String date,
      String lawyerId, String wayToCommunicate) async {
    var params = {
      "booking_id": bookingId,
      "appointment_id": appointmentId,
      "lawyer_id": lawyerId,
      "date": date,
      "way_to_communicate": wayToCommunicate,
    };
    try {
      Response response = await dio.post(
        'update_booking',
        data: jsonEncode(params),
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      return response.data['message'];
    } on DioError catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<bool> startQuickChat(String token) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'start_chat',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      if (response.data['message'] == 'success') {
        return true;
      } else {
        _pref.setString('errorOfStartChat', response.data['message']);

        return false;
      }
    } on DioError catch (e) {
      print('error from StartChat is --------->' + e.toString());
      return false;
    }
  }

  Future<bool> checkQuickChat(String token) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'check_chat',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      if (response.data['status'] == true) {
        return true;
      } else {
        _pref.setString('errorOfCheckQuickChat', response.data['message']);

        return false;
      }
    } on DioError catch (e) {
      print('error from CheckQuickChat is --------->' + e.toString());
      return false;
    }
  }

  Future<List<dynamic>> getChatWithAttachments(String token, String bookingId) async {
    try {
      Response response = await dio.post(
        'get_booking_attachments',
        data: {
          "booking_id": bookingId,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      return response.data['data'].reversed.toList();
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  //-------------------------Others Requests-------------------------------------

  Future<FilterData> filterData() async {
    try {
      Response response = await dio.get(
        'getData',
      );
      return FilterData.fromJson(response.data);
    } on DioError catch (e) {
      print(e.toString());
      return FilterData();
    }
  }

  Future<List<dynamic>> getSliders() async {
    try {
      Response response = await dio.get(
        'sliders',
      );
      return response.data['sliders'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> contactUsSendMessage(String message, String token) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'contacts',
        data: {
          "message": message,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      _pref.setString('errorOfContactUs', response.data['message'] ?? '');

      return response.data['status'];
    } on DioError catch (e) {
      print('error from contactUsSendMessage is --------->' + e.toString());
      return false;
    }
  }

  Future<AboutUsModel> getAboutUs() async {
    try {
      Response response = await dio.get(
        'setting',
      );
      return AboutUsModel.fromJson(response.data['setting']);
    } on DioError catch (e) {
      print(e.toString());
      return AboutUsModel();
    }
  }

  Future<List<dynamic>> getSpecialists() async {
    try {
      Response response = await dio.get(
        'specialists',
      );
      return response.data['specialists'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getQNA() async {
    try {
      Response response = await dio.get(
        'questions',
      );
      return response.data['questions'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> logOut(String token) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'logout',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      _pref.setString('errorOfLogOut', (response.data['message'] != null) ? response.data['message'] : '');
      _pref.setBool('isLoggedIn', false);
      return response.data['status'];
    } on DioError catch (e) {
      print('error from LogingOut is --------->' + e.toString());
      return false;
    }
  }

  Future<bool> logOutLawyer(String token) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'logout_lawyer',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      _pref.setString('errorOfLogOut', (response.data['message'] != null) ? response.data['message'] : '');
      _pref.setBool('isLoggedIn', false);
      return response.data['status'];
    } on DioError catch (e) {
      print('error from LogingOut is --------->' + e.toString());
      return false;
    }
  }

  Future<bool> rateAndComment(
      String token, String lawyerId, String lawyerRate, String serviceRate, String appRate, String comment) async {
    _pref = await SharedPreferences.getInstance();

    try {
      Response response = await dio.post(
        'rate',
        data: {
          "lawyer_id": lawyerId,
          "rate": lawyerRate,
          "service": serviceRate,
          "application": appRate,
          "comment": comment,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      _pref.setString('errorOfRate', response.data['message']);

      return true;
    } on DioError catch (e) {
      print('error from errorOfRate is --------->' + e.toString());
      return false;
    }
  }

  Future<List<dynamic>> getRateService() async {
    try {
      Response response = await dio.get(
        'getServiceRate',
      );
      return response.data['data'];
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getNotifications(String token) async {
    try {
      Response response = await dio.get(
        'getUserNotification',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      if (response.data['status'] == true) {
        print(response.data.toString());
        return response.data['data'];
      } else {
        print('is FAAAAALSSSSEEE ++++++++ ' + response.data.toString());

        return [response.data['message']];
      }
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<List<dynamic>> getTechMessages(String token) async {
    try {
      Response response = await dio.get(
        'getSupports',
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );
      if (response.data['status'] == true) {
        print(response.data.toString());
        return response.data['data'];
      } else {
        return [response.data['message']];
      }
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> sendTechMessage(String token, String message) async {
    try {
      Response response = await dio.post(
        'technicalSupport',
        data: {
          "message": message,
        },
        options: Options(
          headers: {
            'Accept': '*/*',
            HttpHeaders.authorizationHeader: token,
          },
        ),
      );

      return response.data['status'];
    } on DioError catch (e) {
      print('error from sendingTechMessage is --------->' + e.toString());
      return false;
    }
  }
  //---------------------------------------------------------------

}
