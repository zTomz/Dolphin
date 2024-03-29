import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

class WorkspaceProvider extends ChangeNotifier {
  WorkspaceProvider() {
    setDirectory(Directory.current);
  }

  double _sideMenuWidth = 300;
  double get sideMenuWidth => _sideMenuWidth;

  Directory _directory = Directory.current;
  Directory get directory => _directory;

  StreamSubscription<FileSystemEvent>? _directorySubscription;

  List<FileSystemEntity> _files = [];
  List<FileSystemEntity> get files => _files;

  /// Change the side menu width by the given offset
  void updateSideMenuWidth(double offset, BuildContext context) {
    // If the offset is too big or too small, return, so that the side menu
    // width doesn't go out of bounds
    if (sideMenuWidth + offset < 0 ||
        sideMenuWidth + offset > MediaQuery.sizeOf(context).width - 50) {
      return;
    }

    _sideMenuWidth += offset;

    notifyListeners();
  }

  /// Set the directory to the given one. This cancels the current subscription
  /// and starts a new one. And also loads the files from the new directory.
  void setDirectory(Directory directory) {
    // Reset
    _directorySubscription?.cancel();
    _files = [];

    // Load the files in the current directory
    _directory.list().listen((event) {
      _files.add(event);

      notifyListeners();
    });

    // Listen to changes
    _directorySubscription = _directory.watch(recursive: true).listen(
      (event) {
        print(event);
      },
    );
  }
}
