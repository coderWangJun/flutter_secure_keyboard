Mobile secure keyboard to prevent KeyLogger attack and screen capture.

## Screenshots
| Alphanumeric | Numeric |
|---|---|
| <img src="https://user-images.githubusercontent.com/47127353/103331966-8f5c8380-4aab-11eb-8098-f16c9417c2b7.png" width="200"> | <img src="https://user-images.githubusercontent.com/47127353/103331973-9a171880-4aab-11eb-8b34-fdf388d14044.png" width="200"> |

## Getting started

To use this plugin, add `flutter_secure_keyboard` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/). For example:

```yaml
dependencies:
  flutter_secure_keyboard: ^2.0.0
```

## Examples

```dart
class WithSecureKeyboardExample extends StatefulWidget {
  @override
  _WithSecureKeyboardExampleState createState() => _WithSecureKeyboardExampleState();
}

class _WithSecureKeyboardExampleState extends State<WithSecureKeyboardExample> {
  final secureKeyboardController = SecureKeyboardController();

  final passwordEditor = TextEditingController();
  final passwordTextFieldFocusNode = FocusNode();

  final pinCodeEditor = TextEditingController();
  final pinCodeTextFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    // We recommend that you set the secure keyboard to the top 
    // of the build function so that it can be seen properly.
    return WithSecureKeyboard(
      controller: secureKeyboardController,
      child: Scaffold(
        appBar: AppBar(title: Text('with_secure_keyboard_example')),
        body: _buildContentView()
      ),
    );
  }

  Widget _buildContentView() {
    // We recommend using the ListView widget to prevent widget overflow.
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildPasswordTextField()
        ),
        _buildPinCodeTextField()
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Password'),
        TextFormField(
          controller: passwordEditor,
          focusNode: passwordTextFieldFocusNode,
          // We recommended to set false to prevent the soft keyboard from opening.
          enableInteractiveSelection: false,
          obscureText: true,
          onTap: () {
            secureKeyboardController.show(
              type: SecureKeyboardType.ALPHA_NUMERIC,
              textFieldFocusNode: passwordTextFieldFocusNode,
              initText: passwordEditor.text,
              hintText: 'password',
              // Use onCharCodesChanged to have text entered in real time.
              onCharCodesChanged: (List<int> charCodes) {
                passwordEditor.text = String.fromCharCodes(charCodes);
              }
            );
          },
        ),
      ],
    );
  }

  Widget _buildPinCodeTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('PinCode'),
        TextFormField(
          controller: pinCodeEditor,
          focusNode: pinCodeTextFieldFocusNode,
          // We recommended to set false to prevent the soft keyboard from opening.
          enableInteractiveSelection: false,
          obscureText: true,
          onTap: () {
            secureKeyboardController.show(
              type: SecureKeyboardType.NUMERIC,
              textFieldFocusNode: pinCodeTextFieldFocusNode,
              initText: pinCodeEditor.text,
              hintText: 'pinCode',
              // Use onDoneKeyPressed to allow text to be entered when you press the done key,
              // or to do something like encryption.
              onDoneKeyPressed: (List<int> charCodes) {
                pinCodeEditor.text = String.fromCharCodes(charCodes);
              }
            );
          },
        ),
      ],
    );
  }
}
```

## Package

* [WithSecureKeyboard] - A widget that implements a secure keyboard with controller.
* [SecureKeyboardController] - Controller to check or control the state of the secure keyboard.

**Note:** The parameters marked with an asterisk(*) are required.

### WithSecureKeyboard

| Parameter | Description |
|---|---|
| `controller`* | Controller for controlling the secure keyboard. |
| `child`* | A widget to have a secure keyboard. |
| `keyboardHeight` | Parameter to set the keyboard height. <br> Default value is `280.0`. |
| `keyRadius` | Set the radius of the keyboard key. <br> Default value is `4.0`. |
| `keySpacing` | Set the spacing between keyboard keys. <br> Default value is `1.4`. |
| `keyInputMonitorPadding` | Set the padding of the key input monitor. <br> Default value is `EdgeInsets.only(left: 10.0, right: 5.0)`. |
| `keyboardPadding` | Set the padding of the keyboard. <br> Default value is `EdgeInsets.symmetric(horizontal: 5.0)`. |
| `backgroundColor` | Parameter to set the keyboard background color. <br> Default value is `Color(0xFF0A0A0A)`. |
| `stringKeyColor` | Parameter to set keyboard string key(alphanumeric, numeric..) color. <br> Default value is `Color(0xFF313131)`. |
| `actionKeyColor` | Parameter to set keyboard action key(shift, backspace, clear..) color. <br> Default value is `Color(0xFF222222)`. |
| `doneKeyColor` | Parameter to set keyboard done key color. <br> Default value is `Color(0xFF1C7CDC)`. |
| `activatedKeyColor` | Set the color to display when activated with the shift action key. If the value is null, `doneKeyColor` is used. |
| `keyTextStyle` | Parameter to set keyboard key text style. <br> Default value is `TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)`. |
| `inputTextStyle` | Parameter to set keyboard input text style. <br> Default value is `TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)`. |
| `screenCaptureDetectedAlertTitle` | Security Alert title, only works on ios. |
| `screenCaptureDetectedAlertMessage` | Security Alert message, only works on ios |
| `screenCaptureDetectedAlertActionTitle` | Security Alert actionTitle, only works on ios. |

### SecureKeyboardController

| Function | Description |
|---|---|
| `isShowing` | Whether the secure keyboard is open. |
| `show` | Show a secure keyboard. |
| `hide` | Hide a secure keyboard. |

### SecureKeyboardController.show()

| Parameter | Description |
|---|---|
| `type`* | Specifies the secure keyboard type. |
| `textFieldFocusNode` | The `FocusNode` that will receive focus on. |
| `initText` | Set the initial value of the input text. |
| `hintText` | The hint text to display when the input text is empty. |
| `inputTextLengthSymbol` | Set the symbol to use when displaying the input text length. |
| `doneKeyText` | Set the done key text. |
| `clearKeyText` | Set the clear key text. |
| `obscuringCharacter` | Set the secure character to hide the input text. <br> Default value is `•`. |
| `maxLength` | Set the maximum length of text that can be entered. |
| `alwaysCaps` | Whether to always display uppercase characters. <br> Default value is `false`. |
| `obscureText` | Whether to hide input text as secure characters. <br> Default value is `true`. |
| `shuffleNumericKey` | Whether to shuffle the position of the numeric keys. <br> Default value is `true`. |
| `onKeyPressed` | Called when the key is pressed. |
| `onCharCodesChanged` | Called when the character codes changed. |
| `onDoneKeyPressed` | Called when the done key is pressed. |
| `onCloseKeyPressed` | Called when the close key is pressed. |
