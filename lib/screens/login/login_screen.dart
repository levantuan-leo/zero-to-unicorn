import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../cubits/cubits.dart';
import '/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const LoginScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Login",
        hideActions: true,
      ),
      bottomNavigationBar: const CustomNavBar(screen: routeName),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5.0)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Text(
                      'Zero To Unicorn',
                      style: Theme.of(context).textTheme.headline3!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  _GoogleLoginButton(),
                  const SizedBox(height: 5.0),
                  _FacebookLoginButton(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Stack(alignment: Alignment.center, children: [
                  const Divider(
                    thickness: 1,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Text("Continue with your email",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.black)),
                  )
                ]),
              ),
              _EmailInput(),
              _PasswordInput(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<LoginCubit>().logInWithCredentials();
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
                      'Login',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(width: 5.0),
                    const Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 5),
                constraints: const BoxConstraints(maxWidth: 300),
                child: Center(
                  child: Text(
                    "By creating an account, you accept our T&C and Privacy Policies",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return CustomTextFormField(
          placeholder: 'Email',
          onChanged: (email) {
            context.read<LoginCubit>().emailChanged(email);
          },
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return CustomTextFormField(
          placeholder: 'Password',
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
          obscureText: true,
        );
      },
    );
  }
}

class _GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<LoginCubit>().logInWithGoogle();
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        backgroundColor: Colors.white,
        fixedSize: const Size(500, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sign In with Google',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Colors.red.withAlpha(200),
                ),
          ),
          Container(
              width: 50,
              height: 25,
              decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.red))),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/google-plus.svg',
                  height: 25,
                  width: 25,
                ),
              )),
        ],
      ),
    );
  }
}

class _FacebookLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<LoginCubit>().logInWithGoogle();
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(),
        backgroundColor: Colors.white,
        fixedSize: const Size(500, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Sign In with Facebook',
            style: Theme.of(context).textTheme.headline4!.copyWith(
                  color: Colors.blue,
                ),
          ),
          Container(
            width: 50,
            height: 20,
            decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Colors.blue))),
            child: Center(
              child: SvgPicture.asset(
                'assets/svgs/facebook.svg',
                height: 20,
                width: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
