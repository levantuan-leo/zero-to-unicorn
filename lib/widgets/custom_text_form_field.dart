import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.title,
    this.placeholder,
    this.obscureText = false,
    this.initialValue,
    this.onChanged,
  }) : super(key: key);

  final String? title;
  final bool obscureText;
  final String? placeholder;
  final String? initialValue;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          title != null
              ? SizedBox(
            width: 75,
            child: Text(
                    title!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black),
            ),
                )
              : const SizedBox(),
          Expanded(
            child: TextFormField(
obscureText: obscureText,
              initialValue: initialValue,
              onChanged: onChanged,
              decoration: InputDecoration(
                labelText: placeholder,
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(color: Colors.grey.shade300)),
                isDense: true,
                contentPadding:
                    const EdgeInsets.only(left: 10, top: 10, bottom: 10),
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
