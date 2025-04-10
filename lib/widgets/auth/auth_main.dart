import 'dart:developer';

import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter/material.dart';
import 'package:youllgetit_flutter/widgets/auth/profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  Credentials? _credentials;

  late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    auth0 = Auth0('dev-noubkiybttkpdcu4.eu.auth0.com', 'cC4B6I0iUEzZnHr0geeWePJyapl0Ghm3');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (_credentials == null)
          ElevatedButton(
              onPressed: () async {
                // Use a Universal Link callback URL on iOS 17.4+ / macOS 14.4+
                // useHTTPS is ignored on Android
                final credentials =
                    await auth0.webAuthentication().login(audience: 'https://api.youllgetit.com/user_db', useHTTPS: true);
                log('Access token: ${credentials.accessToken}');
                log(credentials.idToken);
                log(credentials.refreshToken!);
                log(credentials.user.toString());
                setState(() {
                  _credentials = credentials;
                });
              },
              child: const Text("Log in"))
        else
          Column(
            children: [
              ProfileView(user: _credentials!.user),
              ElevatedButton(
                  onPressed: () async {
                    // Use a Universal Link logout URL on iOS 17.4+ / macOS 14.4+
                    // useHTTPS is ignored on Android
                    await auth0.webAuthentication().logout(useHTTPS: true);

                    setState(() {
                      _credentials = null;
                    });
                  },
                  child: const Text("Log out"))
            ],
          )
      ],
    );
  }
}