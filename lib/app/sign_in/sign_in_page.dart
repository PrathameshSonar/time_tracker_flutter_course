import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:timetrackerfluttercourse/app/sign_in/email_sign_in_page.dart';
import 'package:timetrackerfluttercourse/app/sign_in/sign_in_bloc.dart';
import 'package:timetrackerfluttercourse/app/sign_in/sign_in_button.dart';
import 'package:timetrackerfluttercourse/app/sign_in/social_sign_in_button.dart';
import 'package:timetrackerfluttercourse/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(),
      child: Consumer<SignInBloc>(builder: (context, bloc, _) => SignInPage(bloc: bloc,)),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {

    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
      bloc.setIsLoading(false);
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    } finally {
      bloc.setIsLoading(false);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {

    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    } finally {
      bloc.setIsLoading(false);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {

    try {
      bloc.setIsLoading(true);
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithFacebook();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    } finally {
      bloc.setIsLoading(false);
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 10.0,

      ),
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          },
      ),
      backgroundColor: Colors.grey[300],
    );
  }

  Widget _buildContent(BuildContext context, bool isLoading) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(isLoading),
          ),
          SizedBox(
            height: 60.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                elevation: 10.0,
                color: Color(0xFF1D1E33),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SocialSignInButton(
                    assetName: 'images/google-logo.png',
                    color: Colors.white,
                    onPressed: isLoading ? null : () => _signInWithGoogle(context),
                  ),
                ),
              ),
              Card(
                elevation: 10.0,
                color: Color(0xFF1D1E33),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SocialSignInButton(
                    assetName: 'images/facebook-logo.png',
                    color: Color(0xFF334D92),
                    onPressed: isLoading ? null : () => _signInWithFacebook(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                elevation: 10.0,
                color: Color(0xFF1D1E33),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SignInButton(
                    text: 'Sign in with \n Email',
                    textColor: Colors.black87,
                    color: Colors.teal[300],
                    onPressed: isLoading ? null : () => _signInWithEmail(context),
                  ),
                ),
              ),
              Card(
                elevation: 10.0,
                color: Color(0xFF1D1E33),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SignInButton(
                    text: 'Sign In with \n Email Link',
                    textColor: Colors.black87,
                    color: Colors.grey,
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          Text(
            'or',
            style: TextStyle(fontSize: 20.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          SizedBox(
            width: 70.0,
            child: SignInButton(
              text: 'Go Anonymous',
              textColor: Colors.black,
              color: Colors.lime[300],
              onPressed: isLoading ? null : () => _signInAnonymously(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text(
        'Sign In',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 48.0,
          fontWeight: FontWeight.w500,
        ),
      );
    }
  }
}
