import 'package:dolphin_app/pages/editor_page.dart';
import 'package:dolphin_app/provider/workspace_provider.dart';
import 'package:dolphin_app/theme/color_schemes.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WorkspaceProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dolphin',
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: CodeTheme(
        data: CodeThemeData(styles: monokaiSublimeTheme),
        child: const EditorPage(),
      ),
    );
  }
}
