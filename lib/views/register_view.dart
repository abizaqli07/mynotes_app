import 'package:flutter/material.dart';
import 'package:mynotes_app/constants/routes.dart';
import 'package:mynotes_app/services/auth/auth_exceptions.dart';
import 'package:mynotes_app/services/auth/auth_service.dart';
import 'package:mynotes_app/utils/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: Column(
          children: [
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: "Enter your email here"),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: "Enter your password here",
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false,
                  );
                } on WeakPasswordAuthException {
                  await showErrorDialog(
                    context,
                    "Your Password too Weak",
                  );
                } on EmailAlreadyInUseAuthException {
                  await showErrorDialog(
                    context,
                    "The Email Address Already in Use",
                  );
                } on InvalidEmailAuthException {
                  await showErrorDialog(
                    context,
                    "Invalid Email",
                  );
                } on GenericAuthException {
                  await showErrorDialog(
                    context,
                    "Error : Register Error, Failed to create user",
                  );
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                },
                child: const Text("Already registered? Login here!"))
          ],
        ));
  }
}
