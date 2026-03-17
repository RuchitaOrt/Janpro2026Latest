import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:janpro/Screens/Notification.dart';
import 'package:janpro/Utitlity/custom_color.dart';
import 'package:janpro/Utitlity/sizeConfig.dart';

class AppbarComman extends StatelessWidget {
  final String setStyleStr;
  final VoidCallback? onPressedBack;
  final VoidCallback? onPressedNotify;
  final VoidCallback? onPressedSearch;
  final VoidCallback? onPressedSort;
  final VoidCallback? onPressedmenu;

  const AppbarComman({
    Key? key,
    required this.setStyleStr,
    required this.onPressedBack,
    required this.onPressedNotify,
    required this.onPressedSearch,
    required this.onPressedSort,
    this.onPressedmenu,
  }) : super(key: key);

  void showTopSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 70,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2)).then((_) => overlayEntry.remove());
  }

  Future<void> checkNow(BuildContext context) async {
    bool isOnline = await InternetConnectionChecker().hasConnection;

    showTopSnackBar(
      context,
      isOnline ? "Internet is ON" : "Internet is OFF",
      isOnline ? Colors.green : Colors.red,
    );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: customcolor.blue,
      child:OfflineBuilder(
  connectivityBuilder: (context, connectivity, child) {
    final bool connected = connectivity != ConnectivityResult.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: SizeConfig.blockSizeVertical * 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 14, bottom: 9),
              child: Image.asset(
                'assets/images/mainlogo.png',
                width: SizeConfig.blockSizeHorizontal * 25,
                height: SizeConfig.blockSizeVertical * 4,
              ),
            ),
            // Right side icons
            Row(
              children: [
                // Notification (hidden)
                Visibility(
                  visible: false,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotificationPage(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'assets/images/notification.png',
                        width: SizeConfig.blockSizeHorizontal * 7,
                        height: SizeConfig.blockSizeHorizontal * 7,
                      ),
                    ),
                  ),
                ),
                // Internet Status Icon
                GestureDetector(
                  onTap: () => checkNow(context),
                  child: Material(
                    color: Colors.transparent,
                    child: Tooltip(
                      message: connected
                          ? "Online (tap to check)"
                          : "Offline (tap to check)",
                      preferBelow: false,
                      child: Icon(
                        connected ? Icons.wifi : Icons.wifi_off,
                        color: connected ? Colors.green : Colors.red,
                        size: 22,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                GestureDetector(
                  onTap: onPressedmenu,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.menu,
                      color: customcolor.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  },
  child: SizedBox.shrink(), // child remains optional
),
 );
  }
}
