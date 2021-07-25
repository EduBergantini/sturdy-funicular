import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Text('Login'.toUpperCase()),
            ),
            Form(
                child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    icon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                ElevatedButton(
                    onPressed: () {}, child: Text('Entrar'.toUpperCase())),
                TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.person),
                    label: Text('Esqueci minha senha'))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
