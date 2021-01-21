import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class CoreAppView extends StatefulWidget {
  CoreAppView({Key key}) : super(key: key);
}

abstract class CoreAppViewState<CAV extends CoreAppView> extends State<CAV>
    with AfterLayoutMixin<CAV>, WidgetsBindingObserver {
  /// Methods
  void initResources(BuildContext context);

  Iterable<LocalizationsDelegate<dynamic>> initLocalizationsDelegate();

  Iterable<Locale> initSupportLocales();

  List<NavigatorObserver> initNavigatorObserver();

  Widget Function(BuildContext context, Widget child) initTransitionBuilder;

  Route onGenerateRoute(RouteSettings settings);

  GlobalKey<NavigatorState> navigatorGlobalKey;


  ThemeData initThemeData(BuildContext context) {
    return ThemeData(primarySwatch: Colors.blue);
  }

  ThemeMode initThemeMode() {
    return ThemeMode.light;
  }

  Locale defaultLocale() {
    return Locale('en');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    this.initResources(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: initThemeData(context),
      navigatorKey: navigatorGlobalKey,
      onGenerateRoute: onGenerateRoute,
      localizationsDelegates: initLocalizationsDelegate(),
      supportedLocales: initSupportLocales(),
      locale: defaultLocale(),
      themeMode: initThemeMode(),
      builder: initTransitionBuilder,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}
