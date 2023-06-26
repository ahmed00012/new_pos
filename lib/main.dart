
import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shormeh_pos_new_28_11_2022/repositories/get_data.dart';

import 'package:shormeh_pos_new_28_11_2022/ui/screens/home.dart';
import 'package:shormeh_pos_new_28_11_2022/ui/screens/login.dart';
import 'constants.dart';
import 'local_storage.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext ?context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main()async{

 WidgetsFlutterBinding.ensureInitialized();
 await LocalStorage.init();
 await EasyLocalization.ensureInitialized();
 tz.initializeTimeZones();
 HttpOverrides.global = new MyHttpOverrides();

  runApp(ProviderScope(child:  EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp())));
}

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // GetData allData = GetData();




  // getBase()async{
  //
  //   bool result = await InternetConnectionChecker().hasConnection;
  //   if(result == true) {
  //     setState(() {
  //       LocalStorage.saveData(key: 'baseUrl', value: 'https://beta2.poss.app/api/');
  //     });
  //   }
  //
  //    else {
  //     setState(() {
  //       LocalStorage.saveData(key: 'baseUrl', value: 'http://192.168.1.11:8000/api/');
  //
  //     });
  //   }
  //
  // }

  // clearLocalStorage()async{
  //   if (LocalStorage.getData(key: 'firstRun') ?? true) {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     await preferences.clear();
  //     LocalStorage.saveData(key: 'first_run', value: false);
  //   }
  // }

  // @override
  // void initState() {
  //   // clearLocalStorage();
  //   // TODO: implement initState
  //   LocalStorage.saveData(key: 'baseUrl', value: 'https://beta2.poss.app/api/');
  //     getBase();
  //   if(LocalStorage.getData(key: 'token')!=null){
  //     allData.getAll();
  //   }
  //
  //
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);
     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      LocalStorage.saveData(key: 'language', value: context.locale.languageCode);
        return OverlaySupport.global(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            navigatorKey: navigatorKey,
            // initialRoute: '/',
            // routes: {
            //  '/':(context) => Home(),
            // },
            theme: ThemeData(
               fontFamily: 'RobotoCondensed',
              scaffoldBackgroundColor: Constants.scaffoldColor,
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Constants.mainColor,
                selectionColor: Constants.mainColor,
                selectionHandleColor:Constants.mainColor,
              ),
            ),
            home:LocalStorage.getData(key: 'token')==null? Login():Home(),
          ),
        );

  }
}


