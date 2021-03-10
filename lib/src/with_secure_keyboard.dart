import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_type.dart';

/// A widget that implements a secure keyboard with controller.
class WithSecureKeyboard extends StatefulWidget {
  /// Controller for controlling the secure keyboard.
  final SecureKeyboardController controller;

  /// A widget to have a secure keyboard.
  final Widget child;

  /// Parameter to set the keyboard height.
  final double keyboardHeight;

  /// Parameter to set the keyboard background color.
  final Color backgroundColor;

  /// Parameter to set keyboard string key(alphanumeric, numeric..) color.
  final Color stringKeyColor;

  /// Parameter to set keyboard action key(shift, backspace, clear..) color.
  final Color actionKeyColor;

  /// Parameter to set keyboard done key color.
  final Color doneKeyColor;

  /// Set the color to display when activated with the shift action key.
  /// If the value is null, `doneKeyColor` is used.
  final Color activatedKeyColor;

  /// Parameter to set keyboard key text style.
  final TextStyle keyTextStyle;

  /// Parameter to set keyboard input text style.
  final TextStyle inputTextStyle;

  /// Security Alert title, only works on ios.
  final String screenCaptureDetectedAlertTitle;

  /// Security Alert message, only works on ios.
  final String screenCaptureDetectedAlertMessage;

  /// Security Alert actionTitle, only works on ios.
  final String screenCaptureDetectedAlertActionTitle;

  WithSecureKeyboard({
    Key key,
    @required this.controller,
    @required this.child,
    this.keyboardHeight = keyboardDefaultHeight,
    this.backgroundColor = const Color(0xFF0A0A0A),
    this.stringKeyColor = const Color(0xFF313131),
    this.actionKeyColor = const Color(0xFF222222),
    this.doneKeyColor = const Color(0xFF1C7CDC),
    this.activatedKeyColor,
    this.keyTextStyle = const TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
    this.inputTextStyle = const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
    this.screenCaptureDetectedAlertTitle,
    this.screenCaptureDetectedAlertMessage,
    this.screenCaptureDetectedAlertActionTitle
  })  : assert(controller != null),
        assert(child != null),
        assert(keyboardHeight != null),
        assert(backgroundColor != null),
        assert(stringKeyColor != null),
        assert(actionKeyColor != null),
        assert(doneKeyColor != null),
        assert(keyTextStyle != null),
        assert(inputTextStyle != null),
        super(key: key);

  @override
  _WithSecureKeyboardState createState() => _WithSecureKeyboardState();
}

class _WithSecureKeyboardState extends State<WithSecureKeyboard> {
  Widget secureKeyboard = SizedBox();

  void onSecureKeyboardStateChanged() async {
    setState(() {
      if (widget.controller.isShowing) {
        // Hide Software Keyboard
        FocusScope.of(context).requestFocus(FocusNode());

        final onKeyPressed = widget.controller._onKeyPressed;
        final onCharCodesChanged = widget.controller._onCharCodesChanged;
        final onDoneKeyPressed = widget.controller._onDoneKeyPressed;
        final onCloseKeyPressed = widget.controller._onCloseKeyPressed;

        secureKeyboard = SecureKeyboard(
          type: widget.controller.type,
          initText: widget.controller._initText,
          hintText: widget.controller._hintText,
          inputTextLengthSymbol: widget.controller._inputTextLengthSymbol,
          doneKeyText: widget.controller._doneKeyText,
          clearKeyText: widget.controller._clearKeyText,
          obscuringCharacter: widget.controller._obscuringCharacter,
          maxLength: widget.controller._maxLength,
          alwaysCaps: widget.controller._alwaysCaps,
          obscureText: widget.controller._obscureText,
          height: widget.keyboardHeight,
          backgroundColor: widget.backgroundColor,
          stringKeyColor: widget.stringKeyColor,
          actionKeyColor: widget.actionKeyColor,
          doneKeyColor: widget.doneKeyColor,
          activatedKeyColor: widget.activatedKeyColor,
          keyTextStyle: widget.keyTextStyle,
          inputTextStyle: widget.inputTextStyle,
          screenCaptureDetectedAlertTitle: widget.screenCaptureDetectedAlertTitle,
          screenCaptureDetectedAlertMessage: widget.screenCaptureDetectedAlertMessage,
          screenCaptureDetectedAlertActionTitle: widget.screenCaptureDetectedAlertActionTitle,
          onKeyPressed: (key) {
            if (onKeyPressed != null)
              onKeyPressed(key);
          },
          onCharCodesChanged: (charCodes) {
            if (onCharCodesChanged != null)
              onCharCodesChanged(charCodes);
          },
          onDoneKeyPressed: (charCodes) {
            widget.controller.hide();
            if (onDoneKeyPressed != null)
              onDoneKeyPressed(charCodes);
          },
          onCloseKeyPressed: () {
            widget.controller.hide();
            if (onCloseKeyPressed != null)
              onCloseKeyPressed();
          }
        );
      } else {
        secureKeyboard = SizedBox();
      }
    });

    if (widget.controller._textFieldFocusNode != null) {
      final duration = const Duration(milliseconds: 300);
      await Future.delayed(duration);
      Scrollable.ensureVisible(widget.controller._textFieldFocusNode.context, duration: duration);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onSecureKeyboardStateChanged);

    // Code to prevent opening simultaneously with soft keyboard.
    KeyboardVisibilityController().onChange.listen((visible) {
      if (widget.controller.isShowing && visible)
        widget.controller.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: widget.child),
          secureKeyboard
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(onSecureKeyboardStateChanged);
    super.dispose();
  }
}

/// Controller to check or control the state of the secure keyboard.
class SecureKeyboardController extends ChangeNotifier {
  bool _isShowing = false;
  /// Whether the secure keyboard is open.
  bool get isShowing => _isShowing;

