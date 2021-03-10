import 'dart:math';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_action.dart';
import 'package:flutter_secure_keyboard/src/secure_keyboard_key_type.dart';

/// Class responsible for key generation of secure keyboard.
class SecureKeyboardKeyGenerator {
  SecureKeyboardKeyGenerator._internal();
  static final instance = SecureKeyboardKeyGenerator._internal();

  /// Maximum length of a row of numeric key.
  /// If not enough, fill in the blank action key.
  final int _numericKeyRowMaxLength = 4;
  final List<List<String>> _numericKeyRows = [
    const ['1', '2', '3'],
    const ['4', '5', '6'],
    const ['7', '8', '9', '0'],
    const []
  ];

  /// Maximum length of a row of alphanumeric key.
  /// If not enough, fill in the blank action key.
  final int _alphanumericKeyRowMaxLength = 11;
  final List<List<String>> _alphanumericKeyRows = [
    const ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'],
    const ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    const ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    const ['z', 'x', 'c', 'v', 'b', 'n', 'm'],
    const []
  ];

  /// Maximum length of a row of special characters key.
  /// If not enough, fill in the blank action key.
  final int _specialCharsKeyRowMaxLength = 11;
  final List<List<String>> _specialCharsKeyRows = [
    const ['!', '@', '#', '\$', '%', '^', '&', '*', '(', ')'],
    const ['-', '=', '+', '{', '}', '[', ']', '\\', ':', ';'],
    const ['\"', '\'', '<', '>', ',', '.', '/', '?', '|'],
    const ['~', '`', '_', '\₩', '#', '@', '!'],
    const []
  ];

  /// Returns a list of numeric key rows.
  List<List<SecureKeyboardKey>> getNumericKeyRows() {
    final random = Random();
    int randomIndex;
    int emptyLength;

    return List.generate(_numericKeyRows.length, (int rowNum) {
      List<SecureKeyboardKey> rowKeys = [];

      switch (rowNum) {
        case 3:
          // Clear
          rowKeys.add(_clearActionKey());

          // Backspace
          rowKeys.add(_backspaceActionKey());

          // Done
          rowKeys.add(_doneActionKey());
          break;
        default:
          rowKeys = _getStringKeyRow(_numericKeyRows, rowNum);
          emptyLength = _numericKeyRowMaxLength - _numericKeyRows[rowNum].length;

          for (var i=0; i<emptyLength; i++) {
            randomIndex = random.nextInt(_numericKeyRowMaxLength);

            if (randomIndex == _numericKeyRowMaxLength - 1)
              rowKeys.add(_blankActionKey());
            else
              rowKeys.insert(randomIndex, _blankActionKey());
          }

          rowKeys.shuffle();
      }

      return rowKeys;
    });
  }

  /// Returns a list of alphanumeric key rows.
  List<List<SecureKeyboardKey>> getAlphanumericKeyRows() {
    final random = Random();
    int randomIndex;
    int emptyLength;

    return List.generate(_alphanumericKeyRows.length, (int rowNum) {
      List<SecureKeyboardKey> rowKeys = [];

      switch (rowNum) {
        case 3:
          // Shift
          rowKeys.add(_shiftActionKey());

          rowKeys.addAll(_getStringKeyRow(_alphanumericKeyRows, rowNum));

          emptyLength = _alphanumericKeyRows[rowNum].length;
          randomIndex = random.nextInt(emptyLength) + 1;
          rowKeys.insert(randomIndex, _blankActionKey());

          // Backspace
          rowKeys.add(_backspaceActionKey());
          break;
        case 4:
          // SpecialChars
          rowKeys.add(_specialCharsActionKey());

          // Clear
          rowKeys.add(_clearActionKey());

          // Done
          rowKeys.add(_doneActionKey());
          break;
        default:
          rowKeys = _getStringKeyRow(_alphanumericKeyRows, rowNum);
          emptyLength = _alphanumericKeyRowMaxLength - _alphanumericKeyRows[rowNum].length;

          for (var i=0; i<emptyLength; i++) {
            randomIndex = random.nextInt(_alphanumericKeyRowMaxLength);

            if (randomIndex == _alphanumericKeyRowMaxLength - 1)
              rowKeys.add(_blankActionKey());
            else
              rowKeys.insert(randomIndex, _blankActionKey());
          }

          if (rowNum == 0)
            rowKeys.shuffle();
      }

      return rowKeys;
    });
  }

