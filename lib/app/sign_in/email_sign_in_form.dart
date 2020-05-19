import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetrackerfluttercourse/app/sign_in/social_sign_in_button.dart';
import 'package:timetrackerfluttercourse/app/sign_in/validators.dart';
import 'package:timetrackerfluttercourse/common_widgets/custom_flat_button.dart';
import 'package:timetrackerfluttercourse/common_widgets/custom_raised_button.dart';
import 'package:timetrackerfluttercourse/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';


enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswwordValidators {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,

      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingCompleted() {
    final newFocus = widget.emailValidator.isValid(_email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Don\'t have an account ? Register'
        : 'Have an account? Sign In';

    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      SizedBox(height: 50.0),
      _buildEmailTextField(),
      SizedBox(height: 10.0),
      _buildPasswordTextField(),
      SizedBox(height: 10.0),
      CustomFlatButton(
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Color(0xFF6200F0),
          ),
        ),
        onPressed: () {},
      ),
      SizedBox(height: 10.0),
      ButtonTheme(
        minWidth: 300.0,
        height: 50.0,
        child: CustomRaisedButton(
          child: Text(
            primaryText,
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          ),
          onPressed: submitEnabled ? _submit : null,
          color: Color(0xFF6200F0),
        ),
      ),
      SizedBox(height: 10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            color: Colors.white,
            onPressed: () {},
          ),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            color: Color(0xFF2A5194),
            onPressed: () {},
          )
        ],
      ),
      SizedBox(height: 20.0),
      CustomFlatButton(
        child: Text(
          secondaryText,
          style: TextStyle(
              color: Color(0xFF6200F0),
              fontSize: 17.0
          ),
        ),
        onPressed: !_isLoading ? _toggleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: _isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password) => _updateState(),
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: _isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingCompleted,
      onChanged: (email) => _updateState(),
    );
  }

  _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
