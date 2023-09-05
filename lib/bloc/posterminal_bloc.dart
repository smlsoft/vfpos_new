import 'package:bloc/bloc.dart';
import 'package:dedepos/api/sync/model/posterminal_model.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/api/api_repository.dart';
import 'package:dedepos/api/sync/model/sync_inventory_model.dart';

class PosTerminalBloc extends Bloc<PosTerminalEvent, PosTerminalState> {
  final ApiRepository _posterminalRepository;

  PosTerminalBloc({required ApiRepository posterminalRepository})
      : _posterminalRepository = posterminalRepository,
        super(PosInitial()) {
    on<PosTerminalLoad>(_onPosTerminalLoad);
    on<PosTerminalSubmit>(_onPosTerminalSubmit);
  }
  void _onPosTerminalLoad(PosTerminalLoad event, Emitter<PosTerminalState> emit) async {
    emit(PosInProgress());

    try {
      final result = await _posterminalRepository.getPosTerminal();

      if (result.success) {
        final List<PosTerminalModel> posList = (result.data as List).map((newItem) => PosTerminalModel.fromJson(newItem)).toList();

        serviceLocator<Log>().debug(posList);
        emit(PosLoadSuccess(posList: posList));
      } else {
        emit(const PosLoadFailed(message: 'Pos Not Found'));
      }
    } catch (e) {
      emit(PosLoadFailed(message: e.toString()));
    }
  }

  void _onPosTerminalSubmit(PosTerminalSubmit event, Emitter<PosTerminalState> emit) async {
    emit(PosSubmitInitial());

    try {
      final result = await _posterminalRepository.activePosTerminal(event.shopId, event.pinCode, event.token, event.deviceId, event.token, event.isdev);

      if (result.success) {
        emit(const PosSubmitSuccess());
      } else {
        emit(const PosLoadFailed(message: 'Pos Not Found'));
      }
    } catch (e) {
      emit(PosLoadFailed(message: e.toString()));
    }
  }
}

abstract class PosTerminalEvent extends Equatable {
  const PosTerminalEvent();

  @override
  List<Object> get props => [];
}

class PosTerminalLoad extends PosTerminalEvent {
  const PosTerminalLoad();

  @override
  List<Object> get props => [];
}

class PosTerminalSubmit extends PosTerminalEvent {
  final String pinCode;
  final String shopId;
  final String token;
  final String deviceId;
  final String actoken;
  final String isdev;
  const PosTerminalSubmit({required this.pinCode, required this.shopId, required this.token, required this.deviceId, required this.actoken, required this.isdev});

  @override
  List<Object> get props => [pinCode, shopId, token, deviceId, actoken, isdev];
}

abstract class PosTerminalState extends Equatable {
  const PosTerminalState();

  @override
  List<Object> get props => [];
}

class PosInitial extends PosTerminalState {}

class PosInProgress extends PosTerminalState {}

class PosLoadSuccess extends PosTerminalState {
  final List<PosTerminalModel> posList;

  const PosLoadSuccess({required this.posList});

  PosLoadSuccess copyWith({
    List<PosTerminalModel>? posList,
  }) =>
      PosLoadSuccess(
        posList: posList ?? this.posList,
      );

  @override
  List<Object> get props => [posList];
}

class PosLoadFailed extends PosTerminalState {
  final String message;
  const PosLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class PosSubmitInitial extends PosTerminalState {}

class PosSubmitInProgress extends PosTerminalState {}

class PosSubmitSuccess extends PosTerminalState {
  const PosSubmitSuccess();

  @override
  List<Object> get props => [];
}

class PosSubmitLoadFailed extends PosTerminalState {
  final String message;
  const PosSubmitLoadFailed({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
