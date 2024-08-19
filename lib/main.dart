import 'package:calendartest/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/event.dart';

Future<void> main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(EventAdapter());

  await Hive.openBox<Event>('eventsBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calender App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade700),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}