  SecureKeyboardType _type;
  /// Indicates the secure keyboard type.
  SecureKeyboardType get type => _type;

  FocusNode _textFieldFocusNode;
  String _initText;
  String _hintText;
  String _inputTextLengthSymbol;
  String _doneKeyText;
  String _clearKeyText;
  String _obscuringCharacter;
  int _maxLength;
  bool _alwaysCaps;
  bool _obscureText;

  ValueChanged<SecureKeyboardKey> _onKeyPressed;
  ValueChanged<List<int>> _onCharCodesChanged;
  ValueChanged<List<int>> _onDoneKeyPressed;
  VoidCallback _onCloseKeyPressed;

  /// Show a secure keyboard.
  void show({
    @required SecureKeyboardType type,
    FocusNode textFieldFocusNode,
    String initText = '',
    String hintText = '',
    String inputTextLengthSymbol,
    String doneKeyText,
    String clearKeyText,
    String obscuringCharacter = '•',
    int maxLength,
    bool alwaysCaps = false,
    bool obscureText = true,
    ValueChanged<SecureKeyboardKey> onKeyPressed,
    ValueChanged<List<int>> onCharCodesChanged,
    ValueChanged<List<int>> onDoneKeyPressed,
    VoidCallback onCloseKeyPressed
  }) {
    assert(type != null);
    assert(initText != null);
    assert(hintText != null);
    assert(obscuringCharacter != null && obscuringCharacter.isNotEmpty);
    assert(alwaysCaps != null);
    assert(obscureText != null);

    _type = type;
    _textFieldFocusNode = textFieldFocusNode;
    _initText = initText;
    _hintText = hintText;
    _inputTextLengthSymbol = inputTextLengthSymbol;
    _doneKeyText = doneKeyText;
    _clearKeyText = clearKeyText;
    _obscuringCharacter = obscuringCharacter;
    _maxLength = maxLength;
    _alwaysCaps = alwaysCaps;
    _obscureText = obscureText;
    _onKeyPressed = onKeyPressed;
    _onCharCodesChanged = onCharCodesChanged;
    _onDoneKeyPressed = onDoneKeyPressed;
    _onCloseKeyPressed = onCloseKeyPressed;
    _isShowing = true;
    notifyListeners();
  }

  /// Hide a secure keyboard.
  void hide() {
    _type = null;
    _textFieldFocusNode = null;
    _initText = null;
    _hintText = null;
    _inputTextLengthSymbol = null;
    _doneKeyText = null;
    _clearKeyText = null;
    _obscuringCharacter = null;
    _maxLength = null;
    _alwaysCaps = null;
    _obscureText = null;
    _onKeyPressed = null;
    _onCharCodesChanged = null;
    _onDoneKeyPressed = null;
    _onCloseKeyPressed = null;
    _isShowing = false;
    notifyListeners();
  }
}