import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final bool automaticallyImplyLeading;
  final bool hideActions;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.automaticallyImplyLeading = true,
    this.hideActions = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.red),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: Colors.red),
        constraints:
            const BoxConstraints(minWidth: 0, maxHeight: double.infinity),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.white),
        ),
      ),
      actions: [
        hideActions
            ? const SizedBox()
            : IconButton(
          icon: const Icon(
            Icons.favorite,
                  color: Colors.red,
          ),
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/wishlist',
            );
          },
              ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
