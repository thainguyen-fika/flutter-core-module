import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

abstract class CoreApplication extends StatefulWidget {
  CoreApplication({Key key}) : super(key: key) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  static BuildContext applicationContext;
  set setApplicationContext(BuildContext context) {
    applicationContext = context;
  }

}

abstract class CoreApplicationState<CA extends CoreApplication>
    extends State<CA> with AfterLayoutMixin<CA> {
  @override
  void afterFirstLayout(BuildContext context) {
    widget.setApplicationContext = context;
    initComponents(context);
  }

  void initComponents(BuildContext context) {}
}
