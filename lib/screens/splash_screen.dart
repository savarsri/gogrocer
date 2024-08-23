import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:user/constants/string_constants.dart';
import 'package:user/models/businessLayer/global.dart' as global;
import 'package:user/models/models.dart';
import 'package:user/screens/screens.dart';

class SplashScreen extends BaseRoute {
  SplashScreen(
      {super.analytics, super.observer, super.routeName = 'SplashScreen'});

  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends BaseRouteState {
  bool isLoading = true;
  double _opacity = 0.0;

  GlobalKey<ScaffoldState>? _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Image.asset(
                'assets/images/iconnew.png',
                fit: BoxFit.contain,
                scale: 2,
              ),
            ),
            SizedBox(height: 10),
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(seconds: 1),
              child: Text(
                StringConstants.SPLASH_SCREEN_TEXT,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeIn();
    });
    _init();
  }

  void _fadeIn() {
    setState(() {
      _opacity = 1.0;
    });
  }

  _getAppInfo() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        final result = await apiHelper.getAppInfo();
        if (result != null) {
          if (result.status == "1") {
            global.appInfo = result.data;
          } else {
            hideLoader();
            showSnackBar(
                key: _scaffoldKey, snackBarMessage: '${result.message}');
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getAppInfo():" + e.toString());
    }
  }

  _getAppNotice() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        final result = await apiHelper.getAppNotice();
        if (result != null) {
          if (result.status == "1") {
            global.appNotice = result.data;
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getAppNotice():" + e.toString());
    }
  }

  _getGoogleMapApiKey() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        final result = await apiHelper.getGoogleMapApiKey();
        if (result != null) {
          if (result.status == "1") {
            global.googleMap = result.data;
          } else {
            hideLoader();
            global.googleMap = null;
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getGoogleMapApiKey():" +
          e.toString());
    }
  }

  _getMapBoxApiKey() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        final result = await apiHelper.getMapBoxApiKey();
        if (result != null) {
          if (result.status == "1") {
            global.mapBox = result.data;

            setState(() {});
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getMapBoxApiKey():" +
          e.toString());
    }
  }

  _getMapByFlag() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        final result = await apiHelper.getMapByFlag();
        if (result != null) {
          if (result.status == "1") {
            global.mapby = result.data;
          } else {
            hideLoader();
            global.mapby = null;
          }
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      print("Exception - splash_screen.dart - _getMapByFlag():" + e.toString());
    }
  }

  void _init() async {
    await br.getSharedPreferences();
    final List<dynamic> _ = await Future.wait([
      _getAppInfo(),
      _getMapByFlag(),
      _getGoogleMapApiKey(),
      _getMapBoxApiKey(),
      _getAppNotice(),
    ]);

    global.appDeviceId = await FirebaseMessaging.instance.getToken();

    if (global.sp?.getString('currentUser') == null) {
      PermissionStatus permissionStatus = await Permission.phone.status;
      if (!permissionStatus.isGranted) {
        permissionStatus = await Permission.phone.request();
      }
    }

    bool isConnected = await br.checkConnectivity();

    if (isConnected) {
      if (global.sp?.getString('currentUser') != null) {
        global.currentUser = CurrentUser.fromJson(
            json.decode(global.sp!.getString("currentUser")!));
        if (global.sp?.getString('lastloc') != null) {
          List<String> _tlist = global.sp!.getString('lastloc')!.split("|");
          global.lat = double.parse(_tlist[0]);
          global.lng = double.parse(_tlist[1]);
          final List<dynamic> _ = await Future.wait([
            getAddressFromLatLng(),
            getNearByStore(),
          ]);

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    analytics: widget.analytics,
                    observer: widget.observer,
                  )));
        } else {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => HomeScreen(
                    analytics: widget.analytics,
                    observer: widget.observer,
                  )));
        }
      } else {
        Get.to(() => IntroScreen(
              analytics: widget.analytics,
              observer: widget.observer,
            ));
      }
    } else {
      showNetworkErrorSnackBar(_scaffoldKey);
    }
  }
}
