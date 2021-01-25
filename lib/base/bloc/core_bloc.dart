
import 'package:bloc/bloc.dart';
import 'package:fk_core_package/utitlies/rxbus/core_bus_messages.dart';
import 'package:fk_core_package/utitlies/rxbus/rxbus.dart';
import 'package:meta/meta.dart';

part 'core_bloc_event.dart';
part 'core_bloc_state.dart';

abstract class CoreBloc<CE extends CoreBlocEvent, CS extends CoreBlocState>
    extends Bloc<CE, CS> {
  CoreBloc(CS initialState) : super(initialState);

  String get busTag => this.runtimeType.toString();

  void onReady() {}

  void showProgressHub(bool shouldShow) {
    RxBus.post(ShowProgressHUB(shouldShow), tag: busTag);
  }

  void showToast(String toastMessage) {
    RxBus.post(ShowToastMessage(toastMessage), tag: busTag);
  }

  onStatefulDispose() {}

}
