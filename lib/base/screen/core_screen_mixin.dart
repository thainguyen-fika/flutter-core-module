import 'package:fk_core_package/base/bloc/core_bloc.dart';
import 'package:fk_core_package/resources/core_colors.dart';
import 'package:fk_core_package/utitlies/rxbus/core_bus_messages.dart';
import 'package:fk_core_package/utitlies/rxbus/rxbus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class CoreScreenMixin<CB extends CoreBloc> {
  var _textScaleFactor = 1.0;
  bool _isLoading = false;
  var _isLargeScreen = false;
  var _useSafeArea = true;
  Widget _indicatorWidget;
  GlobalKey<ScaffoldState> _scaffoldToastKey = new GlobalKey();
  @protected
  CB bloc;

  @protected
  Color _backgroundColor = CoreColors.White;

  double get textScaleFactor => this._textScaleFactor;

  bool get isLargeScreen => this._isLargeScreen;

  bool get isLoading => this._isLoading;

  bool get useSafeArea => this._useSafeArea;

  Widget get indicatorWidget => this._indicatorWidget;

  GlobalKey<ScaffoldState> get scaffoldToastKey => this._scaffoldToastKey;

  set isLoading(bool isLoading) => this._isLoading = isLoading;

  set indicatorWidget(Widget indicator) {
    _indicatorWidget = indicator;
  }

  set textScaleFactor(double scaleFactor) {
    _textScaleFactor = scaleFactor;
  }

  void initWithContext(BuildContext context) {}

  void registerRxBus() {
    RxBus.register<ShowProgressHUB>(tag: this.bloc.busTag).listen((message) {
      showProgressHUD(message.shouldShow);
    });
    RxBus.register<ShowToastMessage>(tag: this.bloc.busTag).listen((message) {
      showToastMessage(message.toastText);
    });
  }

  void showProgressHUD(bool shouldShow);

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

  void initOrientationMode(BuildContext context) {
    if (Device.get().isTablet) {
      _isLargeScreen = true;
    } else {
      _isLargeScreen = false;
    }
  }

  Widget buildContentLayout(BuildContext context) {
    Widget mainContent = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: isLargeScreen ? buildTabletLayout(context) : buildLayout(context),
    );
    Widget scaffold = Material(
        child: MediaQuery(
      child: Scaffold(
        backgroundColor: _backgroundColor,
        resizeToAvoidBottomInset: false,
        key: scaffoldToastKey,
        appBar: createAppBarContent(context),
        body: this.useSafeArea
            ? SafeArea(bottom: false, child: mainContent)
            : mainContent,
        bottomNavigationBar: bottomNavigationBar(context),
      ),
      data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
    ));
    return ProgressHUD(
      child: Builder(
        builder: (context) {
          return scaffold;
        },
      ),
      indicatorColor: CoreColors.progressWidgetColor,
      backgroundColor: CoreColors.loadingBoxBackgroundColor,
      barrierColor: CoreColors.loadingBackgroundColor,
      indicatorWidget: indicatorWidget,
    );
  }
}
