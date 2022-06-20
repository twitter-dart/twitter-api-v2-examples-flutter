// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:flutter/material.dart';
import 'package:twitter_oauth2_pkce/twitter_oauth2_pkce.dart';

import 'home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _oauth2 = TwitterOAuth2(
    clientId: 'YOUR_CLIENT_ID',
    clientSecret: 'YOUR_CLIENT_SECRET',
    redirectUri: 'org.example.android.oauth://callback/',
    customUriScheme: 'org.example.android.oauth',
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final response = await _oauth2.executeAuthCodeFlowWithPKCE(
                scopes: [
                  Scope.tweetRead,
                  Scope.usersRead,
                  Scope.tweetWrite,
                  Scope.likeWrite,
                ],
              );

              if (!mounted) {
                return;
              }

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(
                    accessToken: response.accessToken!,
                  ),
                ),
              );
            },
            child: const Text('Login'),
          ),
        ),
      );
}
