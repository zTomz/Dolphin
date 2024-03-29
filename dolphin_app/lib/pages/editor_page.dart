import 'package:dolphin_app/extensions/file_system_entity_extension.dart';
import 'package:dolphin_app/extensions/theme_extension.dart';
import 'package:dolphin_app/provider/workspace_provider.dart';
import 'package:dolphin_app/theme/app_spacing.dart';
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
            color: context.colorScheme.surface,
            padding: const EdgeInsets.all(AppSpacing.small),
            child: ListView.builder(
              itemCount: workspaceProvider.files.length,
              itemBuilder: (context, index) {
                final entity = workspaceProvider.files[index];

                return MaterialButton(
                  onPressed: () {
                    // TODO: Handle open a file or folder
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30,
                        child: entity.isDirectory
                            ? const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                              )
                            : null,
                      ),
                      SizedBox(
                        width: 30,
                        child: entity.isDirectory
                            ? const Icon(
                                Icons.folder_rounded,
                                size: 18,
                              )
                            : const Icon(
                                Icons.description_rounded,
                                size: 18,
                              ),
                      ),
                      Expanded(
                        child: Text(
                          entity.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: context.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
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
                color: context.colorScheme.surface,
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
