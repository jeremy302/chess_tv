import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
//import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
//import 'package:tab_container/tab_container.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
//import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import './app/pages/layout.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  //int index=0;
  @override
  Widget build(BuildContext context) {
    return MixTheme(
      data: MixThemeData(),
      child: MaterialApp(
          title: 'Chess TV',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
            useMaterial3: true,
          ),
          home: HomeLayout()),
    );
  }
}
