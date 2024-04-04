import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:torre_hanoi/app/hanoi_tower.dart';
import 'package:torre_hanoi/app/play_game.dart';
import 'package:torre_hanoi/service/game_controller.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GameController.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hanoi Towers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: GoRouter(routes: [
        GoRoute(
          name: "home",
          path: '/',
          builder: (context, state) => PlayGame(),
          routes: [
            GoRoute(
              name: "game",
              path: 'game',
              builder: (context, state) => HanoiTower(state.extra as String),

            )
          ]
        )
      ]),
    );
  }
}
