import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  final String? title;

  const EmptyData({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(
          child: Image(
            image: AssetImage('assets/images/logo.png'),
            width: 125,
            height: 125,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          title!,
          style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.black,
              ),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () {},
          style: const ButtonStyle(
              elevation: MaterialStatePropertyAll(0),
              backgroundColor: MaterialStatePropertyAll(Colors.red),
              padding: MaterialStatePropertyAll(EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 40,
              ))),
          child: Text(
            "Back To Ordering",
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ],
    ));
  }
}
