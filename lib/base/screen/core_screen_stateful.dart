import 'package:after_layout/after_layout.dart';
import 'package:fk_core_package/utitlies/type_def.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../bloc/core_bloc.dart';
import 'core_screen_mixin.dart';

abstract class CoreScreenStateful extends StatefulWidget {
  const CoreScreenStateful({Key key}) : super(key: key);
}

abstract class CoreScreenState<
        CE extends CoreBlocEvent,
        CS extends CoreBlocState,
        CB extends CoreBloc,
        CSF extends CoreScreenStateful> extends State<CSF>
    with AfterLayoutMixin<CSF>, CoreScreenMixin<CB> {

  ItemCreator<CB> _blocCreator;

  CoreScreenState(this._blocCreator) {
    bloc = _blocCreator();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    this.initWithContext(context);
    initOrientationMode(context);
    registerRxBus();
  }

  @override
  Widget build(BuildContext context) {
    return buildContentLayout(context);
  }

}