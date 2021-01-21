
import 'package:bloc/bloc.dart';
import 'package:fk_core_package/utitlies/type_def.dart';
import 'package:meta/meta.dart';

part 'core_bloc_event.dart';
part 'core_bloc_state.dart';

abstract class CoreBloc<CE extends CoreBlocEvent, CS extends CoreBlocState>
    extends Bloc<CE, CS> {
  CoreBloc(this._initStateCreator) : super(_initStateCreator());

  String get busTag => this.runtimeType.toString();

  ItemCreator<CS> _initStateCreator;


}
