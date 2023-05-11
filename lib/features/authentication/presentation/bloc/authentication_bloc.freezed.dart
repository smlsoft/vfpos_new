// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AuthenticationEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userName, String password)
        onLoginWithUserPasswordTapped,
    required TResult Function() onLoginWithGoogleTapped,
    required TResult Function(User user) authenticated,
    required TResult Function() unAuthenticated,
    required TResult Function(User user) onAuthenticatedRefresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult? Function()? onLoginWithGoogleTapped,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unAuthenticated,
    TResult? Function(User user)? onAuthenticatedRefresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult Function()? onLoginWithGoogleTapped,
    TResult Function(User user)? authenticated,
    TResult Function()? unAuthenticated,
    TResult Function(User user)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginUserPasswordEvent value)
        onLoginWithUserPasswordTapped,
    required TResult Function(LoginWithGoogleEvent value)
        onLoginWithGoogleTapped,
    required TResult Function(AuthenticatedEvent value) authenticated,
    required TResult Function(UserLogoutEvent value) unAuthenticated,
    required TResult Function(AuthenticatedRefreshEvent value)
        onAuthenticatedRefresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult? Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult? Function(AuthenticatedEvent value)? authenticated,
    TResult? Function(UserLogoutEvent value)? unAuthenticated,
    TResult? Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult Function(AuthenticatedEvent value)? authenticated,
    TResult Function(UserLogoutEvent value)? unAuthenticated,
    TResult Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticationEventCopyWith<$Res> {
  factory $AuthenticationEventCopyWith(
          AuthenticationEvent value, $Res Function(AuthenticationEvent) then) =
      _$AuthenticationEventCopyWithImpl<$Res, AuthenticationEvent>;
}

