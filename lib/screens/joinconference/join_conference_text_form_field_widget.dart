import 'package:flutter/material.dart';

class JoinConferenceTextFormField extends StatefulWidget {
  const JoinConferenceTextFormField(
      {Key key,
      this.onChanged,
      this.validator,
      this.controller,
      this.hintText,
      this.prefixIcon})
      : super(key: key);

  final ValueChanged<String> onChanged;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;

  @override
  State<StatefulWidget> createState() => _StartViewTextFormField();
}

class _StartViewTextFormField extends State<JoinConferenceTextFormField> {
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {
        _showClearButton = widget.controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TextFormField(
        style: const TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          hintText: widget.hintText,
          filled: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          prefixIcon: widget.prefixIcon,
          suffixIcon: _getClearButton(),
        ),
        onChanged: widget.onChanged,
        validator: widget.validator,
        controller: widget.controller,
      ),
    );
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return null;
    }

    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: () => widget.controller.clear(),
      icon: const Icon(Icons.clear),
    );
  }
}
