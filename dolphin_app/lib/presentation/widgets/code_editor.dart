import 'package:dolphin_app/presentation/widgets/code_find.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/dart.dart';
import 'package:re_highlight/styles/atom-one-dark.dart';

class CodeEditorWidget extends HookWidget {
  final String text;

  const CodeEditorWidget({
    super.key,
    this.text = "",
  });

  @override
  Widget build(BuildContext context) {
    final editingController = useCodeLineEditingController(
      text: text,
    );
    final verticalScroller = useScrollController();
    final horizontalScroller = useScrollController();
    final scrollController = useCodeScrollController(
      verticalScroller: verticalScroller,
      horizontalScroller: horizontalScroller,
    );
    final findController = useCodeFindController(
      editingController: editingController,
    );

    return CodeEditor(
      controller: editingController,
      scrollController: scrollController,
      findController: findController,
      style: CodeEditorStyle(
        fontSize: 16,
        codeTheme: CodeHighlightTheme(
          languages: {'dart': CodeHighlightThemeMode(mode: langDart)},
          theme: atomOneDarkTheme,
        ),
      ),
      indicatorBuilder:
          (context, editingController, chunkController, notifier) {
        return Row(
          children: [
            DefaultCodeLineNumber(
              controller: editingController,
              notifier: notifier,
            ),
            DefaultCodeChunkIndicator(
              width: 20,
              controller: chunkController,
              notifier: notifier,
            )
          ],
        );
      },
      findBuilder: (context, controller, readOnly) => CodeFindPanelView(
        controller: controller,
        readOnly: readOnly,
      ),
    );
  }
}

CodeLineEditingController useCodeLineEditingController(
    {String text = "", int indentSize = 4}) {
  return use(
    CodeLineEditingControllerHook(
      text: text,
      indentSize: indentSize,
    ),
  );
}

CodeScrollController useCodeScrollController({
  required ScrollController verticalScroller,
  required ScrollController horizontalScroller,
}) {
  return use(
    CodeScrollControllerHook(
      verticalScroller: verticalScroller,
      horizontalScroller: horizontalScroller,
    ),
  );
}

CodeFindController useCodeFindController({
  required CodeLineEditingController editingController,
}) {
  return use(
    CodeFindControllerHook(
      editingController: editingController,
    ),
  );
}

class CodeLineEditingControllerHook extends Hook<CodeLineEditingController> {
  final String text;
  final int indentSize;

  const CodeLineEditingControllerHook({
    this.text = "",
    this.indentSize = 4,
  });

  @override
  HookState<CodeLineEditingController, Hook<CodeLineEditingController>>
      createState() => CodeLineEditingControllerHookState();
}

class CodeLineEditingControllerHookState extends HookState<
    CodeLineEditingController, CodeLineEditingControllerHook> {
  late CodeLineEditingController _controller;

  @override
  CodeLineEditingController build(BuildContext context) {
    return _controller;
  }

  @override
  void initHook() {
    super.initHook();

    _controller = CodeLineEditingController(
      codeLines: CodeLines.fromText(hook.text),
      options: CodeLineOptions(
        indentSize: hook.indentSize,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}

class CodeScrollControllerHook extends Hook<CodeScrollController> {
  final ScrollController verticalScroller;
  final ScrollController horizontalScroller;

  const CodeScrollControllerHook({
    required this.verticalScroller,
    required this.horizontalScroller,
  });

  @override
  HookState<CodeScrollController, Hook<CodeScrollController>> createState() =>
      CodeScrollControllerHookState();
}

class CodeScrollControllerHookState
    extends HookState<CodeScrollController, CodeScrollControllerHook> {
  late CodeScrollController _controller;

  @override
  CodeScrollController build(BuildContext context) {
    return _controller;
  }

  @override
  void initHook() {
    super.initHook();

    _controller = CodeScrollController(
      verticalScroller: hook.verticalScroller,
      horizontalScroller: hook.horizontalScroller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}

class CodeFindControllerHook extends Hook<CodeFindController> {
  final CodeLineEditingController editingController;

  const CodeFindControllerHook({
    required this.editingController,
  });

  @override
  HookState<CodeFindController, Hook<CodeFindController>> createState() =>
      CodeFindControllerHookState();
}

class CodeFindControllerHookState
    extends HookState<CodeFindController, CodeFindControllerHook> {
  late CodeFindController _controller;

  @override
  CodeFindController build(BuildContext context) {
    return _controller;
  }

  @override
  void initHook() {
    super.initHook();

    _controller = CodeFindController(
      hook.editingController,
    );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }
}
