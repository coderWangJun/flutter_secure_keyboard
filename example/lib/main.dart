import 'package:flutter/material.dart';
import 'package:flutter_secure_keyboard/flutter_secure_keyboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WithSecureKeyboardExample()
    );
  }
}

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
              type: SecureKeyboardType.Alphanumeric,
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
              type: SecureKeyboardType.Numeric,
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