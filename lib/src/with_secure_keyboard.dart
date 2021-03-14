import 'dart:async';
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
  /// Default value is `280.0`.
  final double keyboardHeight;

  /// Set the radius of the keyboard key.
  /// Default value is `4.0`.
  final double keyRadius;

  /// Set the spacing between keyboard keys.
  /// Default value is `1.4`.
  final double keySpacing;

  /// Set the padding of the key input monitor.
  /// Default value is `EdgeInsets.only(left: 10.0, right: 5.0)`.
  final EdgeInsetsGeometry keyInputMonitorPadding;

  /// Set the padding of the keyboard.
  /// Default value is `EdgeInsets.symmetric(horizontal: 5.0)`.
  final EdgeInsetsGeometry keyboardPadding;

  /// Parameter to set the keyboard background color.
  /// Default value is `Color(0xFF0A0A0A)`.
  final Color backgroundColor;

  /// Parameter to set keyboard string key(alphanumeric, numeric..) color.
  /// Default value is `Color(0xFF313131)`.
  final Color stringKeyColor;

  /// Parameter to set keyboard action key(shift, backspace, clear..) color.
  /// Default value is `Color(0xFF222222)`.
  final Color actionKeyColor;

  /// Parameter to set keyboard done key color.
  /// Default value is `Color(0xFF1C7CDC)`.
  final Color doneKeyColor;

  /// Set the color to display when activated with the shift action key.
  /// If the value is null, `doneKeyColor` is used.
  final Color? activatedKeyColor;

  /// Parameter to set keyboard key text style.
  /// Default value is `TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)`.
  final TextStyle keyTextStyle;

  /// Parameter to set keyboard input text style.
  /// Default value is `TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)`.
  final TextStyle inputTextStyle;

  /// Security Alert title, only works on ios.
  final String? screenCaptureDetectedAlertTitle;

  /// Security Alert message, only works on ios.
  final String? screenCaptureDetectedAlertMessage;

  /// Security Alert actionTitle, only works on ios.
  final String? screenCaptureDetectedAlertActionTitle;

  WithSecureKeyboard({
    Key? key,
    required this.controller,
    required this.child,
    this.keyboardHeight = keyboardDefaultHeight,
    this.keyRadius = keyboardKeyDefaultRadius,
    this.keySpacing = keyboardKeyDefaultSpacing,
    this.keyInputMonitorPadding = keyInputMonitorDefaultPadding,
    this.keyboardPadding = keyboardDefaultPadding,
    this.backgroundColor = keyboardDefaultBackgroundColor,
    this.stringKeyColor = keyboardDefaultStringKeyColor,
    this.actionKeyColor = keyboardDefaultActionKeyColor,
    this.doneKeyColor = keyboardDefaultDoneKeyColor,
    this.activatedKeyColor,
    this.keyTextStyle = keyboardDefaultKeyTextStyle,
    this.inputTextStyle = keyboardDefaultInputTextStyle,
    this.screenCaptureDetectedAlertTitle,
    this.screenCaptureDetectedAlertMessage,
    this.screenCaptureDetectedAlertActionTitle
  })  : super(key: key);

  @override
  _WithSecureKeyboardState createState() => _WithSecureKeyboardState();
}

class _WithSecureKeyboardState extends State<WithSecureKeyboard> {
  final secureKeyboardStateController = StreamController<bool>.broadcast();
  final keyBubbleStateController = StreamController<bool>.broadcast();

  String? keyBubbleText;
  double? keyBubbleWidth;
  double? keyBubbleHeight;
  double? keyBubbleDx;
  double? keyBubbleDy;

