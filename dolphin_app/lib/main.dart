import 'package:dolphin_app/pages/editor_page.dart';
import 'package:dolphin_app/provider/workspace_provider.dart';
import 'package:dolphin_code_field/code_text_field.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:flutter/material.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CodeTheme(
        data: CodeThemeData(
          styles: monokaiTheme,
        ),
        child: EditorPage(),
      ),
    );
  }
}
