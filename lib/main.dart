import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:linear/screens/delivery_person/dp_dashboard.dart';
import 'package:linear/screens/order_booker/add_customer.dart';
import 'package:linear/screens/order_booker/complain.dart';
import 'package:linear/screens/order_booker/customer_visit.dart';
import 'package:linear/screens/order_booker/dashboard.dart';
import 'package:linear/screens/order_booker/dispatch_order.dart';
import 'package:linear/screens/order_booker/feedback.dart';
import 'package:linear/screens/order_booker/orders.dart';
import 'package:linear/screens/orders/add_order.dart';
import 'package:linear/screens/order_booker/payment.dart';
import 'package:linear/screens/order_booker/photo_preview.dart';
import 'package:linear/screens/order_booker/profile.dart';
import 'package:linear/screens/order_booker/retailer_visit.dart';
import 'package:linear/screens/order_booker/route_punch.dart';
import 'package:linear/screens/order_booker/routes.dart';
import 'package:linear/screens/order_booker/routes_plan.dart';
import 'package:linear/screens/order_booker/select_order_products.dart';
import 'package:linear/screens/order_booker/servey.dart';
import 'package:linear/screens/snackbar.dart';
import 'package:linear/screens/splash_screen/splash.dart';
import 'package:linear/screens/order_booker/tracking.dart';
import 'package:linear/screens/order_booker/complain_list.dart';
import 'screens/area_manager/am_dashboard.dart';
import 'interview.dart';
import 'dart:io';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //this status bar color when a user is not logged in
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.light,
  ));
  HttpOverrides.global = MyHttpOverrides();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Color color = HexColor.fromHex('#aabbcc');
    MaterialColor buildMaterialColor(Color color) {
      List strengths = <double>[.05];
      Map<int, Color> swatch = {};
      final int r = color.red, g = color.green, b = color.blue;
      for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
      strengths.forEach((strength) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      });
      return MaterialColor(color.value, swatch);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        useMaterial3: false,
        // fontFamily: 'Helvetica',
        appBarTheme: AppBarTheme(
          //this status bar color show when user is logged in screen
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        // primarySwatch: Colors.red, // Or another color
        primarySwatch: buildMaterialColor(
          Color(0xff87C440),
        ),
        // textTheme: Typography.englishLike2018.apply(),
        textTheme: TextTheme(),
      ),
      // home: Splash(),
      // home: Payment(),
      // initialRoute: '/complain',
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        final scale = mediaQueryData.textScaleFactor.clamp(0.8, 0.9);
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
            child: child!);
      },
      routes: {
        '/': (context) => const Splash(),
        '/dashboard': (context) => const Dashboard(),
        '/am_dashboard': (context) => const AmDashboard(),
        '/dp_dashboard': (context) => const DpDashboard(),
        '/routes': (context) => const Routes(),
        '/tracking': (context) => const Tracking(),
        '/orders': (context) => const Orders(),
        '/orders/add_orders/customer': (context) => const AddOrder(),
        '/orders/add_orders/retailer': (context) => const AddOrder(),
        // '/order_details': (context) => const OrderDetails(),
        // '/add_order': (context) => const AddOrder(),
        '/profile': (context) => const Profile(),
        '/select_order_product': (context) => const SelectOrderProducts(),
        '/complain': (context) => const ComplainList(),
        '/complain/add/customer': (context) => const Complain(),
        '/complain/add/retailer': (context) => const Complain(),
        '/servey/add/customer': (context) => const Servey(),
        '/servey/add/retailer': (context) => const Servey(),
        '/customer_visit': (context) => const CustomerVisit(),
        '/reatiler_visit': (context) => const RetailerVisit(),
        '/feedback/customer': (context) => const CustFeedback(),
        '/feedback/retailer': (context) => const CustFeedback(),
        '/add_customer/customer': (context) => const AddCustomer(),
        '/add_customer/retailer': (context) => const AddCustomer(),
        '/routes_punch': (context) => const RoutePunch(),
        '/payment/add/customer': (context) => const Payment(),
        '/payment/add/retailer': (context) => const Payment(),
        '/dispatch/add/customer': (context) => const DispatchOrder(),
        '/dispatch/add/retailer': (context) => const DispatchOrder(),
        '/routes_plan': (context) => const RoutesPlan(),
        '/photo_view': (context) => const PhotoPreview(),
        '/splash_screen': (context) => const Splash(),
        '/interview': (context) => const Interview(),
      },
    );
  }
}
