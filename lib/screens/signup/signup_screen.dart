import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/cubits.dart';
import '/widgets/widgets.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = '/signup';

  const SignUpScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SignUpScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Sign Up'),
      bottomNavigationBar: const CustomNavBar(screen: routeName),
      body: BlocBuilder<SignUpCubit, SignUpState>(
        builder: (context, state) {
          return LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _UserInput(
                          labelText: 'Email',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(email: value),
                                );
                          },
                        ),
                        const SizedBox(height: 10),
                        _UserInput(
                          labelText: 'Full Name',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(fullName: value),
                                );
                          },
                        ),
                        const SizedBox(height: 10),
                        _UserInput(
                          labelText: 'Country',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(country: value),
                                );
                          },
                        ),
                        const SizedBox(height: 10),
                        _UserInput(
                          labelText: 'City',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(city: value),
                                );
                          },
                        ),
                        const SizedBox(height: 10),
                        _UserInput(
                          labelText: 'Address',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(address: value),
                                );
                          },
                        ),
                        _UserInput(
                          labelText: 'ZIP Code',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(zipCode: value),
                                );
                          },
                        ),
                        _PasswordInput(),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SignUpCubit>().signUpWithCredentials();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(),
                            backgroundColor: Colors.red,
                            fixedSize: const Size(200, 40),
                          ),
                          child: Text(
                            'SignUp',
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class _UserInput extends StatelessWidget {
  const _UserInput({
    Key? key,
    required this.onChanged,
    required this.labelText,
  }) : super(key: key);

  final Function(String)? onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return TextField(
          onChanged: onChanged,
          decoration: InputDecoration(labelText: labelText),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (password) {
        context.read<SignUpCubit>().passwordChanged(password);
      },
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
    );
  }
}
