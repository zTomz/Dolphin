import 'package:dolphin_code_field/code_text_field.dart';
import 'package:flutter_highlight/themes/monokai.dart';
import 'package:highlight/languages/dart.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
        child: MyCodeField(),
      ),
    );
  }
}

class MyCodeField extends StatefulWidget {
  const MyCodeField({super.key});

  @override
  State<MyCodeField> createState() => _MyCodeFieldState();
}

class _MyCodeFieldState extends State<MyCodeField> {
  late final CodeController controller;

  @override
  void initState() {
    super.initState();

    controller = CodeController(
      language: dart,
      params: const EditorParams(
        tabSpaces: 4,
      ),
      modifiers: [
        const IndentModifier(),
        const EnterBracketModifier(),
        ...bracketModifiers,
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CodeField(
        expands: true,
        controller: controller,
      ),
    );
  }
}
