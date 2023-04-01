import 'dart:developer';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/pos_screen/pos_process.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/db/product_category_helper.dart';

abstract class ProductCategoryEvent {}

abstract class ProductCategoryState {}

class ProductCategoryStateInitialized extends ProductCategoryState {}

class ProductCategoryLoadStart extends ProductCategoryEvent {
  final String parentCategoryGuid;

  ProductCategoryLoadStart({required this.parentCategoryGuid});
}

class ProductCategoryLoadSuccess extends ProductCategoryState {
  ProductCategoryLoadSuccess();
}

class ProductCategoryBloc
    extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  final String categoryGuid;

  ProductCategoryBloc({required this.categoryGuid})
      : super(ProductCategoryStateInitialized()) {
    on<ProductCategoryLoadStart>(_productCategoryLoadStart);
    on<ProductCategoryLoadFinish>(_productCategoryLoadFinish);
  }

  void _productCategoryLoadStart(ProductCategoryLoadStart event,
      Emitter<ProductCategoryState> emit) async {
    emit(ProductCategoryLoading());
    global.productCategoryList =
        ProductCategoryHelper().selectByCategoryParentGuid(categoryGuid);
    PosProcess().sumCategoryCount(global.posProcessResult);
    emit(ProductCategoryLoadSuccess());
  }

  void _productCategoryLoadFinish(ProductCategoryLoadFinish event,
      Emitter<ProductCategoryState> emit) async {
    emit(ProductCategoryLoadStop());
  }
}

class ProductCategoryLoadStop extends ProductCategoryState {}

class ProductCategoryLoadFinish extends ProductCategoryEvent {}

class ProductCategoryLoading extends ProductCategoryState {}
