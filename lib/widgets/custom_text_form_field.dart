import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.title,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  final String title;
  final String? initialValue;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
          ),
          Expanded(
            child: TextFormField(
              initialValue: initialValue,
              onChanged: onChanged,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                isDense: true,
                contentPadding:
                    const EdgeInsets.only(left: 10, top: 7, bottom: 8),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
