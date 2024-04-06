import 'dart:io';
import 'dart:math';

import 'package:dolphin_app/provider/workspace_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class OverlayPage extends HookWidget {
  final Widget body;

  const OverlayPage({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final workspaceProvider = context.watch<WorkspaceProvider>();

    final palletController = useTextEditingController();
    final palletFocusNode = useFocusNode(
      onKeyEvent: (focusNode, value) {
        if (value.logicalKey == LogicalKeyboardKey.enter) {
          final palletText = palletController.text;

          if (palletText.startsWith('>')) {
            // TODO: Work with command
          } else {
            final allFiles =
                workspaceProvider.directory.listSync(recursive: true);
            final choosenFile = File(
              allFiles
                  .firstWhere((element) => element.path.endsWith(palletText))
                  .path,
            );

            context.read<WorkspaceProvider>().setSelectedFile(choosenFile);
          }

          palletController.clear();
          context.read<WorkspaceProvider>().palletOpen = false;
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
    );

    return Shortcuts(
      shortcuts: {
        const SingleActivator(LogicalKeyboardKey.escape):
            const ClosePalletIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyP):
            const OpenFilePalletIntent(),
        LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
            LogicalKeyboardKey.keyP): const OpenCommandPalletIntent(),
      },
      child: Actions(
        actions: {
          ClosePalletIntent: CallbackAction<ClosePalletIntent>(
            onInvoke: (ClosePalletIntent intent) {
              context.read<WorkspaceProvider>().palletOpen = false;
              palletController.clear();
              return null;
            },
          ),
          OpenFilePalletIntent: CallbackAction<OpenFilePalletIntent>(
            onInvoke: (OpenFilePalletIntent intent) {
              context.read<WorkspaceProvider>().palletOpen = true;
              palletFocusNode.requestFocus();
              return null;
            },
          ),
          OpenCommandPalletIntent: CallbackAction<OpenCommandPalletIntent>(
            onInvoke: (OpenCommandPalletIntent intent) {
              context.read<WorkspaceProvider>().palletOpen = true;
              palletController.text = ">";
              palletFocusNode.requestFocus();
              return null;
            },
          ),
        },
        child: FocusScope(
          autofocus: true,
          child: Column(
            children: [
              SizedBox(
                height: 40,
                child: WindowCaption(
                  title: Row(
                    children: [
                      SizedBox.square(
                        dimension: 20,
                        child: Image.asset("assets/app/icon.png"),
                      ),
                      const SizedBox(width: 15),
                      const Text("Dolphin"),
                      MenuAnchor(
                        builder: (context, controller, child) => TextButton(
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text("File"),
                        ),
                        menuChildren: [
                          MenuAnchor(
                            builder: (context, controller, child) => TextButton(
                              onPressed: () {
                                if (controller.isOpen) {
                                  controller.close();
                                } else {
                                  controller.open();
                                }
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text("Preferences"),
                            ),
                            menuChildren: [
                              MenuItemButton(
                                onPressed: () {},
                                child: const Text("Theme"),
                              ),
                            ],
                          ),
                          MenuItemButton(
                            onPressed: () async {},
                            child: const Text("Test 2"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.background,
                  brightness: Theme.of(context).colorScheme.brightness,
                ),
              ),
              Expanded(
                child: Material(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(child: body),
                      if (workspaceProvider.palletOpen)
                        Positioned(
                          top: 15,
                          child: Container(
                            width: min(
                                400, MediaQuery.sizeOf(context).width * 0.4),
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: palletController,
                              focusNode: palletFocusNode,
                              decoration: InputDecoration.collapsed(
                                hintText: palletController.text.startsWith('>')
                                    ? "Search command by name"
                                    : "Search file by name",
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OpenFilePalletIntent extends Intent {
  const OpenFilePalletIntent();
}

class OpenCommandPalletIntent extends Intent {
  const OpenCommandPalletIntent();
}

class ClosePalletIntent extends Intent {
  const ClosePalletIntent();
}
