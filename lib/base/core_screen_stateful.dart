import 'package:after_layout/after_layout.dart';
import 'package:fk_core_package/resources/CoreColors.dart';
import 'package:fk_core_package/utitlies/rxbus/CoreBusMessages.dart';
import 'package:fk_core_package/utitlies/rxbus/rxbus.dart';
import 'package:fk_core_package/utitlies/type_def.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'bloc/core_bloc.dart';

abstract class CoreScreenStateful extends StatefulWidget {
  const CoreScreenStateful({Key key}) : super(key: key);
}

abstract class CoreScreenState<
CE extends CoreBlocEvent,
CS extends CoreBlocState,
CB extends CoreBloc,
CSF extends CoreScreenStateful> extends State<CSF>
    with AfterLayoutMixin<CSF> {
  ItemCreator<CB> _blocCreator;
  GlobalKey<ScaffoldState> scaffoldToastKey = new GlobalKey();

  @protected
  CB bloc;

  @protected
  bool _loading = false;

  var _isLargeScreen = false;

  var _useSafeArea = true;

  set useSafeArea(bool useSafeArea) {
    this._useSafeArea = useSafeArea;
  }

  var _textScaleFactor = 1.0;

  set textScaleFactor(double scaleFactor) {
    _textScaleFactor = scaleFactor;
  }

  Widget _indicatorWidget;

  set indicatorWidget(Widget indicator) {
    _indicatorWidget = indicator;
  }

  CoreScreenState(this._blocCreator) {
    bloc = _blocCreator();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    this.initWithContext(context);
    initOrientationMode(context);
  }

  @override
  Widget build(BuildContext context) {
    initOrientationMode(context);
    Widget mainContent = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: _isLargeScreen ? buildTabletLayout(context) : buildLayout(context),
    );
    Widget scaffold = Material(
        child: MediaQuery(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: scaffoldToastKey,
            appBar: createAppBarContent(context),
            body: this._useSafeArea
                ? SafeArea(bottom: false, child: mainContent)
                : mainContent,
            bottomNavigationBar: bottomNavigationBar(context),
          ),
          data: MediaQuery.of(context).copyWith(
              textScaleFactor: _textScaleFactor),
        ));
    return ProgressHUD(
      child: scaffold,
      indicatorColor: CoreColors.progressWidgetColor,
      backgroundColor: CoreColors.loadingBoxBackgroundColor,
      barrierColor: CoreColors.loadingBackgroundColor,
      indicatorWidget: _indicatorWidget,
    );
  }

  void showProgressHUD(bool shouldShow) {
    if (!mounted) return;
    Future.delayed(Duration.zero, () {
      _loading = shouldShow;
      ProgressHUD.of(context).dismiss();
      if (_loading) {
        ProgressHUD.of(context).show();
      }
    });
  }

  void initOrientationMode(BuildContext context) {
    if (Device
        .get()
        .isTablet) {
      _isLargeScreen = true;
    } else {
      _isLargeScreen = false;
    }
  }

  void registerRxBus() {
    RxBus.register<ShowProgressHUB>(tag: this.bloc.busTag).listen((message) {
      showProgressHUD(message.shouldShow);
    });
    RxBus.register<ShowToastMessage>(tag: this.bloc.busTag).listen((message) {
      showToastMessage(message.toastText);
    });
  }

  void showToastMessage(String message,
      [ToastGravity gravity = ToastGravity.CENTER, double textSize = 16.0]) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: gravity,
        timeInSecForIosWeb: 1,
        backgroundColor: CoreColors.toastBackgroundColor,
        textColor: CoreColors.toastTextColor,
        fontSize: textSize);
  }

  @protected
  Widget buildLayout(BuildContext context);

  Widget buildTabletLayout(BuildContext context) {
    return buildLayout(context);
  }

  @protected
  Widget createAppBarContent(BuildContext context) {
    return null;
  }

  @protected
  Widget bottomNavigationBar(BuildContext context) {
    return null;
  }

  void initWithContext(BuildContext context);
}
