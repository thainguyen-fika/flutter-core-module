import 'package:fk_core_package/base/screen/core_screen_mixin.dart';
import 'package:fk_core_package/utitlies/type_def.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import '../bloc/core_bloc.dart';

// ignore: must_be_immutable
abstract class CoreScreenStateless<CE extends CoreBlocEvent,
    CS extends CoreBlocState, CB extends CoreBloc> extends StatelessWidget with CoreScreenMixin<CB> {
  CoreScreenStateless(this._blocCreator, {Key key}) : super(key: key) {
    bloc = _blocCreator();
  }

  ItemCreator<CB> _blocCreator;
  bool _haveInitialized = false;
  BuildContext _context;

  void initDependencies(BuildContext context) {
    this._context = context;
    if (_haveInitialized == true) return;
    initWithContext(context);
    initOrientationMode(context);
    registerRxBus();
    _haveInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    initDependencies(context);
    return buildContentLayout(context);
  }

  void showProgressHUD(bool shouldShow) {
    Future.delayed(Duration.zero, () {
      isLoading = shouldShow;
      ProgressHUD.of(this._context).dismiss();
      if (isLoading) {
        ProgressHUD.of(this._context).show();
      }
    });
  }


}
