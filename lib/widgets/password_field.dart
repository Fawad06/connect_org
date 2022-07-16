import 'package:connect_org/utils/validators.dart';
import 'package:flutter/material.dart';

class TextPasswordField extends StatefulWidget {
  final Function(String value)? onChanged;
  final FormFieldValidator<String>? validator;
  final String? labelText;
  final AutovalidateMode autovalidateMode;
  final ObscuringTextEditingController obscuringPasswordController;
  TextPasswordField({
    Key? key,
    this.onChanged,
    this.validator = Validators.passwordValidator,
    this.labelText,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    ObscuringTextEditingController? obscuringPasswordController,
  })  : obscuringPasswordController =
            obscuringPasswordController ?? ObscuringTextEditingController(),
        super(key: key);

  @override
  State<TextPasswordField> createState() => _TextPasswordFieldState();
}

class _TextPasswordFieldState extends State<TextPasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    widget.obscuringPasswordController.setObscureText = obscureText;
    return TextFormField(
      controller: widget.obscuringPasswordController,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.visiblePassword,
      autovalidateMode: widget.autovalidateMode,
      validator: widget.validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
        labelText: widget.labelText,
        suffixIcon: TextButton(
          onPressed: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class ObscuringTextEditingController extends TextEditingController {
  bool obscureText = true;
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    var displayValue = obscureText ? '•' * value.text.length : value.text;
    if (!value.composing.isValid || !withComposing) {
      return TextSpan(style: style, text: displayValue);
    }
    final TextStyle? composingStyle = style?.merge(
      const TextStyle(decoration: TextDecoration.none),
    );
    return TextSpan(
      style: style,
      children: <TextSpan>[
        TextSpan(text: value.composing.textBefore(displayValue)),
        TextSpan(
          style: composingStyle,
          text: value.composing.textInside(displayValue),
        ),
        TextSpan(text: value.composing.textAfter(displayValue)),
      ],
    );
  }

  set setObscureText(bool obscureText) {
    this.obscureText = obscureText;
    notifyListeners();
  }
}
