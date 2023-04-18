part of 'signup_cubit.dart';

enum SignUpStatus { initial, submitting, success, error }

class SignUpState extends Equatable {
  final String password;
  final SignUpStatus status;
  final auth.User? authUser;
  final User? user;

  bool get isFormValid => user!.email.isNotEmpty && password.isNotEmpty;

  const SignUpState({
    required this.password,
    required this.status,
    this.authUser,
    this.user,
  });

  factory SignUpState.initial() {
    return SignUpState(
      password: '',
      status: SignUpStatus.initial,
      authUser: null,
      user: User(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [password, status, authUser, user];

  SignUpState copyWith({
    String? password,
    SignUpStatus? status,
    auth.User? authUser,
    User? user,
  }) {
    return SignUpState(
      password: password ?? this.password,
      status: status ?? this.status,
      authUser: authUser ?? this.authUser,
      user: user ?? this.user,
    );
  }
}