  void onSecureKeyboardStateChanged() async {
    // Hide software keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    if (widget.controller.isShowing)
      secureKeyboardStateController.sink.add(true);
    else
      secureKeyboardStateController.sink.add(false);

    final textFieldFocusNode = widget.controller._textFieldFocusNode;
    if (textFieldFocusNode == null) return;
    if (textFieldFocusNode.context == null) return;

    final duration = const Duration(milliseconds: 300);
    await Future.delayed(duration);
    Scrollable.ensureVisible(textFieldFocusNode.context!, duration: duration);
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: widget.child),
              secureKeyboardBuilder()
            ],
          ),
          keyBubbleBuilder()
        ],
      ),
    );
  }
  
  Widget secureKeyboardBuilder() {
    return StreamBuilder<bool>(
      stream: secureKeyboardStateController.stream.asBroadcastStream(
        onCancel: (subscription) => subscription.cancel()
      ),
      initialData: false,
      builder: (context, snapshot) {
        return (snapshot.data == true)
            ? buildSecureKeyboard()
            : Container();
      }
    );
  }
  
  Widget buildSecureKeyboard() {
    final onKeyPressed = widget.controller._onKeyPressed;
    final onCharCodesChanged = widget.controller._onCharCodesChanged;
    final onDoneKeyPressed = widget.controller._onDoneKeyPressed;
    final onCloseKeyPressed = widget.controller._onCloseKeyPressed;

    return SecureKeyboard(
      type: widget.controller._type,
      initText: widget.controller._initText,
      hintText: widget.controller._hintText,
      inputTextLengthSymbol: widget.controller._inputTextLengthSymbol,
      doneKeyText: widget.controller._doneKeyText,
      clearKeyText: widget.controller._clearKeyText,
      obscuringCharacter: widget.controller._obscuringCharacter,
      maxLength: widget.controller._maxLength,
      alwaysCaps: widget.controller._alwaysCaps,
      obscureText: widget.controller._obscureText,
      shuffleNumericKey: widget.controller._shuffleNumericKey,
      height: widget.keyboardHeight,
      keyRadius: widget.keyRadius,
      keySpacing: widget.keySpacing,
      keyInputMonitorPadding: widget.keyInputMonitorPadding,
      keyboardPadding: widget.keyboardPadding,
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
      },
      onStringKeyTouchStart: (keyText, position, constraints) async {
        keyBubbleText = keyText;
        keyBubbleWidth = constraints.maxWidth * 1.5;
        keyBubbleHeight = constraints.maxHeight * 1.5;
        keyBubbleDx = position.dx - (keyBubbleWidth! / 6) + widget.keySpacing;
        keyBubbleDy = position.dy - keyBubbleHeight! - widget.keySpacing;
        keyBubbleStateController.sink.add(true);
      },
      onStringKeyTouchEnd: () async {
        keyBubbleText = null;
        keyBubbleWidth = null;
        keyBubbleHeight = null;
        keyBubbleDx = null;
        keyBubbleDy = null;
        keyBubbleStateController.sink.add(false);
      },
    );
  }
  
  Widget keyBubbleBuilder() {
    return StreamBuilder<bool>(
      stream: keyBubbleStateController.stream.asBroadcastStream(
        onCancel: (subscription) => subscription.cancel()
      ),
      initialData: false,
      builder: (context, snapshot) {
        Widget keyBubble;
        if (snapshot.data == true) {
          keyBubble = Positioned(
            left: keyBubbleDx,
            top: keyBubbleDy,
            child: buildKeyBubble()
          );
        } else {
          keyBubble = Container();
        }

        return keyBubble;
      }
    );
  }
  
  Widget buildKeyBubble() {
    final keyFontSize  = (widget.keyTextStyle.fontSize ?? 16.0) * 2;
    final keyTextStyle = widget.keyTextStyle.copyWith(fontSize: keyFontSize);

    return Material(
      elevation: 10.0,
      color: Colors.transparent,
      child: Container(
        width: keyBubbleWidth,
        height: keyBubbleHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.actionKeyColor,
          borderRadius: BorderRadius.circular(widget.keyRadius)
        ),
        child: Text(keyBubbleText ?? '', style: keyTextStyle)
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(onSecureKeyboardStateChanged);
    secureKeyboardStateController.close();
    keyBubbleStateController.close();
    super.dispose();
  }
}

/// Controller to check or control the state of the secure keyboard.
class SecureKeyboardController extends ChangeNotifier {
  bool _isShowing = false;
  /// Whether the secure keyboard is open.
  bool get isShowing => _isShowing;

  late SecureKeyboardType _type;
  FocusNode? _textFieldFocusNode;
  String? _initText;
  String? _hintText;
  String? _inputTextLengthSymbol;
  String? _doneKeyText;
  String? _clearKeyText;
  late String _obscuringCharacter;
  int? _maxLength;
  late bool _alwaysCaps;
  late bool _obscureText;
  late bool _shuffleNumericKey;

  ValueChanged<SecureKeyboardKey>? _onKeyPressed;
  ValueChanged<List<int>>? _onCharCodesChanged;
  ValueChanged<List<int>>? _onDoneKeyPressed;
  VoidCallback? _onCloseKeyPressed;

  /// Show a secure keyboard.
  void show({
    required SecureKeyboardType type,
    FocusNode? textFieldFocusNode,
    String? initText,
    String? hintText,
    String? inputTextLengthSymbol,
    String? doneKeyText,
    String? clearKeyText,
    String obscuringCharacter = '•',
    int? maxLength,
    bool alwaysCaps = false,
    bool obscureText = true,
    bool shuffleNumericKey = true,
    ValueChanged<SecureKeyboardKey>? onKeyPressed,
    ValueChanged<List<int>>? onCharCodesChanged,
    ValueChanged<List<int>>? onDoneKeyPressed,
    VoidCallback? onCloseKeyPressed
  }) {
    assert(obscuringCharacter.isNotEmpty);

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
    _shuffleNumericKey = shuffleNumericKey;
    _onKeyPressed = onKeyPressed;
    _onCharCodesChanged = onCharCodesChanged;
    _onDoneKeyPressed = onDoneKeyPressed;
    _onCloseKeyPressed = onCloseKeyPressed;
    _isShowing = true;
    notifyListeners();
  }

  /// Hide a secure keyboard.
  void hide() {
    // _type = null;
    _textFieldFocusNode = null;
    _initText = null;
    _hintText = null;
    _inputTextLengthSymbol = null;
    _doneKeyText = null;
    _clearKeyText = null;
    // _obscuringCharacter = null;
    _maxLength = null;
    // _alwaysCaps = null;
    // _obscureText = null;
    // _shuffleNumericKey = null;
    _onKeyPressed = null;
    _onCharCodesChanged = null;
    _onDoneKeyPressed = null;
    _onCloseKeyPressed = null;
    _isShowing = false;
    notifyListeners();
  }
}
