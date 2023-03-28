import 'dart:developer';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/pos_screen/pos_process.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/db/product_category_helper.dart';

abstract class ProductGroupEvent {}

abstract class ProductGroupState {}

class ProductGroupStateInitialized extends ProductGroupState {}

class ProductGroupLoadStart extends ProductGroupEvent {
  final String parentGroupCode;

  ProductGroupLoadStart({required this.parentGroupCode});
}

class ProductGroupLoadSuccess extends ProductGroupState {
  ProductGroupLoadSuccess();
}

class ProductGroupBloc extends Bloc<ProductGroupEvent, ProductGroupState> {
  final String groupGuid;

  ProductGroupBloc({required this.groupGuid})
      : super(ProductGroupStateInitialized()) {
    on<ProductGroupLoadStart>(_productGroupLoadStart);
    on<ProductGroupLoadFinish>(_productGroupLoadFinish);
  }

  void _productGroupLoadStart(
      ProductGroupLoadStart event, Emitter<ProductGroupState> emit) async {
    emit(ProductGroupLoading());
    global.productCategoryList = ProductCategoryHelper()
        .selectByParentCategoryGuidOrderByXorder(parentCategoryGuid: groupGuid);
    PosProcess().sumGroupCount(global.posProcessResult);
    emit(ProductGroupLoadSuccess());
  }

  void _productGroupLoadFinish(
      ProductGroupLoadFinish event, Emitter<ProductGroupState> emit) async {
    emit(ProductGroupLoadStop());
  }
}

class ProductGroupLoadStop extends ProductGroupState {}

class ProductGroupLoadFinish extends ProductGroupEvent {}

class ProductGroupLoading extends ProductGroupState {}
