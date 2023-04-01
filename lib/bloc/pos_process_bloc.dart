import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/pos_screen/pos_process.dart';
import 'package:dedepos/model/json/pos_process_struct.dart';
import 'package:dedepos/global.dart' as global;

abstract class PosProcessEvent {}

abstract class PosProcessState {}

class PosProcessStateInitialized extends PosProcessState {}

class PosProcessInitialized extends PosProcessEvent {}

class PosProcessLoading extends PosProcessState {}

class PosProcessClear extends PosProcessState {}

class ProcessEvent extends PosProcessEvent {}

class PosProcessFinish extends PosProcessEvent {}

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
    PosProcessStruct result = await PosProcess().process();
    PosProcess().sumCategoryCount(result);
    emit(PosProcessSuccess(result: result));
  }
}

class PosProcessSuccess extends PosProcessState {
  PosProcessStruct result;
  PosProcessSuccess({required this.result});
}
