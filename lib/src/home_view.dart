// Copyright 2022 Kato Shinya. All rights reserved.
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided the conditions.

import 'package:flutter/material.dart';
import 'package:tweet_ui/tweet_ui.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key, required this.accessToken}) : super(key: key);

  final String accessToken;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TwitterApi _twitter;

  @override
  void initState() {
    super.initState();

    _twitter = TwitterApi(bearerToken: widget.accessToken);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                future: _twitter.usersService.lookupMe(),
                builder: (_, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final UserData me = snapshot.data.data;

                  return FutureBuilder(
                    future: _twitter.tweetsService.lookupHomeTimeline(
                      userId: me.id,
                      expansions: [
                        TweetExpansion.authorId,
                      ],
                      userFields: [
                        UserField.profileImageUrl,
                      ],
                    ),
                    builder: (__, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final TwitterResponse<List<TweetData>, TweetMeta>
                          response = snapshot.data;

                      return EmbeddedTweetView.fromTweetV2(
                        TweetV2Response.fromJson(response.toJson()),
                        showRepliesCount: true,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
}
