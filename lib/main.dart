import 'package:clickup/color_utils.dart';
import 'package:clickup/presentation/router/app_router.dart';
import 'package:flutter/material.dart';

import 'locator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();
  @override
  void initState() {
    super.initState();
    registerServices();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ClickUp',
      theme: ThemeData(
        primarySwatch: generateMaterialColor(Palette.primary),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _appRouter.dispose();
  }
}
