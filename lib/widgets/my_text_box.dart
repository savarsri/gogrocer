import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextBox extends StatefulWidget {
  // Hint text for text field
  final List<String> hintTexts;

  // Callback functions
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Function? onEditingComplete;
  final Function(String?)? onSaved;

  // Other properties
  final TextInputType? keyboardType;
  final double? height;
  final TextEditingController? controller;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final Function()? onTap;
  final String? initialText;
  final bool? readOnly;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final bool? obscureText;
  final Key? key;

  // Constructor of text field
  MyTextBox({
    required this.hintTexts,
    this.onSaved,
    this.onTap,
    this.prefixIcon,
    this.textCapitalization,
    this.maxLines,
    this.onEditingComplete,
    this.controller,
    this.height,
    this.readOnly,
    this.suffixIcon,
    this.initialText,
    this.inputFormatters,
    this.onChanged,
    this.keyboardType,
    this.autofocus,
    this.obscureText,
    this.key,
    this.onFieldSubmitted,
  }) : super();

  @override
  _MyTextBoxState createState() => _MyTextBoxState(
        hintTexts: hintTexts,
        height: height,
        onChanged: onChanged,
        onTap: onTap,
        obscureText: obscureText,
        onEditingComplete: onEditingComplete,
        onSaved: onSaved,
        autofocus: autofocus,
        controller: controller,
        initialText: initialText,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        maxLines: maxLines,
        prefixIcon: prefixIcon,
        readOnly: readOnly,
        suffixIcon: suffixIcon,
        textCapitalization: textCapitalization,
        key: key,
        onFieldSubmitted: onFieldSubmitted,
      );
}

class _MyTextBoxState extends State<MyTextBox>
    with SingleTickerProviderStateMixin {
  List<String> hintTexts;
  int currentHintIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  // Callback functions
  Function(String)? onChanged;
  Function? onEditingComplete;
  Function(String?)? onSaved;
  TextInputType? keyboardType;
  double? height;
  TextEditingController? controller;
  Icon? prefixIcon;
  Widget? suffixIcon;
  Function()? onTap;
  String? initialText;
  bool? readOnly;
  int? maxLines;
  TextCapitalization? textCapitalization;
  bool? autofocus;
  List<TextInputFormatter>? inputFormatters;
  bool? obscureText;
  var key;
  Function(String)? onFieldSubmitted;

  _MyTextBoxState({
    required this.hintTexts,
    this.onSaved,
    this.onTap,
    this.prefixIcon,
    this.textCapitalization,
    this.maxLines,
    this.onEditingComplete,
    this.controller,
    this.height,
    this.readOnly,
    this.suffixIcon,
    this.initialText,
    this.inputFormatters,
    this.onChanged,
    this.keyboardType,
    this.autofocus,
    this.obscureText,
    this.key,
    this.onFieldSubmitted,
  });

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration for fade in and fade out
    );

    // Initialize the animation for fade in and fade out
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          // Fade out
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          // Change the hint text after fade out
          setState(() {
            currentHintIndex = (currentHintIndex + 1) % hintTexts.length;
          });
          // Start fade in again
          _controller.forward();
        }
      });

    // Start with a fade in
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return TextFormField(
            key: key,
            cursorColor: Colors.grey[800],
            controller: controller,
            style: textFieldHintStyle(context),
            keyboardType: keyboardType ?? TextInputType.text,
            textCapitalization: textCapitalization ?? TextCapitalization.none,
            obscureText: obscureText ?? false,
            autofocus: autofocus ?? false,
            readOnly: readOnly ?? false,
            maxLines: maxLines ?? 1,
            initialValue: initialText,
            onTap: onTap,
            inputFormatters: inputFormatters ?? [],
            decoration: InputDecoration(
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                    width: 0,
                    color: Theme.of(context).colorScheme.secondary,
                    style: BorderStyle.none),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                    width: 0,
                    color: Theme.of(context).colorScheme.secondary,
                    style: BorderStyle.none),
              ),
              hintText: hintTexts[currentHintIndex],
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              hintStyle: textFieldHintStyle(context).copyWith(
                color: Colors.grey[500]!.withOpacity(_animation.value),
              ),
              contentPadding: EdgeInsets.only(bottom: 12.0),
            ),
            onSaved: (value) => onSaved?.call(value),
            onEditingComplete: () => onEditingComplete?.call(),
            onFieldSubmitted: onFieldSubmitted != null
                ? (val) => val != "" ? onFieldSubmitted!(val) : null
                : null,
            onChanged: onChanged != null ? (value) => onChanged!(value) : null,
          );
        },
      ),
    );
  }

  TextStyle textFieldHintStyle(BuildContext context) {
    return TextStyle(
      color: Colors.grey[500],
      fontSize: 16.0,
    );
  }
}
