import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/pos_screen/pos_process.dart';
import 'package:dedepos/model/json/pos_process_model.dart';

abstract class PosProcessEvent {
  final int holdNumber;
  PosProcessEvent({required this.holdNumber});
}

abstract class PosProcessState {}

class PosProcessStateInitialized extends PosProcessState {}

class PosProcessInitialized extends PosProcessEvent {
  PosProcessInitialized({required super.holdNumber});
}

class PosProcessLoading extends PosProcessState {}

class PosProcessClear extends PosProcessState {}

class ProcessEvent extends PosProcessEvent {
  ProcessEvent({required super.holdNumber});
}

class PosProcessFinish extends PosProcessEvent {
  PosProcessFinish({required super.holdNumber});
}

class PosProcessBloc extends Bloc<PosProcessEvent, PosProcessState> {
  PosProcessBloc() : super(PosProcessStateInitialized()) {
    on<PosProcessFinish>(_processFinish);
    on<ProcessEvent>(_process);
  }

  void _processFinish(
      PosProcessEvent event, Emitter<PosProcessState> emit) async {
    emit(PosProcessClear());
  }

  void _process(PosProcessEvent event, Emitter<PosProcessState> emit) async {
    emit(PosProcessLoading());
    PosProcessModel result = await PosProcess().process(event.holdNumber);
    PosProcess().sumCategoryCount(result);
    emit(PosProcessSuccess(result: result));
  }
}

class PosProcessSuccess extends PosProcessState {
  PosProcessModel result;
  PosProcessSuccess({required this.result});
}
