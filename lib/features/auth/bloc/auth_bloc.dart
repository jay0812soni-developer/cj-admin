import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/storage_service.dart';

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final String role;
  final String username;
  final String displayName;

  const Authenticated({
    required this.token,
    required this.role,
    required this.username,
    required this.displayName,
  });

  @override
  List<Object?> get props => [token, role, username, displayName];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class Unauthenticated extends AuthState {}

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthEvent extends AuthEvent {}

class LoginSubmittedEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginSubmittedEvent({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class LogoutEvent extends AuthEvent {}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) async {
    final auth = await StorageService.getAuth();
    if (auth['token'] != null && auth['role'] != null) {
      emit(Authenticated(
        token: auth['token']!,
        role: auth['role']!,
        username: auth['username'] ?? 'admin',
        displayName: auth['displayName'] ?? 'Admin',
      ));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginSubmitted(LoginSubmittedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    // 1. Try Backend API first
    try {
      final response = await ApiClient.dio.post(
        ApiEndpoints.login,
        data: {
          'username': event.username,
          'password': event.password,
        },
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final token = response.data['token'] as String;
        final user = response.data['user'] as Map<String, dynamic>;
        final role = user['role'] as String;
        final username = user['username'] as String;
        final displayName = (user['displayName'] ?? username) as String;

        await StorageService.saveAuth(
          token: token,
          role: role,
          username: username,
          displayName: displayName,
        );

        emit(Authenticated(
          token: token,
          role: role,
          username: username,
          displayName: displayName,
        ));
        return;
      }
    } catch (e) {
      // Offline fallback: Check seeded credentials
      final u = event.username.trim().toLowerCase();
      final p = event.password.trim();

      if (u == 'superadmin' && p == 'Super@12345') {
        const token = 'mock_superadmin_token_2026';
        await StorageService.saveAuth(
          token: token,
          role: 'superadmin',
          username: 'superadmin',
          displayName: 'Soni Jaykumar Hasmukh',
        );
        emit(const Authenticated(
          token: token,
          role: 'superadmin',
          username: 'superadmin',
          displayName: 'Soni Jaykumar Hasmukh',
        ));
        return;
      } else if (u == 'admin' && p == 'mVsr@1617') {
        const token = 'mock_admin_token_2026';
        await StorageService.saveAuth(
          token: token,
          role: 'admin',
          username: 'admin',
          displayName: 'Hasmukh Hiralal Soni',
        );
        emit(const Authenticated(
          token: token,
          role: 'admin',
          username: 'admin',
          displayName: 'Hasmukh Hiralal Soni',
        ));
        return;
      } else if (u == 'deven' && (p == 'mVsr@1617' || p == 'Deven@12345')) {
        const token = 'mock_deven_token_2026';
        await StorageService.saveAuth(
          token: token,
          role: 'deven',
          username: 'deven',
          displayName: 'Deven Hasmukhbhai Soni',
        );
        emit(const Authenticated(
          token: token,
          role: 'deven',
          username: 'deven',
          displayName: 'Deven Hasmukhbhai Soni',
        ));
        return;
      }
    }

    emit(const AuthError('Incorrect username or password. Please verify your credentials.'));
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await StorageService.clearAuth();
    emit(Unauthenticated());
  }
}