/// @nodoc
class _$AuthenticationEventCopyWithImpl<$Res, $Val extends AuthenticationEvent>
    implements $AuthenticationEventCopyWith<$Res> {
  _$AuthenticationEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$LoginUserPasswordEventCopyWith<$Res> {
  factory _$$LoginUserPasswordEventCopyWith(_$LoginUserPasswordEvent value,
          $Res Function(_$LoginUserPasswordEvent) then) =
      __$$LoginUserPasswordEventCopyWithImpl<$Res>;
  @useResult
  $Res call({String userName, String password});
}

/// @nodoc
class __$$LoginUserPasswordEventCopyWithImpl<$Res>
    extends _$AuthenticationEventCopyWithImpl<$Res, _$LoginUserPasswordEvent>
    implements _$$LoginUserPasswordEventCopyWith<$Res> {
  __$$LoginUserPasswordEventCopyWithImpl(_$LoginUserPasswordEvent _value,
      $Res Function(_$LoginUserPasswordEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? password = null,
  }) {
    return _then(_$LoginUserPasswordEvent(
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$LoginUserPasswordEvent implements LoginUserPasswordEvent {
  const _$LoginUserPasswordEvent(
      {required this.userName, required this.password});

  @override
  final String userName;
  @override
  final String password;

  @override
  String toString() {
    return 'AuthenticationEvent.onLoginWithUserPasswordTapped(userName: $userName, password: $password)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginUserPasswordEvent &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userName, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginUserPasswordEventCopyWith<_$LoginUserPasswordEvent> get copyWith =>
      __$$LoginUserPasswordEventCopyWithImpl<_$LoginUserPasswordEvent>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userName, String password)
        onLoginWithUserPasswordTapped,
    required TResult Function() onLoginWithGoogleTapped,
    required TResult Function(User user) authenticated,
    required TResult Function() unAuthenticated,
    required TResult Function(User user) onAuthenticatedRefresh,
  }) {
    return onLoginWithUserPasswordTapped(userName, password);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult? Function()? onLoginWithGoogleTapped,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unAuthenticated,
    TResult? Function(User user)? onAuthenticatedRefresh,
  }) {
    return onLoginWithUserPasswordTapped?.call(userName, password);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult Function()? onLoginWithGoogleTapped,
    TResult Function(User user)? authenticated,
    TResult Function()? unAuthenticated,
    TResult Function(User user)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (onLoginWithUserPasswordTapped != null) {
      return onLoginWithUserPasswordTapped(userName, password);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginUserPasswordEvent value)
        onLoginWithUserPasswordTapped,
    required TResult Function(LoginWithGoogleEvent value)
        onLoginWithGoogleTapped,
    required TResult Function(AuthenticatedEvent value) authenticated,
    required TResult Function(UserLogoutEvent value) unAuthenticated,
    required TResult Function(AuthenticatedRefreshEvent value)
        onAuthenticatedRefresh,
  }) {
    return onLoginWithUserPasswordTapped(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult? Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult? Function(AuthenticatedEvent value)? authenticated,
    TResult? Function(UserLogoutEvent value)? unAuthenticated,
    TResult? Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
  }) {
    return onLoginWithUserPasswordTapped?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult Function(AuthenticatedEvent value)? authenticated,
    TResult Function(UserLogoutEvent value)? unAuthenticated,
    TResult Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (onLoginWithUserPasswordTapped != null) {
      return onLoginWithUserPasswordTapped(this);
    }
    return orElse();
  }
}

abstract class LoginUserPasswordEvent implements AuthenticationEvent {
  const factory LoginUserPasswordEvent(
      {required final String userName,
      required final String password}) = _$LoginUserPasswordEvent;

  String get userName;
  String get password;
  @JsonKey(ignore: true)
  _$$LoginUserPasswordEventCopyWith<_$LoginUserPasswordEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$LoginWithGoogleEventCopyWith<$Res> {
  factory _$$LoginWithGoogleEventCopyWith(_$LoginWithGoogleEvent value,
          $Res Function(_$LoginWithGoogleEvent) then) =
      __$$LoginWithGoogleEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoginWithGoogleEventCopyWithImpl<$Res>
    extends _$AuthenticationEventCopyWithImpl<$Res, _$LoginWithGoogleEvent>
    implements _$$LoginWithGoogleEventCopyWith<$Res> {
  __$$LoginWithGoogleEventCopyWithImpl(_$LoginWithGoogleEvent _value,
      $Res Function(_$LoginWithGoogleEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$LoginWithGoogleEvent implements LoginWithGoogleEvent {
  const _$LoginWithGoogleEvent();

  @override
  String toString() {
    return 'AuthenticationEvent.onLoginWithGoogleTapped()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoginWithGoogleEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userName, String password)
        onLoginWithUserPasswordTapped,
    required TResult Function() onLoginWithGoogleTapped,
    required TResult Function(User user) authenticated,
    required TResult Function() unAuthenticated,
    required TResult Function(User user) onAuthenticatedRefresh,
  }) {
    return onLoginWithGoogleTapped();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult? Function()? onLoginWithGoogleTapped,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unAuthenticated,
    TResult? Function(User user)? onAuthenticatedRefresh,
  }) {
    return onLoginWithGoogleTapped?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult Function()? onLoginWithGoogleTapped,
    TResult Function(User user)? authenticated,
    TResult Function()? unAuthenticated,
    TResult Function(User user)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (onLoginWithGoogleTapped != null) {
      return onLoginWithGoogleTapped();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginUserPasswordEvent value)
        onLoginWithUserPasswordTapped,
    required TResult Function(LoginWithGoogleEvent value)
        onLoginWithGoogleTapped,
    required TResult Function(AuthenticatedEvent value) authenticated,
    required TResult Function(UserLogoutEvent value) unAuthenticated,
    required TResult Function(AuthenticatedRefreshEvent value)
        onAuthenticatedRefresh,
  }) {
    return onLoginWithGoogleTapped(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult? Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult? Function(AuthenticatedEvent value)? authenticated,
    TResult? Function(UserLogoutEvent value)? unAuthenticated,
    TResult? Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
  }) {
    return onLoginWithGoogleTapped?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult Function(AuthenticatedEvent value)? authenticated,
    TResult Function(UserLogoutEvent value)? unAuthenticated,
    TResult Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (onLoginWithGoogleTapped != null) {
      return onLoginWithGoogleTapped(this);
    }
    return orElse();
  }
}

abstract class LoginWithGoogleEvent implements AuthenticationEvent {
  const factory LoginWithGoogleEvent() = _$LoginWithGoogleEvent;
}

/// @nodoc
abstract class _$$AuthenticatedEventCopyWith<$Res> {
  factory _$$AuthenticatedEventCopyWith(_$AuthenticatedEvent value,
          $Res Function(_$AuthenticatedEvent) then) =
      __$$AuthenticatedEventCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthenticatedEventCopyWithImpl<$Res>
    extends _$AuthenticationEventCopyWithImpl<$Res, _$AuthenticatedEvent>
    implements _$$AuthenticatedEventCopyWith<$Res> {
  __$$AuthenticatedEventCopyWithImpl(
      _$AuthenticatedEvent _value, $Res Function(_$AuthenticatedEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AuthenticatedEvent(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$AuthenticatedEvent implements AuthenticatedEvent {
  const _$AuthenticatedEvent({required this.user});

  @override
  final User user;

  @override
  String toString() {
    return 'AuthenticationEvent.authenticated(user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedEvent &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedEventCopyWith<_$AuthenticatedEvent> get copyWith =>
      __$$AuthenticatedEventCopyWithImpl<_$AuthenticatedEvent>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userName, String password)
        onLoginWithUserPasswordTapped,
    required TResult Function() onLoginWithGoogleTapped,
    required TResult Function(User user) authenticated,
    required TResult Function() unAuthenticated,
    required TResult Function(User user) onAuthenticatedRefresh,
  }) {
    return authenticated(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult? Function()? onLoginWithGoogleTapped,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unAuthenticated,
    TResult? Function(User user)? onAuthenticatedRefresh,
  }) {
    return authenticated?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult Function()? onLoginWithGoogleTapped,
    TResult Function(User user)? authenticated,
    TResult Function()? unAuthenticated,
    TResult Function(User user)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginUserPasswordEvent value)
        onLoginWithUserPasswordTapped,
    required TResult Function(LoginWithGoogleEvent value)
        onLoginWithGoogleTapped,
    required TResult Function(AuthenticatedEvent value) authenticated,
    required TResult Function(UserLogoutEvent value) unAuthenticated,
    required TResult Function(AuthenticatedRefreshEvent value)
        onAuthenticatedRefresh,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult? Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult? Function(AuthenticatedEvent value)? authenticated,
    TResult? Function(UserLogoutEvent value)? unAuthenticated,
    TResult? Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult Function(AuthenticatedEvent value)? authenticated,
    TResult Function(UserLogoutEvent value)? unAuthenticated,
    TResult Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class AuthenticatedEvent implements AuthenticationEvent {
  const factory AuthenticatedEvent({required final User user}) =
      _$AuthenticatedEvent;

  User get user;
  @JsonKey(ignore: true)
  _$$AuthenticatedEventCopyWith<_$AuthenticatedEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserLogoutEventCopyWith<$Res> {
  factory _$$UserLogoutEventCopyWith(
          _$UserLogoutEvent value, $Res Function(_$UserLogoutEvent) then) =
      __$$UserLogoutEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$UserLogoutEventCopyWithImpl<$Res>
    extends _$AuthenticationEventCopyWithImpl<$Res, _$UserLogoutEvent>
    implements _$$UserLogoutEventCopyWith<$Res> {
  __$$UserLogoutEventCopyWithImpl(
      _$UserLogoutEvent _value, $Res Function(_$UserLogoutEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$UserLogoutEvent implements UserLogoutEvent {
  const _$UserLogoutEvent();

  @override
  String toString() {
    return 'AuthenticationEvent.unAuthenticated()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$UserLogoutEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userName, String password)
        onLoginWithUserPasswordTapped,
    required TResult Function() onLoginWithGoogleTapped,
    required TResult Function(User user) authenticated,
    required TResult Function() unAuthenticated,
    required TResult Function(User user) onAuthenticatedRefresh,
  }) {
    return unAuthenticated();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult? Function()? onLoginWithGoogleTapped,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unAuthenticated,
    TResult? Function(User user)? onAuthenticatedRefresh,
  }) {
    return unAuthenticated?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult Function()? onLoginWithGoogleTapped,
    TResult Function(User user)? authenticated,
    TResult Function()? unAuthenticated,
    TResult Function(User user)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (unAuthenticated != null) {
      return unAuthenticated();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginUserPasswordEvent value)
        onLoginWithUserPasswordTapped,
    required TResult Function(LoginWithGoogleEvent value)
        onLoginWithGoogleTapped,
    required TResult Function(AuthenticatedEvent value) authenticated,
    required TResult Function(UserLogoutEvent value) unAuthenticated,
    required TResult Function(AuthenticatedRefreshEvent value)
        onAuthenticatedRefresh,
  }) {
    return unAuthenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult? Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult? Function(AuthenticatedEvent value)? authenticated,
    TResult? Function(UserLogoutEvent value)? unAuthenticated,
    TResult? Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
  }) {
    return unAuthenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult Function(AuthenticatedEvent value)? authenticated,
    TResult Function(UserLogoutEvent value)? unAuthenticated,
    TResult Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (unAuthenticated != null) {
      return unAuthenticated(this);
    }
    return orElse();
  }
}

abstract class UserLogoutEvent implements AuthenticationEvent {
  const factory UserLogoutEvent() = _$UserLogoutEvent;
}

/// @nodoc
abstract class _$$AuthenticatedRefreshEventCopyWith<$Res> {
  factory _$$AuthenticatedRefreshEventCopyWith(
          _$AuthenticatedRefreshEvent value,
          $Res Function(_$AuthenticatedRefreshEvent) then) =
      __$$AuthenticatedRefreshEventCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthenticatedRefreshEventCopyWithImpl<$Res>
    extends _$AuthenticationEventCopyWithImpl<$Res, _$AuthenticatedRefreshEvent>
    implements _$$AuthenticatedRefreshEventCopyWith<$Res> {
  __$$AuthenticatedRefreshEventCopyWithImpl(_$AuthenticatedRefreshEvent _value,
      $Res Function(_$AuthenticatedRefreshEvent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AuthenticatedRefreshEvent(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$AuthenticatedRefreshEvent implements AuthenticatedRefreshEvent {
  const _$AuthenticatedRefreshEvent({required this.user});

  @override
  final User user;

  @override
  String toString() {
    return 'AuthenticationEvent.onAuthenticatedRefresh(user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticatedRefreshEvent &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticatedRefreshEventCopyWith<_$AuthenticatedRefreshEvent>
      get copyWith => __$$AuthenticatedRefreshEventCopyWithImpl<
          _$AuthenticatedRefreshEvent>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String userName, String password)
        onLoginWithUserPasswordTapped,
    required TResult Function() onLoginWithGoogleTapped,
    required TResult Function(User user) authenticated,
    required TResult Function() unAuthenticated,
    required TResult Function(User user) onAuthenticatedRefresh,
  }) {
    return onAuthenticatedRefresh(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult? Function()? onLoginWithGoogleTapped,
    TResult? Function(User user)? authenticated,
    TResult? Function()? unAuthenticated,
    TResult? Function(User user)? onAuthenticatedRefresh,
  }) {
    return onAuthenticatedRefresh?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String userName, String password)?
        onLoginWithUserPasswordTapped,
    TResult Function()? onLoginWithGoogleTapped,
    TResult Function(User user)? authenticated,
    TResult Function()? unAuthenticated,
    TResult Function(User user)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (onAuthenticatedRefresh != null) {
      return onAuthenticatedRefresh(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LoginUserPasswordEvent value)
        onLoginWithUserPasswordTapped,
    required TResult Function(LoginWithGoogleEvent value)
        onLoginWithGoogleTapped,
    required TResult Function(AuthenticatedEvent value) authenticated,
    required TResult Function(UserLogoutEvent value) unAuthenticated,
    required TResult Function(AuthenticatedRefreshEvent value)
        onAuthenticatedRefresh,
  }) {
    return onAuthenticatedRefresh(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult? Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult? Function(AuthenticatedEvent value)? authenticated,
    TResult? Function(UserLogoutEvent value)? unAuthenticated,
    TResult? Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
  }) {
    return onAuthenticatedRefresh?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LoginUserPasswordEvent value)?
        onLoginWithUserPasswordTapped,
    TResult Function(LoginWithGoogleEvent value)? onLoginWithGoogleTapped,
    TResult Function(AuthenticatedEvent value)? authenticated,
    TResult Function(UserLogoutEvent value)? unAuthenticated,
    TResult Function(AuthenticatedRefreshEvent value)? onAuthenticatedRefresh,
    required TResult orElse(),
  }) {
    if (onAuthenticatedRefresh != null) {
      return onAuthenticatedRefresh(this);
    }
    return orElse();
  }
}

abstract class AuthenticatedRefreshEvent implements AuthenticationEvent {
  const factory AuthenticatedRefreshEvent({required final User user}) =
      _$AuthenticatedRefreshEvent;

  User get user;
  @JsonKey(ignore: true)
  _$$AuthenticatedRefreshEventCopyWith<_$AuthenticatedRefreshEvent>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AuthenticationState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(User user) loaded,
    required TResult Function(User user) authenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(User user)? loaded,
    TResult? Function(User user)? authenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(User user)? loaded,
    TResult Function(User user)? authenticated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthenticationInitialState value) initial,
    required TResult Function(AuthenticationLoadingState value) loading,
    required TResult Function(AuthenticationErrorState value) error,
    required TResult Function(AuthenticationLoadedState value) loaded,
    required TResult Function(AuthenticationAuthenticatedState value)
        authenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthenticationInitialState value)? initial,
    TResult? Function(AuthenticationLoadingState value)? loading,
    TResult? Function(AuthenticationErrorState value)? error,
    TResult? Function(AuthenticationLoadedState value)? loaded,
    TResult? Function(AuthenticationAuthenticatedState value)? authenticated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthenticationInitialState value)? initial,
    TResult Function(AuthenticationLoadingState value)? loading,
    TResult Function(AuthenticationErrorState value)? error,
    TResult Function(AuthenticationLoadedState value)? loaded,
    TResult Function(AuthenticationAuthenticatedState value)? authenticated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticationStateCopyWith<$Res> {
  factory $AuthenticationStateCopyWith(
          AuthenticationState value, $Res Function(AuthenticationState) then) =
      _$AuthenticationStateCopyWithImpl<$Res, AuthenticationState>;
}

/// @nodoc
class _$AuthenticationStateCopyWithImpl<$Res, $Val extends AuthenticationState>
    implements $AuthenticationStateCopyWith<$Res> {
  _$AuthenticationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$AuthenticationInitialStateCopyWith<$Res> {
  factory _$$AuthenticationInitialStateCopyWith(
          _$AuthenticationInitialState value,
          $Res Function(_$AuthenticationInitialState) then) =
      __$$AuthenticationInitialStateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthenticationInitialStateCopyWithImpl<$Res>
    extends _$AuthenticationStateCopyWithImpl<$Res,
        _$AuthenticationInitialState>
    implements _$$AuthenticationInitialStateCopyWith<$Res> {
  __$$AuthenticationInitialStateCopyWithImpl(
      _$AuthenticationInitialState _value,
      $Res Function(_$AuthenticationInitialState) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthenticationInitialState implements AuthenticationInitialState {
  const _$AuthenticationInitialState();

  @override
  String toString() {
    return 'AuthenticationState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationInitialState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(User user) loaded,
    required TResult Function(User user) authenticated,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(User user)? loaded,
    TResult? Function(User user)? authenticated,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(User user)? loaded,
    TResult Function(User user)? authenticated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthenticationInitialState value) initial,
    required TResult Function(AuthenticationLoadingState value) loading,
    required TResult Function(AuthenticationErrorState value) error,
    required TResult Function(AuthenticationLoadedState value) loaded,
    required TResult Function(AuthenticationAuthenticatedState value)
        authenticated,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthenticationInitialState value)? initial,
    TResult? Function(AuthenticationLoadingState value)? loading,
    TResult? Function(AuthenticationErrorState value)? error,
    TResult? Function(AuthenticationLoadedState value)? loaded,
    TResult? Function(AuthenticationAuthenticatedState value)? authenticated,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthenticationInitialState value)? initial,
    TResult Function(AuthenticationLoadingState value)? loading,
    TResult Function(AuthenticationErrorState value)? error,
    TResult Function(AuthenticationLoadedState value)? loaded,
    TResult Function(AuthenticationAuthenticatedState value)? authenticated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class AuthenticationInitialState implements AuthenticationState {
  const factory AuthenticationInitialState() = _$AuthenticationInitialState;
}

/// @nodoc
abstract class _$$AuthenticationLoadingStateCopyWith<$Res> {
  factory _$$AuthenticationLoadingStateCopyWith(
          _$AuthenticationLoadingState value,
          $Res Function(_$AuthenticationLoadingState) then) =
      __$$AuthenticationLoadingStateCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthenticationLoadingStateCopyWithImpl<$Res>
    extends _$AuthenticationStateCopyWithImpl<$Res,
        _$AuthenticationLoadingState>
    implements _$$AuthenticationLoadingStateCopyWith<$Res> {
  __$$AuthenticationLoadingStateCopyWithImpl(
      _$AuthenticationLoadingState _value,
      $Res Function(_$AuthenticationLoadingState) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthenticationLoadingState implements AuthenticationLoadingState {
  const _$AuthenticationLoadingState();

  @override
  String toString() {
    return 'AuthenticationState.loading()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationLoadingState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(User user) loaded,
    required TResult Function(User user) authenticated,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(User user)? loaded,
    TResult? Function(User user)? authenticated,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(User user)? loaded,
    TResult Function(User user)? authenticated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthenticationInitialState value) initial,
    required TResult Function(AuthenticationLoadingState value) loading,
    required TResult Function(AuthenticationErrorState value) error,
    required TResult Function(AuthenticationLoadedState value) loaded,
    required TResult Function(AuthenticationAuthenticatedState value)
        authenticated,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthenticationInitialState value)? initial,
    TResult? Function(AuthenticationLoadingState value)? loading,
    TResult? Function(AuthenticationErrorState value)? error,
    TResult? Function(AuthenticationLoadedState value)? loaded,
    TResult? Function(AuthenticationAuthenticatedState value)? authenticated,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthenticationInitialState value)? initial,
    TResult Function(AuthenticationLoadingState value)? loading,
    TResult Function(AuthenticationErrorState value)? error,
    TResult Function(AuthenticationLoadedState value)? loaded,
    TResult Function(AuthenticationAuthenticatedState value)? authenticated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class AuthenticationLoadingState implements AuthenticationState {
  const factory AuthenticationLoadingState() = _$AuthenticationLoadingState;
}

/// @nodoc
abstract class _$$AuthenticationErrorStateCopyWith<$Res> {
  factory _$$AuthenticationErrorStateCopyWith(_$AuthenticationErrorState value,
          $Res Function(_$AuthenticationErrorState) then) =
      __$$AuthenticationErrorStateCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$AuthenticationErrorStateCopyWithImpl<$Res>
    extends _$AuthenticationStateCopyWithImpl<$Res, _$AuthenticationErrorState>
    implements _$$AuthenticationErrorStateCopyWith<$Res> {
  __$$AuthenticationErrorStateCopyWithImpl(_$AuthenticationErrorState _value,
      $Res Function(_$AuthenticationErrorState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$AuthenticationErrorState(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AuthenticationErrorState implements AuthenticationErrorState {
  const _$AuthenticationErrorState(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'AuthenticationState.error(message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationErrorState &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticationErrorStateCopyWith<_$AuthenticationErrorState>
      get copyWith =>
          __$$AuthenticationErrorStateCopyWithImpl<_$AuthenticationErrorState>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(User user) loaded,
    required TResult Function(User user) authenticated,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(User user)? loaded,
    TResult? Function(User user)? authenticated,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(User user)? loaded,
    TResult Function(User user)? authenticated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthenticationInitialState value) initial,
    required TResult Function(AuthenticationLoadingState value) loading,
    required TResult Function(AuthenticationErrorState value) error,
    required TResult Function(AuthenticationLoadedState value) loaded,
    required TResult Function(AuthenticationAuthenticatedState value)
        authenticated,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthenticationInitialState value)? initial,
    TResult? Function(AuthenticationLoadingState value)? loading,
    TResult? Function(AuthenticationErrorState value)? error,
    TResult? Function(AuthenticationLoadedState value)? loaded,
    TResult? Function(AuthenticationAuthenticatedState value)? authenticated,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthenticationInitialState value)? initial,
    TResult Function(AuthenticationLoadingState value)? loading,
    TResult Function(AuthenticationErrorState value)? error,
    TResult Function(AuthenticationLoadedState value)? loaded,
    TResult Function(AuthenticationAuthenticatedState value)? authenticated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class AuthenticationErrorState implements AuthenticationState {
  const factory AuthenticationErrorState(final String message) =
      _$AuthenticationErrorState;

  String get message;
  @JsonKey(ignore: true)
  _$$AuthenticationErrorStateCopyWith<_$AuthenticationErrorState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthenticationLoadedStateCopyWith<$Res> {
  factory _$$AuthenticationLoadedStateCopyWith(
          _$AuthenticationLoadedState value,
          $Res Function(_$AuthenticationLoadedState) then) =
      __$$AuthenticationLoadedStateCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthenticationLoadedStateCopyWithImpl<$Res>
    extends _$AuthenticationStateCopyWithImpl<$Res, _$AuthenticationLoadedState>
    implements _$$AuthenticationLoadedStateCopyWith<$Res> {
  __$$AuthenticationLoadedStateCopyWithImpl(_$AuthenticationLoadedState _value,
      $Res Function(_$AuthenticationLoadedState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AuthenticationLoadedState(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$AuthenticationLoadedState implements AuthenticationLoadedState {
  const _$AuthenticationLoadedState({required this.user});

  @override
  final User user;

  @override
  String toString() {
    return 'AuthenticationState.loaded(user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationLoadedState &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticationLoadedStateCopyWith<_$AuthenticationLoadedState>
      get copyWith => __$$AuthenticationLoadedStateCopyWithImpl<
          _$AuthenticationLoadedState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(User user) loaded,
    required TResult Function(User user) authenticated,
  }) {
    return loaded(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(User user)? loaded,
    TResult? Function(User user)? authenticated,
  }) {
    return loaded?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(User user)? loaded,
    TResult Function(User user)? authenticated,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthenticationInitialState value) initial,
    required TResult Function(AuthenticationLoadingState value) loading,
    required TResult Function(AuthenticationErrorState value) error,
    required TResult Function(AuthenticationLoadedState value) loaded,
    required TResult Function(AuthenticationAuthenticatedState value)
        authenticated,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthenticationInitialState value)? initial,
    TResult? Function(AuthenticationLoadingState value)? loading,
    TResult? Function(AuthenticationErrorState value)? error,
    TResult? Function(AuthenticationLoadedState value)? loaded,
    TResult? Function(AuthenticationAuthenticatedState value)? authenticated,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthenticationInitialState value)? initial,
    TResult Function(AuthenticationLoadingState value)? loading,
    TResult Function(AuthenticationErrorState value)? error,
    TResult Function(AuthenticationLoadedState value)? loaded,
    TResult Function(AuthenticationAuthenticatedState value)? authenticated,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class AuthenticationLoadedState implements AuthenticationState {
  const factory AuthenticationLoadedState({required final User user}) =
      _$AuthenticationLoadedState;

  User get user;
  @JsonKey(ignore: true)
  _$$AuthenticationLoadedStateCopyWith<_$AuthenticationLoadedState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AuthenticationAuthenticatedStateCopyWith<$Res> {
  factory _$$AuthenticationAuthenticatedStateCopyWith(
          _$AuthenticationAuthenticatedState value,
          $Res Function(_$AuthenticationAuthenticatedState) then) =
      __$$AuthenticationAuthenticatedStateCopyWithImpl<$Res>;
  @useResult
  $Res call({User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$AuthenticationAuthenticatedStateCopyWithImpl<$Res>
    extends _$AuthenticationStateCopyWithImpl<$Res,
        _$AuthenticationAuthenticatedState>
    implements _$$AuthenticationAuthenticatedStateCopyWith<$Res> {
  __$$AuthenticationAuthenticatedStateCopyWithImpl(
      _$AuthenticationAuthenticatedState _value,
      $Res Function(_$AuthenticationAuthenticatedState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$AuthenticationAuthenticatedState(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc

class _$AuthenticationAuthenticatedState
    implements AuthenticationAuthenticatedState {
  const _$AuthenticationAuthenticatedState({required this.user});

  @override
  final User user;

  @override
  String toString() {
    return 'AuthenticationState.authenticated(user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationAuthenticatedState &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticationAuthenticatedStateCopyWith<
          _$AuthenticationAuthenticatedState>
      get copyWith => __$$AuthenticationAuthenticatedStateCopyWithImpl<
          _$AuthenticationAuthenticatedState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(String message) error,
    required TResult Function(User user) loaded,
    required TResult Function(User user) authenticated,
  }) {
    return authenticated(user);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(String message)? error,
    TResult? Function(User user)? loaded,
    TResult? Function(User user)? authenticated,
  }) {
    return authenticated?.call(user);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(String message)? error,
    TResult Function(User user)? loaded,
    TResult Function(User user)? authenticated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(user);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AuthenticationInitialState value) initial,
    required TResult Function(AuthenticationLoadingState value) loading,
    required TResult Function(AuthenticationErrorState value) error,
    required TResult Function(AuthenticationLoadedState value) loaded,
    required TResult Function(AuthenticationAuthenticatedState value)
        authenticated,
  }) {
    return authenticated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AuthenticationInitialState value)? initial,
    TResult? Function(AuthenticationLoadingState value)? loading,
    TResult? Function(AuthenticationErrorState value)? error,
    TResult? Function(AuthenticationLoadedState value)? loaded,
    TResult? Function(AuthenticationAuthenticatedState value)? authenticated,
  }) {
    return authenticated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AuthenticationInitialState value)? initial,
    TResult Function(AuthenticationLoadingState value)? loading,
    TResult Function(AuthenticationErrorState value)? error,
    TResult Function(AuthenticationLoadedState value)? loaded,
    TResult Function(AuthenticationAuthenticatedState value)? authenticated,
    required TResult orElse(),
  }) {
    if (authenticated != null) {
      return authenticated(this);
    }
    return orElse();
  }
}

abstract class AuthenticationAuthenticatedState implements AuthenticationState {
  const factory AuthenticationAuthenticatedState({required final User user}) =
      _$AuthenticationAuthenticatedState;

  User get user;
  @JsonKey(ignore: true)
  _$$AuthenticationAuthenticatedStateCopyWith<
          _$AuthenticationAuthenticatedState>
      get copyWith => throw _privateConstructorUsedError;
}
