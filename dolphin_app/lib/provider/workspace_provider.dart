import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';

class WorkspaceProvider extends ChangeNotifier {
  WorkspaceProvider() {
    setDirectory(Directory.current);
  }

  double _sideMenuWidth = 300;
  double get sideMenuWidth => _sideMenuWidth;

  bool _palletOpen = false;
  bool get palletOpen => _palletOpen;

  /// This automatically closes the command pallet if the file menu is open
  set palletOpen(bool value) {
    _palletOpen = value;

    notifyListeners();
  }

  Directory _directory = Directory.current;
  Directory get directory => _directory;

  StreamSubscription<FileSystemEvent>? _directorySubscription;

  List<FileSystemEntity> _files = [];
  List<FileSystemEntity> get files => _files;

  File? _selectedFile;
  File? get selectedFile => _selectedFile;
  void setSelectedFile(File newFile) {
    _selectedFile = newFile;

    notifyListeners();
  }

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

      _sortFileSystemEntities();

      notifyListeners();
    });

    // Listen to changes
    _directorySubscription = _directory.watch(recursive: true).listen(
      (event) {
        if (event is FileSystemCreateEvent) {
          if (event.isDirectory) {
            files.add(
              Directory(event.path),
            );
          } else {
            files.add(
              File(event.path),
            );
          }

          notifyListeners();
        }

        if (event is FileSystemDeleteEvent) {
          files.removeWhere((element) => element.path == event.path);

          notifyListeners();
        }
      },
    );
  }

  void _sortFileSystemEntities() {
    _files.sort((a, b) {
      if (a.path.startsWith('.') && !b.path.startsWith('.')) {
        return -1; // Hidden folders before everything
      } else if (a is Directory && b is File) {
        return -1; // Folders before files
      } else if (a is File && b is Directory) {
        return 1; // Files after folders
      } else {
        return a.path
            .toLowerCase()
            .compareTo(b.path.toLowerCase()); // Sort by path alphabetically
      }
    });
  }
}
