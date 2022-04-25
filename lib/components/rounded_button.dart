import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color _color;
  final String _text;
  final Function _function;
  // ignore: use_key_in_widget_constructors
  const RoundedButton(this._color, this._text, this._function);
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: _color,
      borderRadius: BorderRadius.circular(30.0),
      child: SizedBox(
        width: double.infinity,
        child: MaterialButton(
          onPressed: () async {
            await _function();
          },
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            _text,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
