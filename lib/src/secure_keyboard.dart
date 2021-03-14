import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_action.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_generator.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_type.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_type.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key.dart';

/// Height of widget showing input text.
const double keyInputMonitorHeight = 50.0;

/// Keyboard default height.
const double keyboardDefaultHeight = 280.0;

/// Keyboard key default radius.
const double keyboardKeyDefaultRadius = 4.0;

/// Keyboard key default spacing.
const double keyboardKeyDefaultSpacing = 1.4;

/// Speed ​​of erasing input text when holding backspace.
const int backspaceEventDelay = 100;

/// Keyboard default background color.
const Color keyboardDefaultBackgroundColor = Color(0xFF0A0A0A);

/// Keyboard default string key color.
const Color keyboardDefaultStringKeyColor = Color(0xFF313131);

/// Keyboard default action key color.
const Color keyboardDefaultActionKeyColor = Color(0xFF222222);

/// Keyboard default done key color.
const Color keyboardDefaultDoneKeyColor = Color(0xFF1C7CDC);

/// Keyboard default key text style.
const TextStyle keyboardDefaultKeyTextStyle = TextStyle(
    color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold);

/// Keyboard default input text style.
const TextStyle keyboardDefaultInputTextStyle = TextStyle(
    color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold);

/// Key input monitor default padding.
const EdgeInsetsGeometry keyInputMonitorDefaultPadding =
EdgeInsets.only(left: 10.0, right: 5.0);

/// Keyboard default padding.
const EdgeInsetsGeometry keyboardDefaultPadding =
EdgeInsets.symmetric(horizontal: 5.0);

/// String key touch start callback function.
typedef OnStringKeyTouchStart = void Function(
    String keyText, Offset position, BoxConstraints constraints);

/// String key touch end callback function.
typedef OnStringKeyTouchEnd = void Function();

/// Widget that implements a secure keyboard.
class SecureKeyboard extends StatefulWidget {
  /// Specifies the secure keyboard type.
  final SecureKeyboardType type;

  /// Called when the key is pressed.
  final ValueChanged<SecureKeyboardKey> onKeyPressed;

  /// Called when the character codes changed.
  final ValueChanged<List<int>> onCharCodesChanged;

  /// Called when the done key is pressed.
  final ValueChanged<List<int>> onDoneKeyPressed;

  /// Called when the close key is pressed.
  final VoidCallback onCloseKeyPressed;

  /// Called when the string key touch start.
  final OnStringKeyTouchStart onStringKeyTouchStart;

  /// Called when the string key touch end.
  final OnStringKeyTouchEnd onStringKeyTouchEnd;

  /// Set the initial value of the input text.
  final String? initText;

  /// The hint text to display when the input text is empty.
  final String? hintText;

  /// Set the symbol to use when displaying the input text length.
  final String? inputTextLengthSymbol;

  /// Set the done key text.
  final String? doneKeyText;

  /// Set the clear key text.
  final String? clearKeyText;

  /// Set the secure character to hide the input text.
  /// Default value is `•`.
  final String obscuringCharacter;

  /// Set the maximum length of text that can be entered.
  final int? maxLength;

  /// Whether to always display uppercase characters.
  /// Default value is `false`.
  final bool alwaysCaps;

  /// Whether to hide input text as secure characters.
  /// Default value is `true`.
  final bool obscureText;

  /// Whether to shuffle the position of the numeric keys.
  /// Default value is `true`.
  final bool shuffleNumericKey;

  /// Parameter to set the keyboard height.
  /// Default value is `280.0`.
  final double height;

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

  SecureKeyboard({
    Key? key,
    required this.type,
    required this.onKeyPressed,
    required this.onCharCodesChanged,
    required this.onDoneKeyPressed,
    required this.onCloseKeyPressed,
    required this.onStringKeyTouchStart,
    required this.onStringKeyTouchEnd,
    this.initText,
    this.hintText,
    this.inputTextLengthSymbol,
    this.doneKeyText,
    this.clearKeyText,
    this.obscuringCharacter = '•',
    this.maxLength,
    this.alwaysCaps = false,
    this.obscureText = true,
    this.shuffleNumericKey = true,
    this.height = keyboardDefaultHeight,
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
  })  : assert(obscuringCharacter.isNotEmpty),
        super(key: key);

