import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sure_upload/models/user.dart';
import 'package:sure_upload/repositories/local_repository.dart';
import 'package:sure_upload/repositories/user_repository.dart';

abstract class UserEvent {}

class LoginEvent extends UserEvent {
  LoginEvent({required this.key});

  final String key;
}

class LoginWithTokenEvent extends UserEvent {
  LoginWithTokenEvent({required this.token});

  final String token;
}

class LogoutEvent extends UserEvent {}

abstract class UserState {}

class InitialUserState extends UserState {}

class LoginLoadingState extends UserState {}

class LoginDoneState extends UserState {
  LoginDoneState({
    required this.user,
  });

  final User user;
}

class LoginErrorState extends UserState {}

class LogoutDoneState extends UserState {}

class LogoutErrorState extends UserState {}

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required this.localRepository,
    required this.userRepository,
  }) : super(InitialUserState()) {
    on<LoginEvent>((event, emit) async {
      try {
        emit(LoginLoadingState());

        final loginRes = await userRepository.login(key: event.key);

        await localRepository.setToken(loginRes.token);

        final getUserRes = await userRepository.get();

        final user = getUserRes.user;

        if (user == null) {
          emit(LoginErrorState());
        } else {
          emit(LoginDoneState(user: user));
        }
      } catch (e) {
        emit(LoginErrorState());
      }
    });

    on<LoginWithTokenEvent>((event, emit) async {
      try {
        emit(LoginLoadingState());

        final getUserRes = await userRepository.get();

        final user = getUserRes.user;

        if (user == null) {
          emit(LoginErrorState());
        } else {
          emit(LoginDoneState(user: user));
        }
      } catch (e) {
        emit(LoginErrorState());
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        emit(LoginLoadingState());

        await localRepository.setToken(null);

        emit(LogoutDoneState());
      } catch (e) {
        emit(LogoutErrorState());
      }
    });
  }

  final LocalRepository localRepository;
  final UserRepository userRepository;
}
