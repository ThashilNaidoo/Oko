import 'package:english_words/english_words.dart';
import 'package:flex_seed_scheme/flex_seed_scheme.dart';
import 'package:flutter/material.dart';
import 'package:client/home/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ColorScheme schemeLight = SeedColorScheme.fromSeeds(
    primaryKey: const Color.fromARGB(255, 10, 92, 54),
    brightness: Brightness.light,
    variant: FlexSchemeVariant.rainbow,
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Oko',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: schemeLight,
        ),
        home: HomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}
