 import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:complete_women_care/screens/AppointmentScreen.dart';
import 'package:complete_women_care/screens/ChatList.dart';
import 'package:complete_women_care/screens/HomeScreen.dart';
import 'package:complete_women_care/screens/SettingsScreen.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:complete_women_care/screens/SplashScreen.dart';
import 'package:complete_women_care/screens/gallery.dart';
// import 'package:stripe_payment/stripe_payment.dart';
import 'firebase_config.dart';
import 'notificationTesting/PushNotiication_service.dart';
import 'notificationTesting/notificationHelper.dart';


FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
String IMAGEURL = "";
    //"https://completewomencares.com";
// String SERVER_ADDRESS = "https://demo.freaktemplate.com/complete_women_care";
String SERVER_ADDRESS = "https://alphadoctor.productsalphawizz.com";
// MyNotificationHelper notificationHelper = MyNotificationHelper();
final String serverToken =
    "AAAA-m3sD4o:APA91bEtGKnSd6ZZoahNXWSFMeUiMJqfWJHtKzgisLjHOnF0izMQnuqutVeKzP2LPxBTBR4-pWXrA0qkIGm9xmDsNRswPLcdAw2G_f_69jC10Zx8fxxspJJ2W5U6OuYo9qiBC02rkCQB";

const String TOKENIZATION_KEY = 'sandbox_v2fzhc6d_qpj7hhj994nbzy5q';
const String CURRENCY_CODE = 'USD';
const String DISPLAY_NAME = 'Example Company';

Color LIME = Color(0xFF068C90);
// Color LIME = Color.fromRGBO(231, 208, 69, 1);
Color WHITE = Color(0xffffffff);
Color GREEN = Color(0xff00FF00);
Color BLACK = Colors.black;
Color NAVY_BLUE = Color(0xFF068C90);//Color.fromRGBO(53, 99, 128, 1);
Color LIGHT_GREY = Color.fromRGBO(230, 230, 230, 1);
Color LIGHT_GREY_SCREEN_BG = Color.fromRGBO(240, 240, 240, 1);
Color LIGHT_GREY_TEXT = Colors.grey.shade700;
String CURRENCY = "\₹";

setSnackbar(
    String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    duration: Duration(seconds: 1),
    content: new Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(color: BLACK),
    ),
    backgroundColor: WHITE,
    elevation: 1.0,
  ));
}

void main() async {
  // StripePayment.setOptions(
  //   StripeOptions(
  //     publishableKey: "YOUR_PUBLISHABLE_KEY",
  //     merchantId: "YOUR_MERCHANT_ID",
  //   ),
  // );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseConfig.platformOptions
  );
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true, // Required to display a heads up notification
  //   badge: true,
  //   sound: true,
  // );
  // // FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //


  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(
            fontFamily: "Avir",
          ),
          headline2: TextStyle(
            fontFamily: "Avir",
          ),
          headline3: TextStyle(
            fontFamily: "Avir",
          ),
          headline4: TextStyle(
            fontFamily: "Avir",
          ),
          headline5: TextStyle(
            fontFamily: "Avir",
          ),
          headline6: TextStyle(
            fontFamily: "Avir",
          ),
          subtitle1: TextStyle(
            fontFamily: "Avir",
          ),
          subtitle2: TextStyle(
            fontFamily: "Avir",
          ),
          caption: TextStyle(
            fontFamily: "Avir",
          ),
          bodyText1: TextStyle(
            fontFamily: "Avir",
          ),
          bodyText2: TextStyle(
            fontFamily: "Avir",
          ),
          button: TextStyle(
            fontFamily: "Avir",
          ),
        ),
        primaryColor: NAVY_BLUE, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: LIME, primary: NAVY_BLUE, primaryVariant: NAVY_BLUE, secondaryVariant: LIME)
    ),
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('en', ''),
      const Locale('he', ''),
      const Locale('ar', ''),
      const Locale.fromSubtags(languageCode: 'zh'),
    ],
  ));
}



