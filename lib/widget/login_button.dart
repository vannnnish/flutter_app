import 'package:flutter/material.dart';

import '../util/color.dart';

class LoginButton extends StatelessWidget {
  final String title;

  // 是否可点击
  final bool enable;

  // 点击回调
  final VoidCallback? onPress;

  const LoginButton(this.title, {super.key, this.enable = true, this.onPress});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        height: 45,
        onPressed: enable ? onPress : null,
        disabledColor: primary[50],
        color: primary,
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
