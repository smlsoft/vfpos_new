import 'package:dedepos/model/find/find_member_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedepos/api/rest_api.dart';

class FindMemberByTelNameLoadStart extends FindMemberByTelNameEvent {
  final String words;
  final int offset;
  final int limit;

  FindMemberByTelNameLoadStart(this.words, this.offset, this.limit);
}

class FindMemberByTelNameLoadSuccess extends FindMemberByTelNameState {
  List<FindMemberModel> result;

  FindMemberByTelNameLoadSuccess({required this.result});
}

class FindMemberByTelNameBloc
    extends Bloc<FindMemberByTelNameEvent, FindMemberByTelNameState> {
  final RestApiFindMemberByTelName apiFindMemberByTelName;

  final int? offset;
  final int? limit;

  FindMemberByTelNameBloc(
      {required this.apiFindMemberByTelName, this.offset, this.limit})
      : super(FindMemberByTelNameInitial()) {
    on<FindMemberByTelNameLoadStart>(_findMemberByTelName);
    on<FindMemberByTelNameLoadFinish>(_findMemberByTelNameLoadFinish);
  }

  void _findMemberByTelName(FindMemberByTelNameLoadStart event,
      Emitter<FindMemberByTelNameState> emit) async {
    emit(FindMemberByTelNameLoading());
    List<FindMemberModel> result = await apiFindMemberByTelName
        .findMemberByTelName(event.words, event.offset, event.limit);
    emit(FindMemberByTelNameLoadSuccess(result: result));
  }

  void _findMemberByTelNameLoadFinish(FindMemberByTelNameLoadFinish event,
      Emitter<FindMemberByTelNameState> emit) async {
    emit(FindMemberByTelNameLoadStop());
  }
}

abstract class FindMemberByTelNameEvent {}

class FindMemberByTelNameLoadFinish extends FindMemberByTelNameEvent {}

abstract class FindMemberByTelNameState {}

class FindMemberByTelNameInitial extends FindMemberByTelNameState {}

class FindMemberByTelNameLoading extends FindMemberByTelNameState {}

class FindMemberByTelNameLoaded extends FindMemberByTelNameState {}

class FindMemberByTelNameFound extends FindMemberByTelNameState {}

class FindMemberByTelNameNotFound extends FindMemberByTelNameState {}

class FindMemberByTelNameLoadStop extends FindMemberByTelNameState {}
