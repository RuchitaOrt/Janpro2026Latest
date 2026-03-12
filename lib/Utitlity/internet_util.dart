import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> checkInternetNow() async {
  return await InternetConnectionChecker().hasConnection;
}
