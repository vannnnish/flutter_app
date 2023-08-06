import 'package:flutter/material.dart';
import 'package:flutter_app/util/color.dart';

class LoginInput extends StatefulWidget {
  final String title;
  final String hint;
  final ValueChanged<String> onChanged;
  final ValueChanged<bool>? focusChanged;
  final bool lineStretch;
  final bool obscureText;
  final TextInputType? keyboardType;

  const LoginInput(
      {super.key,
      required this.title,
      required this.hint,
      required this.onChanged,
      this.focusChanged,
      this.lineStretch = false,
      this.obscureText = false,
      this.keyboardType});

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  // 获取光标
  final _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // 是否获取光标的监听
    _focusNode.addListener(() {
      print("object:${_focusNode.hasFocus}");
      widget.focusChanged!(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    // 在页面释放的时候，取消focus
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              width: 100,
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            _input()
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: !widget.lineStretch ? 15 : 0),
          child: Divider(
            height: 1,
            thickness: 0.5,
          ),
        )
      ],
    );
  }

  _input() {
    // 这个控件，可以尽可能填充剩余空间
    return Expanded(
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        autofocus: !widget.obscureText,
        cursorColor: primary,
        style: const TextStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.w300),
        decoration: InputDecoration(
            // 内容边距
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            border: InputBorder.none,
            hintText: widget.hint ?? '',
            hintStyle: const TextStyle(fontSize: 15, color: Colors.grey)),
      ),
    );
  }
}
