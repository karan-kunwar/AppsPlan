import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
          builder: (context, ThemeNotifier notifier, child) {
        return MaterialApp(
          title: 'Calwin App',
          debugShowCheckedModeBanner: false,
          theme: notifier.isDarkTheme ? dark : light,
          home: SignInScreen(),
        );
      }),
    );
  }
}
