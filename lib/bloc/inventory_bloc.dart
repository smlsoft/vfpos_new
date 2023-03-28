import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/api/sync/api/api_repository.dart';
import 'package:dedepos/api/sync/model/sync_inventory.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final ApiRepository _inventoryRepository;

  InventoryBloc({required ApiRepository inventoryRepository})
      : _inventoryRepository = inventoryRepository,
        super(InventoryInitial()) {
    on<ListInventoryLoad>(_onListInventoryLoad);
    on<ListInventoryById>(_onGetInventoryId);
  }
  void _onListInventoryLoad(
      ListInventoryLoad event, Emitter<InventoryState> emit) async {
    emit(InventoryInProgress());

    try {
      final _result = await _inventoryRepository.getInventoryFetchUpdate(
          perPage: event.perPage, page: event.page, time: event.time);

      if (_result.success) {
        List<SyncProductBarcodeModel> _newItem = (_result.data["new"] as List)
            .map((newItem) => SyncProductBarcodeModel.fromJson(newItem))
            .toList();
        List<SyncProductBarcodeModel> _removeItem = (_result.data["remove"]
                as List)
            .map((removeItem) => SyncProductBarcodeModel.fromJson(removeItem))
            .toList();
        print(_newItem);
        print(_removeItem);
        emit(InventoryLoadSuccess(
            newItem: _newItem, removeItem: _removeItem, page: _result.page));
      } else {
        emit(InventoryLoadFailed(message: 'Inventory Not Found'));
      }
    } catch (e) {
      emit(InventoryLoadFailed(message: e.toString()));
    }
  }

  void _onGetInventoryId(
      ListInventoryById event, Emitter<InventoryState> emit) async {
    emit(InventorySearchInProgress());
    try {
      final _result = await _inventoryRepository.getInventoryId(event.id);

      if (_result.success) {
        SyncProductBarcodeModel _inventory =
            SyncProductBarcodeModel.fromJson(_result.data);
        print(_inventory);
        emit(InventorySearchLoadSuccess(inventory: _inventory));
      } else {
        emit(InventorySearchLoadFailed(message: 'Product Not Found'));
      }
    } catch (e) {
      emit(InventorySearchLoadFailed(message: e.toString()));
    }
  }
}

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class ListInventoryLoad extends InventoryEvent {
  final int page;
  final int perPage;
  final String time;

  ListInventoryLoad(
      {required this.page, required this.perPage, required this.time});

  @override
  List<Object> get props => [];
}

class ListInventoryById extends InventoryEvent {
  final String id;

  ListInventoryById({required this.id});

  @override
  List<Object> get props => [];
}

class InventorySaved extends InventoryEvent {
  final SyncProductBarcodeModel inventory;

  const InventorySaved({
    required this.inventory,
  });

  @override
  List<Object> get props => [inventory];
}

class InventoryUpdate extends InventoryEvent {
  final SyncProductBarcodeModel inventory;

  const InventoryUpdate({
    required this.inventory,
  });

  @override
  List<Object> get props => [inventory];
}

class InventoryDelete extends InventoryEvent {
  final String id;

  const InventoryDelete({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}

abstract class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object> get props => [];
}

//Load

class InventoryInitial extends InventoryState {}

class InventoryInProgress extends InventoryState {}

class InventoryLoadSuccess extends InventoryState {
  final List<SyncProductBarcodeModel> newItem;
  final List<SyncProductBarcodeModel> removeItem;
  final Pages? page;

  InventoryLoadSuccess(
      {required this.newItem, required this.removeItem, required this.page});

  InventoryLoadSuccess copyWith({
    List<SyncProductBarcodeModel>? newItem,
    List<SyncProductBarcodeModel>? removeItem,
    final Pages? page,
  }) =>
      InventoryLoadSuccess(
        newItem: newItem ?? this.newItem,
        removeItem: removeItem ?? this.removeItem,
        page: page ?? this.page,
      );

  @override
  List<Object> get props => [newItem, removeItem];
}

class InventoryLoadFailed extends InventoryState {
  final String message;
  InventoryLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//Search

class InventorySearchInProgress extends InventoryState {}

class InventorySearchLoadSuccess extends InventoryState {
  final SyncProductBarcodeModel inventory;

  InventorySearchLoadSuccess({
    required this.inventory,
  });

  @override
  List<Object> get props => [inventory];
}

class InventorySearchLoadFailed extends InventoryState {
  final String message;
  InventorySearchLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

//save
class InventoryFormInitial extends InventoryState {}

class InventoryFormSaveInProgress extends InventoryState {}

class InventoryFormSaveSuccess extends InventoryState {}

class InventoryFormSaveFailure extends InventoryState {
  final String message;
  const InventoryFormSaveFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// upgrade
class InventoryUpdateInitial extends InventoryState {}

class InventoryUpdateInProgress extends InventoryState {}

class InventoryUpdateSuccess extends InventoryState {}

class InventoryUpdateFailure extends InventoryState {
  final String message;
  const InventoryUpdateFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

// Delete
class InventoryDeleteInitial extends InventoryState {}

class InventoryDeleteInProgress extends InventoryState {}

class InventoryDeleteSuccess extends InventoryState {}

class InventoryDeleteFailure extends InventoryState {
  final String message;
  const InventoryDeleteFailure({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
