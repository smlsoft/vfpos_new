import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/db/bill_helper.dart';

abstract class BillEvent {}

abstract class BillState {}

class BillStateInitialized extends BillState {}

class BillLoadSuccess extends BillState {
  List<BillObjectBoxStruct> result;

  BillLoadSuccess({required this.result});
}

class BillBloc extends Bloc<BillEvent, BillState> {
  BillBloc() : super(BillStateInitialized()) {
    on<BillLoad>(billLoadStart);
    on<BillLoadFinish>(billLoadFinish);
  }

  void billLoadStart(BillLoad event, Emitter<BillState> emit) async {
    emit(BillLoading());
    List<BillObjectBoxStruct> bills = BillHelper().selectOrderByDateTimeDesc();
    emit(BillLoadSuccess(result: bills));
  }

  void billLoadFinish(BillLoadFinish event, Emitter<BillState> emit) async {
    emit(BillLoadStop());
  }
}

class BillLoadStop extends BillState {}

class BillLoad extends BillEvent {}

class BillLoadFinish extends BillEvent {}

class BillLoading extends BillState {}
