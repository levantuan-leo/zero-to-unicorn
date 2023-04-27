import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 5),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.only(bottom: 5),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.red, width: 2),
            ),
          ),
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .headline3!
                .apply(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
