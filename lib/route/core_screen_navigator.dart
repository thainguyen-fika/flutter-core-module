import 'dart:async';

import 'package:fk_core_package/application/core_application.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

import 'core_routes.dart';

class CoreScreenNavigator {
  void pop({bool returnResult = false}) {
    CoreRouter.navigatorKey.currentState.pop(returnResult);
  }

  void popUntil(String routePath) {
    CoreRouter.navigatorKey.currentState
        .popUntil(ModalRoute.withName(routePath));
  }

  void pushScreenIfUnableToPop(String routePath) {
    var isRouteExisted = false;
    CoreRouter.navigatorKey.currentState
        .popUntil((route) {
      if (routePath == route.settings.name) {
        isRouteExisted = true;
      }
      return false;
    });
    if (isRouteExisted) {
      this.popUntil(routePath);
    } else {
      this.pushScreen(routePath);
    }
  }

  Future<T> pushScreen<T extends Object>(String serviceName,
      {List<dynamic> params,
        bool isReplace = false,
        bool isRemoveStack = false,
        bool isPop = false}) {
    var routePath = serviceName;
    if (params != null && params.length > 0) {
      params.forEach((item) {
        //   - encode `/` to `$1234`
        //   - append param to routePathß
        dynamic encodeParams = item;
        if (item is String) {
          encodeParams = item.replaceAll("\/", CoreRouter.ENCODE_OF_ROUTER_KEY);
        }

        routePath = "$routePath/$encodeParams";
      });
    }
    return _handlePushScreenWithoutContext(routePath,
        replace: isReplace, clearStack: isRemoveStack, isPop: isPop);
  }

  Future _handlePushScreenWithoutContext(String path,
      {bool replace = false,
        bool isPop = false,
        bool clearStack = false,
        TransitionType transition,
        Duration transitionDuration = const Duration(milliseconds: 250),
        RouteTransitionsBuilder transitionBuilder}) {
    RouteMatch routeMatch = CoreRouter.router.matchRoute(
        CoreApplication.applicationContext, path,
        transitionType: transition,
        transitionsBuilder: transitionBuilder,
        transitionDuration: transitionDuration);
    Route<dynamic> route = routeMatch.route;
    Completer completer = Completer();
    Future future = completer.future;
    if (routeMatch.matchType == RouteMatchType.nonVisual) {
      completer.complete("Non visual route type.");
    } else {
      if (route != null) {
        if (clearStack) {
          future = CoreRouter.navigatorKey.currentState
              .pushAndRemoveUntil(route, (check) => false);
        } else {
          if (isPop) {
            future = CoreRouter.navigatorKey.currentState.popAndPushNamed(path);
          } else {
            future = replace
                ? CoreRouter.navigatorKey.currentState.pushReplacement(route)
                : CoreRouter.navigatorKey.currentState.push(route);
          }
        }
        completer.complete();
      } else {
        String error = "No registered route was found to handle '$path'.";
        print(error);
        completer.completeError(RouteNotFoundException(error, path));
      }
    }
    return future;
  }
}
