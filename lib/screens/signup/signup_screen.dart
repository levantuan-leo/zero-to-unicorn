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
                        Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Create An Account",
                            style: Theme.of(context)
                                .textTheme
                                .headline2!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _UserInput(
                          labelText: 'Email',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(email: value),
                                );
                          },
                        ),
                        _UserInput(
                          labelText: 'Full Name',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(fullName: value),
                                );
                          },
                        ),
                        _UserInput(
                          labelText: 'Country',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(country: value),
                                );
                          },
                        ),
                        _UserInput(
                          labelText: 'City',
                          onChanged: (value) {
                            context.read<SignUpCubit>().userChanged(
                                  state.user!.copyWith(city: value),
                                );
                          },
                        ),
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
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SignUpCubit>().signUpWithCredentials();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            backgroundColor: Colors.red,
                            fixedSize: const Size(500, 50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign Up',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(width: 5.0),
                              const Icon(Icons.arrow_forward_ios_rounded)
                            ],
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
        return CustomTextFormField(
          placeholder: labelText,
          onChanged: onChanged,

        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      onChanged: (password) {
        context.read<SignUpCubit>().passwordChanged(password);
      },
      placeholder: "Password",
      obscureText: true,
    );
  }
}
