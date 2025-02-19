import 'package:flutter_secure_keyboard/src/secure_keyboard_key_action.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_type.dart';

/// Class defining secure keyboard key.
class SecureKeyboardKey {
  /// Key text in lowercase form.
  final String text;

  /// Key text in uppercase form.
  final String capsText;

  /// Key type (Action, String)
  final SecureKeyboardKeyType type;

  /// Key action (Backspace, Done, Clear, Shift, Blank, SpecialChars)
  final SecureKeyboardKeyAction action;

  SecureKeyboardKey({
    this.text,
    this.capsText,
    this.type,
    this.action
  });

  /// Returns the class field in map form.
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'capsText': capsText,
      'type': type,
      'action': action
    };
  }
}
