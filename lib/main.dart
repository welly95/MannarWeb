import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mannar_web/bloc/lawyer/lawyer_cubit.dart';
import 'package:mannar_web/repository/lawyer_repository.dart';
import 'screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/bloc/user/user_cubit.dart';
import '../../bloc/service_provider/service_provider_cubit.dart';
import '../../repository/service_provider_repository.dart';
import '../../screens/chat/lawyer_chats_page.dart';
import '/repository/user_repository.dart';
import '/repository/web_services.dart';
import '/screens/login/create_account.dart';
import '../bloc/services/services_cubit.dart';
import '../repository/services_repository.dart';
import 'constants/size_config.dart';

String? userToken;
String? lawyerToken;
String? lawyerId;
bool? _isLoggedIn;
bool? _isUser;

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description: 'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('A bg message just showed up :  ${message.messageId}');
}

Future main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyA1Ihxms6US0WFlKmDJdVJdQr2LbYJOUfc",
      authDomain: "mannar-7fbe5.firebaseapp.com",
      projectId: "mannar-7fbe5",
      storageBucket: "mannar-7fbe5.appspot.com",
      messagingSenderId: "464931186989",
      appId: "1:464931186989:web:34d793ff89c13ecc7e4ba4",
      measurementId: "G-CP5Y1F6ZE1",
    ),
  ).then((value) => print(value.options));
  // await FlutterDownloader.initialize(
  //   debug: true, // optional: set false to disable printing logs to console
  // );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    print("message recieved");
    print(event.notification!.body);
    print(event.data.values);
  });

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Splash(),
          );
          // ignore: unnecessary_null_comparison
        } else if (snapshot == null) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Splash(),
          );
        } else {
          return MaterialApp(
            title: 'Mannar',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(width: 1.5, color: Theme.of(context).unselectedWidgetColor),
                  splashRadius: 0),
              fontFamily: GoogleFonts.elMessiri().fontFamily,
            ),
            home: (_isLoggedIn == false || _isLoggedIn == null)
                ? BlocProvider(
                    create: (BuildContext context) => UserCubit(UserRepository(WebServices())),
                    child: CreateAccount(),
                  )
                : (_isUser == false || _isUser == null)
                    ? MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => ServicesCubit(ServicesRepo(WebServices())),
                          ),
                          BlocProvider(
                            create: (context) => ServiceProviderCubit(ServiceProviderRepository(WebServices())),
                          ),
                        ],
                        child: LawyerChatsPage(lawyerId!, lawyerToken!),
                      )
                    : MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (BuildContext context) => LawyerCubit(
                              LawyerRepository(
                                WebServices(),
                              ),
                            ),
                          ),
                          BlocProvider(
                            lazy: false,
                            create: (BuildContext context) => ServicesCubit(
                              ServicesRepo(
                                WebServices(),
                              ),
                            ),
                          ),
                        ],
                        child: HomeScreen(),
                      ),
            // : MultiBlocProvider(
            //     providers: [
            //       BlocProvider(
            //         create: (BuildContext context) => CitiesCubit(
            //           CitiesRepository(
            //             WebServices(),
            //           ),
            //         ),
            //       ),
            //       BlocProvider(
            //         create: (BuildContext context) => CountryCubit(
            //           CountriesRepository(
            //             WebServices(),
            //           ),
            //         ),
            //       ),
            //       BlocProvider(
            //         create: (BuildContext context) => ServicesCubit(
            //           ServicesRepo(
            //             WebServices(),
            //           ),
            //         ),
            //       ),
            //     ],
            //     child: BottomNavigator(3),
            // ),
          );
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: SizeConfig.screenHeight * 0.15,
          width: SizeConfig.screenWidth * 0.2,
          child: Image.asset(
            'assets/images/mannar_logo.png',
            fit: BoxFit.fill,
            width: 1000,
          ),
        ),
      ),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();
  late SharedPreferences _pref;
  String? _myToken;
  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    _pref = await SharedPreferences.getInstance();
    _myToken = await FirebaseMessaging.instance.getToken();
    print(_myToken);
    userToken = _pref.getString('userToken');
    lawyerToken = _pref.getString('lawyerToken');
    lawyerId = _pref.getString('lawyerId');
    _isLoggedIn = _pref.getBool('isLoggedIn');
    _isUser = _pref.getBool('isUser');
    print('is User=========>' + userToken!);
    // print('is Lawyer=========>' + lawyerToken!);
    await Future.delayed(const Duration(seconds: 3));
  }
}