  @override
  _SecureKeyboardState createState() => _SecureKeyboardState();
}

class _SecureKeyboardState extends State<SecureKeyboard> {
  final _methodChannel = const MethodChannel('flutter_secure_keyboard');

  final _definedKeyRows = <List<SecureKeyboardKey>>[];
  final _specialKeyRows = <List<SecureKeyboardKey>>[];

  final _charCodesController = StreamController<List<int>>.broadcast();
  final _charCodes = <int>[];
  
  Timer? _backspaceEventGenerator;

  bool _isViewEnabled = false;
  bool _isShiftEnabled = false;
  bool _isSpecialCharsEnabled = false;
  
  void _initVariables() {
    _isViewEnabled = false;
    _isShiftEnabled = false;
    _isSpecialCharsEnabled = false;

    _definedKeyRows.clear();
    _specialKeyRows.clear();
    _charCodes.clear();
    if (widget.initText != null)
      _charCodes.addAll(widget.initText!.codeUnits);

    final keyGenerator = SecureKeyboardKeyGenerator.instance;
    if (widget.type == SecureKeyboardType.NUMERIC)
      _definedKeyRows.addAll(keyGenerator.getNumericKeyRows(widget.shuffleNumericKey));
    else
      _definedKeyRows.addAll(keyGenerator.getAlphanumericKeyRows(widget.shuffleNumericKey));
    _specialKeyRows.addAll(SecureKeyboardKeyGenerator.instance.getSpecialCharsKeyRows());
  }

  void _notifyCharCodesChanged() {
    _charCodesController.sink.add(_charCodes);
  }

  void _onKeyPressed(SecureKeyboardKey key) {
    if (key.type == SecureKeyboardKeyType.STRING) {
      // The length of `charCodes` cannot exceed `maxLength`.
      final currMaxLength = widget.maxLength;
      if (currMaxLength != null && (currMaxLength <= _charCodes.length))
        return;

      final keyText = (_isShiftEnabled || widget.alwaysCaps)
          ? key.capsText
          : key.text;
      if (keyText == null) return;

      _charCodes.add(keyText.codeUnits.first);
      _notifyCharCodesChanged();
      widget.onCharCodesChanged(_charCodes);
    } else if (key.type == SecureKeyboardKeyType.ACTION) {
      switch (key.action) {
        // Backspace
        case SecureKeyboardKeyAction.BACKSPACE:
          if (_charCodes.isNotEmpty) {
            _charCodes.removeLast();
            _notifyCharCodesChanged();
            widget.onCharCodesChanged(_charCodes);
          }
          break;
          
        // Done
        case SecureKeyboardKeyAction.DONE:
          widget.onDoneKeyPressed(_charCodes);
          break;
          
        // Clear
        case SecureKeyboardKeyAction.CLEAR:
          _charCodes.clear();
          _notifyCharCodesChanged();
          widget.onCharCodesChanged(_charCodes);
          break;
          
        // Shift
        case SecureKeyboardKeyAction.SHIFT:
          if (!widget.alwaysCaps)
            setState(() {
              _isShiftEnabled = !_isShiftEnabled;
            });
          break;
          
        // SpecialChars
        case SecureKeyboardKeyAction.SPECIAL_CHARACTERS:
          setState(() {
            _isSpecialCharsEnabled = !_isSpecialCharsEnabled;
          });
          break;

        default:
          return;
      }
    }

    widget.onKeyPressed(key);
  }

  @override
  void didUpdateWidget(covariant SecureKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initVariables();
  }

  @override
  void initState() {
    super.initState();
    _methodChannel.invokeMethod('secureModeOn', {
      'screenCaptureDetectedAlertTitle': widget.screenCaptureDetectedAlertTitle,
      'screenCaptureDetectedAlertMessage': widget.screenCaptureDetectedAlertMessage,
      'screenCaptureDetectedAlertActionTitle': widget.screenCaptureDetectedAlertActionTitle
    });
    _initVariables();
  }