  /// Returns a list of special characters key rows.
  List<List<SecureKeyboardKey>> getSpecialCharsKeyRows() {
    final random = Random();
    int randomIndex;
    int emptyLength;

    return List.generate(_specialCharsKeyRows.length, (int rowNum) {
      List<SecureKeyboardKey> rowKeys = [];

      switch (rowNum) {
        case 3:
          // Shift
          rowKeys.add(_shiftActionKey());

          rowKeys.addAll(_getStringKeyRow(_specialCharsKeyRows, rowNum));

          emptyLength = _specialCharsKeyRows[rowNum].length;
          randomIndex = random.nextInt(emptyLength) + 1;
          rowKeys.insert(randomIndex, _blankActionKey());

          // Backspace
          rowKeys.add(_backspaceActionKey());
          break;
        case 4:
          // SpecialChars
          rowKeys.add(_specialCharsActionKey());

          // Clear
          rowKeys.add(_clearActionKey());

          // Done
          rowKeys.add(_doneActionKey());
          break;
        default:
          rowKeys = _getStringKeyRow(_specialCharsKeyRows, rowNum);
          emptyLength = _specialCharsKeyRowMaxLength - _specialCharsKeyRows[rowNum].length;

          for (var i=0; i<emptyLength; i++) {
            randomIndex = random.nextInt(_specialCharsKeyRowMaxLength);

            if (randomIndex == _specialCharsKeyRowMaxLength - 1)
              rowKeys.add(_blankActionKey());
            else
              rowKeys.insert(randomIndex, _blankActionKey());
          }
      }

      return rowKeys;
    });
  }

  /// Returns the string type key row.
  List<SecureKeyboardKey> _getStringKeyRow(List<List<String>> keyRows, int rowNum) {
    return List.generate(keyRows[rowNum].length, (int keyNum) {
      String key = keyRows[rowNum][keyNum];

      return SecureKeyboardKey(
        text: key,
        capsText: key.toUpperCase(),
        type: SecureKeyboardKeyType.String
      );
    });
  }

  /// Returns the backspace action key.
  SecureKeyboardKey _backspaceActionKey() {
    return SecureKeyboardKey(
      type: SecureKeyboardKeyType.Action,
      action: SecureKeyboardKeyAction.Backspace
    );
  }

  /// Returns the done action key.
  SecureKeyboardKey _doneActionKey() {
    return SecureKeyboardKey(
      type: SecureKeyboardKeyType.Action,
      action: SecureKeyboardKeyAction.Done
    );
  }

  /// Returns the clear action key.
  SecureKeyboardKey _clearActionKey() {
    return SecureKeyboardKey(
      type: SecureKeyboardKeyType.Action,
      action: SecureKeyboardKeyAction.Clear
    );
  }

  /// Returns the shift action key.
  SecureKeyboardKey _shiftActionKey() {
    return SecureKeyboardKey(
      type: SecureKeyboardKeyType.Action,
      action: SecureKeyboardKeyAction.Shift
    );
  }

  /// Returns the blank action key.
  SecureKeyboardKey _blankActionKey() {
    return SecureKeyboardKey(
      type: SecureKeyboardKeyType.Action,
      action: SecureKeyboardKeyAction.Blank
    );
  }

  /// Returns the specialChars action key.
  SecureKeyboardKey _specialCharsActionKey() {
    return SecureKeyboardKey(
      type: SecureKeyboardKeyType.Action,
      action: SecureKeyboardKeyAction.SpecialChars
    );
  }
}