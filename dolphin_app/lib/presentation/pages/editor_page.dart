import 'dart:io';

import 'package:dolphin_app/extensions/file_system_entity_extension.dart';
import 'package:dolphin_app/extensions/theme_extension.dart';
import 'package:dolphin_app/presentation/pages/overlay_page.dart';
import 'package:dolphin_app/presentation/widgets/code_editor.dart';
import 'package:dolphin_app/provider/workspace_provider.dart';
import 'package:dolphin_app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditorPage extends StatelessWidget {
  const EditorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OverlayPage(
      body: Scaffold(
        body: Row(
          children: [
            Consumer<WorkspaceProvider>(
              builder: (context, workspaceProvider, _) => Container(
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
                  color: context.colorScheme.secondaryContainer,
                ),
              ),
            ),
            Expanded(
              child: Selector<WorkspaceProvider, File?>(
                builder: (context, selector, _) {
                  print("File changed");
                  // return Center(
                  //   child: Text(selector?.path ?? ""),
                  // );

                  if (selector == null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return StreamBuilder<FileSystemEvent>(
                    stream: selector.watch(),
                    builder: (context, snapshot) => FutureBuilder<String>(
                      future: selector.readAsString(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                    
                        return CodeEditorWidget(
                          text: snapshot.data ?? "",
                        );
                      },
                    ),
                  );
                },
                selector: (_, provider) => provider.selectedFile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