  @override
  Widget build(BuildContext context) {
    final keyRows = _isSpecialCharsEnabled
        ? _specialKeyRows
        : _definedKeyRows;

    final keyInputMonitor = Padding(
      padding: widget.keyInputMonitorPadding,
      child: _buildKeyInputMonitor()
    );

    final keyboard = Padding(
      padding: widget.keyboardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildKeyboardKey(keyRows)
      ),
    );

    return WillPopScope(
      onWillPop: () async {
        widget.onCloseKeyPressed();
        return false;
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height + keyInputMonitorHeight,
        color: widget.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            keyInputMonitor,
            keyboard
          ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    _methodChannel.invokeMethod('secureModeOff');
    _charCodesController.close();
    super.dispose();
  }

  Widget _buildKeyInputMonitor() {
    return StreamBuilder<List<int>>(
      stream: _charCodesController.stream.asBroadcastStream(
        onCancel: (subscription) => subscription.cancel()
      ),
      initialData: _charCodes,
      builder: (context, snapshot) =>
          _buildKeyInputMonitorLayout(snapshot.data ?? _charCodes)
    );
  }

  Widget _buildKeyInputMonitorLayout(List<int> charCodes) {
    String secureText;
    TextStyle secureTextStyle;

    if (charCodes.isNotEmpty) {
      if (widget.obscureText && !_isViewEnabled) {
        secureText = '';
        for (int i=0; i<charCodes.length; i++) {
          if (i == charCodes.length - 1)
            secureText += String.fromCharCode(charCodes[i]);
          else
            secureText += widget.obscuringCharacter;
        }
      } else {
        secureText = String.fromCharCodes(charCodes);
      }

      secureTextStyle = widget.inputTextStyle;
    } else {
      secureText = widget.hintText ?? '';
      secureTextStyle = widget.inputTextStyle.copyWith(
          color: widget.inputTextStyle.color?.withOpacity(0.5));
    }

    String? lengthSymbol = widget.inputTextLengthSymbol;
    if (lengthSymbol == null)
      lengthSymbol = (Platform.localeName == 'ko_KR') ? '자' : 'digit';
    final lengthText = '${charCodes.length}$lengthSymbol';

    return SizedBox(
      height: keyInputMonitorHeight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              secureText,
              style: secureTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(lengthText, style: widget.keyTextStyle)
          ),
          (widget.obscureText)
              ? _buildViewButton()
              : SizedBox(),
          _buildCloseButton()
        ],
      ),
    );
  }

  Widget _buildViewButton() {
    return Container(
      width: keyInputMonitorHeight / 1.4,
      height: keyInputMonitorHeight / 1.4,
      margin: const EdgeInsets.only(left: 1.5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.0),
          onTap: () {

          },
          child: GestureDetector(
            onPanDown: (_) => setState(() => _isViewEnabled = true),
            onPanEnd: (_) => setState(() => _isViewEnabled = false),
            onPanCancel: () => setState(() => _isViewEnabled = false),
            child: Icon(Icons.remove_red_eye, color: widget.keyTextStyle.color)
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton() {
    return Container(
      width: keyInputMonitorHeight / 1.4,
      height: keyInputMonitorHeight / 1.4,
      margin: const EdgeInsets.only(right: 1.5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24.0),
          onTap: widget.onCloseKeyPressed,
          child: Icon(Icons.close, color: widget.keyTextStyle.color)
        ),
      ),
    );
  }

  List<Widget> _buildKeyboardKey(List<List<SecureKeyboardKey>> keyRows) {
    return List.generate(keyRows.length, (int rowNum) {
      return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(keyRows[rowNum].length, (int keyNum) {
            final key = keyRows[rowNum][keyNum];
            
            switch (key.type) {
              case SecureKeyboardKeyType.STRING:
                return _buildStringKey(key, keyRows.length);
              case SecureKeyboardKeyType.ACTION:
                return _buildActionKey(key, keyRows.length);
              default:
                throw Exception('Unknown key type.');
            }
          })
        ),
      );
    });
  }
  
  Widget _buildStringKey(SecureKeyboardKey key, int keyRowsLength) {
    final keyText = (_isShiftEnabled || widget.alwaysCaps)
        ? key.capsText ?? ''
        : key.text ?? '';
    final stringKeyChild = Text(keyText, style: widget.keyTextStyle);
    final globalKey = GlobalKey();

    return Expanded(
      child: Container(
        key: globalKey,
        height: widget.height / keyRowsLength,
        padding: EdgeInsets.all(widget.keySpacing),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final stringKey = Material(
              borderRadius: BorderRadius.circular(widget.keyRadius),
              color: widget.stringKeyColor,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.keyRadius),
                onTap: () => _onKeyPressed(key),
                child: Center(child: stringKeyChild)
              ),
            );

            if (widget.type == SecureKeyboardType.ALPHA_NUMERIC)
              return GestureDetector(
                onPanDown: (_) {
                  final renderObject = globalKey.currentContext?.findRenderObject();
                  if ((renderObject != null) && (renderObject is RenderBox)) {
                    final position = renderObject.localToGlobal(Offset.zero);
                    widget.onStringKeyTouchStart(keyText, position, constraints);
                  }
                },
                onPanEnd: (_) => widget.onStringKeyTouchEnd(),
                onPanCancel: () => widget.onStringKeyTouchEnd(),
                child: stringKey
              );

            return stringKey;
          }
        ),
      ),
    );
  }

  Widget _buildActionKey(SecureKeyboardKey key, int keyRowsLength) {
    Widget actionKeyChild;
    switch (key.action ?? SecureKeyboardKeyAction.BLANK) {
      case SecureKeyboardKeyAction.BACKSPACE:
        actionKeyChild = GestureDetector(
          onLongPress: () {
            final delay = Duration(milliseconds: backspaceEventDelay);
            _backspaceEventGenerator = Timer.periodic(delay, (_) => _onKeyPressed(key));
          },
          onLongPressUp: () {
            _backspaceEventGenerator?.cancel();
            _backspaceEventGenerator = null;
          },
          child: Icon(Icons.backspace, color: widget.keyTextStyle.color)
        );
        break;
      case SecureKeyboardKeyAction.SHIFT:
        actionKeyChild = Icon(Icons.arrow_upward, color: widget.keyTextStyle.color);
        break;
      case SecureKeyboardKeyAction.CLEAR:
        String? keyText = widget.clearKeyText;
        if (keyText == null || keyText.isEmpty)
          keyText = (Platform.localeName == 'ko_KR') ? '초기화' : 'Clear';

        actionKeyChild = Text(keyText, style: widget.keyTextStyle);
        break;
      case SecureKeyboardKeyAction.DONE:
        String? keyText = widget.doneKeyText;
        if (keyText == null || keyText.isEmpty)
          keyText = (Platform.localeName == 'ko_KR') ? '입력완료' : 'Done';

        actionKeyChild = Text(keyText, style: widget.keyTextStyle);
        break;
      case SecureKeyboardKeyAction.SPECIAL_CHARACTERS:
        actionKeyChild = Text(
          _isSpecialCharsEnabled
              ? (_isShiftEnabled ? 'ABC' : 'abc')
              : '!@#',
          style: widget.keyTextStyle
        );
        break;
      case SecureKeyboardKeyAction.BLANK:
        return Expanded(child: SizedBox());
    }

    Color keyColor;
    if (key.action == SecureKeyboardKeyAction.DONE)
      keyColor = widget.doneKeyColor;
    else if (key.action == SecureKeyboardKeyAction.SHIFT && _isShiftEnabled)
      keyColor = widget.activatedKeyColor ?? widget.doneKeyColor;
    else
      keyColor = widget.actionKeyColor;

    return Expanded(
      child: Container(
        height: widget.height / keyRowsLength,
        padding: EdgeInsets.all(widget.keySpacing),
        child: Material(
          borderRadius: BorderRadius.circular(widget.keyRadius),
          color: keyColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.keyRadius),
            onTap: () => _onKeyPressed(key),
            child: Center(child: actionKeyChild)
          ),
        ),
      ),
    );
  }
}
