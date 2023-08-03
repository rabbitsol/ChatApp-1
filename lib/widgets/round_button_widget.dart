import 'package:flutter/material.dart';

class RoundButtonWidget extends StatelessWidget {
  const RoundButtonWidget(
      {super.key,
      required this.title,
      required this.onpres,
      this.loading = false});
  final String title;
  final VoidCallback onpres;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpres,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.deepPurple, borderRadius: BorderRadius.circular(10)),
        child: Center(
            child: loading
                ? const CircularProgressIndicator(
                    strokeWidth: 3, color: Colors.white)
                : Text(
                    title,
                    style: const TextStyle(color: Colors.white),
                  )),
      ),
    );
  }
}
