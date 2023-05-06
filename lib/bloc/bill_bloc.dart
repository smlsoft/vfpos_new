import 'package:dedepos/global.dart' as global;
import 'package:dedepos/db/bill_detail_helper.dart';
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

class BillLoadByDocNumberSuccess extends BillState {
  BillObjectBoxStruct? bill;
  List<BillDetailObjectBoxStruct> billDetails = [];

  BillLoadByDocNumberSuccess({required this.bill, this.billDetails = const []});
}

class BillBloc extends Bloc<BillEvent, BillState> {
  BillBloc() : super(BillStateInitialized()) {
    on<BillLoad>(billLoadStart);
    on<BillLoadFinish>(billLoadFinish);
    on<BillLoadByDocNumber>(billLoadByDocNumberStart);
    on<BillLoadByDocNumberFinish>(billLoadByDocNumberFinish);
  }

  void billLoadStart(BillLoad event, Emitter<BillState> emit) async {
    emit(BillLoading());
    List<BillObjectBoxStruct> bills = BillHelper()
        .selectOrderByDateTimeDesc(posScreenMode: global.posScreenToInt());
    emit(BillLoadSuccess(result: bills));
  }

  void billLoadByDocNumberStart(
      BillLoadByDocNumber event, Emitter<BillState> emit) async {
    emit(BillLoadingByDocNumber());
    BillObjectBoxStruct? bill = BillHelper().selectByDocNumber(
        docNumber: event.docNumber, posScreenMode: global.posScreenToInt());
    if (bill != null) {
      List<BillDetailObjectBoxStruct> billDetails =
          BillDetailHelper().selectByDocNumber(docNumber: bill.doc_number);
      emit(BillLoadByDocNumberSuccess(bill: bill, billDetails: billDetails));
    } else {
      emit(BillLoadByDocNumberSuccess(bill: bill, billDetails: []));
    }
  }

  void billLoadFinish(BillLoadFinish event, Emitter<BillState> emit) async {
    emit(BillLoadStop());
  }

  void billLoadByDocNumberFinish(
      BillLoadByDocNumberFinish event, Emitter<BillState> emit) async {
    emit(BillLoadByDocNumberStop());
  }
}

class BillLoadStop extends BillState {}

class BillLoad extends BillEvent {}

class BillLoadFinish extends BillEvent {}

class BillLoading extends BillState {}

class BillLoadByDocNumber extends BillEvent {
  final String docNumber;

  BillLoadByDocNumber({required this.docNumber});
}

class BillLoadByDocNumberStop extends BillState {}

class BillLoadByDocNumberFinish extends BillEvent {}

class BillLoadingByDocNumber extends BillState {}
