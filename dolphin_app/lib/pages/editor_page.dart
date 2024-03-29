import 'package:dolphin_app/provider/workspace_provider.dart';
import 'package:dolphin_code_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/languages/dart.dart';
import 'package:provider/provider.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({super.key});

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
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
    final workspaceProvider = context.watch<WorkspaceProvider>();

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: workspaceProvider.sideMenuWidth,
            color: Colors.red,
            child: ListView.builder(
              itemCount: workspaceProvider.files.length,
              itemBuilder: (context, index) {
                return Text(workspaceProvider.files[index].path);
              },
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.resizeColumn,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                context
                    .read<WorkspaceProvider>()
                    .updateSideMenuWidth(details.delta.dx, context);
              },
              child: Container(
                width: 3,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: CodeField(
              expands: true,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  // void handleEvent(FileSystemEvent event) {
  //   if (event is FileSystemCreateEvent) {
  //     if (event.isDirectory) {
  //       setState(() {
  //         files.add(
  //           Directory(event.path),
  //         );
  //       });
  //     } else {
  //       setState(() {
  //         files.add(
  //           File(event.path),
  //         );
  //       });
  //     }
  //   }

  //   if (event is FileSystemDeleteEvent) {
  //     setState(() {
  //       files.removeWhere((element) => element.path == event.path);
  //     });
  //   }
  // }
}