class TabBarScreen extends StatefulWidget {
  @override
  _TabBarScreenState createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with TickerProviderStateMixin {
  int currentTab = 0;

  firebaseInitialize() async{
    await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    // FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
    FirebaseMessaging.onBackgroundMessage(myForgroundMessageHandler);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseInitialize();

    // MyNotificationHelper pushNotificationService = new MyNotificationHelper();
    // pushNotificationService.initialize();
    // PushNotificationService pushNotificationService = new PushNotificationService(context: context);
    // pushNotificationService.initialise();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            HomeScreen(),
            currentTab > 0 ? ChatList() : Container(),
            currentTab > 1 ? GalleryPage() : Container(),
            currentTab > 2 ? AppointmentScreen() : Container(),
            currentTab > 3 ? SettingsScreen() : Container(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          backgroundColor: WHITE,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                currentTab == 0
                    ? "assets/tabBar/home_active.png"
                    : "assets/tabBar/home.png",
                color: currentTab == 0 ? NAVY_BLUE : LIGHT_GREY_TEXT,
                height: 23,
                width: 23,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  currentTab == 2
                      ? "assets/tabBar/chat_active.png"
                      : "assets/tabBar/chat.png",
                  color: currentTab == 2 ? NAVY_BLUE : LIGHT_GREY_TEXT,
                  height: 23,
                  width: 23,
                ),
                label: "Blogs"),
            BottomNavigationBarItem(
              icon: currentTab == 1 ? Icon(Icons.photo,size: 25,) : Icon(Icons.photo,size: 25,),
              label: "Gallery",
            ),
            BottomNavigationBarItem(
                icon: Image.asset(
                  currentTab == 3
                      ? "assets/tabBar/appointment_active.png"
                      : "assets/tabBar/appointment.png",
                  color: currentTab == 3 ? NAVY_BLUE : LIGHT_GREY_TEXT,
                  height: 23,
                  width: 23,
                ),
                label: "Appointment"),
            BottomNavigationBarItem(
              icon: Image.asset(
                currentTab == 4
                    ? "assets/tabBar/setting_active.png"
                    : "assets/tabBar/setting.png",
                color: currentTab == 4 ? NAVY_BLUE : LIGHT_GREY_TEXT,
                height: 23,
                width: 23,
              ),
              label: "Setting",
            ),
          ],
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 10,
          showSelectedLabels: true,
          unselectedFontSize: 10,
          selectedLabelStyle: TextStyle(
            color: LIGHT_GREY_TEXT,
          ),
          onTap: (val) {
            setState(() {
              currentTab = val;
            });
          },
        ),
      ),
    );
  }
}

class SignInDemo extends StatefulWidget {
  @override
  _SignInDemoState createState() => _SignInDemoState();
}

class _SignInDemoState extends State<SignInDemo> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _googleSignIn.signIn().then((value) {
              value.authentication.then((googleKey) {
                print(googleKey.idToken);
                print(googleKey.accessToken);
                print(value.email);
                print(value.displayName);
                print(value.photoUrl);
              }).catchError((e) {
                print(e.toString());
              });
            }).catchError((e) {
              print(e.toString());
            });
          },
          child: Container(),
        ),
      ),
    );
  }
}

class AppleLogin extends StatefulWidget {
  @override
  _AppleLoginState createState() => _AppleLoginState();
}

class _AppleLoginState extends State<AppleLogin> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example app: Sign in with Apple'),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Center(),
        ),
      ),
    );
  }
}



Future myBackgroundMessageHandler(RemoteMessage event) async {
  await Firebase.initializeApp();
  HomeScreen().createState();
  print("\n\nbackground: " + event.toString());

  // notificationHelper.showMessagingNotification(data: event.data);
}

doesSendNotification(String userUid, bool doesSend) async {
  await SharedPreferences.getInstance().then((value) {
    value.setBool(userUid, doesSend);
    print("\n\n ------------------> " +
        value.getBool(userUid).toString() +
        "\n\n");
  });
}


