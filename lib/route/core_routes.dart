import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

abstract class CoreRouter {
  static FluroRouter router = FluroRouter();
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const ENCODE_OF_ROUTER_KEY = "\$!@#%^&*qazasdedcrfvbnhyukokm*&^%##@!\$";
}