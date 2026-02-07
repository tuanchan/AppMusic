import 'dart:io';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/song.dart';

class FileService {
  static final FileService _instance = FileService._internal();
  factory FileService() => _instance;
  FileService._internal();

  static const String _songsKey = 'saved_songs';
  static const List<String> _audioExtensions = [
    '.mp3', '.m4a', '.wav', '.flac', '.aac', '.ogg', '.wma', '.opus'
  ];

  // Request storage permission
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (status.isDenied) {
        final status2 = await Permission.manageExternalStorage.request();
        return status2.isGranted;
      }
      return status.isGranted;
    } else if (Platform.isIOS) {
      final status = await Permission.mediaLibrary.request();
      return status.isGranted;
    }
    return true;
  }

  // Pick audio files
  Future<List<Song>> pickAudioFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        List<Song> songs = [];
        for (var file in result.files) {
          if (file.path != null) {
            songs.add(_createSongFromFile(File(file.path!)));
          }
        }
        return songs;
      }
    } catch (e) {
      print('Error picking files: $e');
    }
    return [];
  }

  // Pick folder and scan for audio files
  Future<List<Song>> pickFolder() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        return await scanFolder(selectedDirectory);
      }
    } catch (e) {
      print('Error picking folder: $e');
    }
    return [];
  }

  // Scan folder recursively for audio files
  Future<List<Song>> scanFolder(String folderPath) async {
    List<Song> songs = [];
    try {
      final directory = Directory(folderPath);
      if (!await directory.exists()) return songs;

      await for (var entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is File && _isAudioFile(entity.path)) {
          songs.add(_createSongFromFile(entity));
        }
      }
    } catch (e) {
      print('Error scanning folder: $e');
    }
    return songs;
  }

  // Check if file is audio
  bool _isAudioFile(String path) {
    final extension = path.toLowerCase().substring(path.lastIndexOf('.'));
    return _audioExtensions.contains(extension);
  }

  // Create Song object from file
  Song _createSongFromFile(File file) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    final nameWithoutExt = fileName.substring(0, fileName.lastIndexOf('.'));
    
    return Song(
      id: DateTime.now().millisecondsSinceEpoch.toString() + fileName.hashCode.toString(),
      title: nameWithoutExt,
      path: file.path,
      addedDate: DateTime.now(),
    );
  }

  // Rename file
  Future<Song?> renameFile(Song song, String newName) async {
    try {
      final file = File(song.path);
      if (!await file.exists()) return null;

      final directory = file.parent.path;
      final extension = song.path.substring(song.path.lastIndexOf('.'));
      final newPath = '$directory${Platform.pathSeparator}$newName$extension';
      
      final newFile = await file.rename(newPath);
      
      return song.copyWith(
        title: newName,
        path: newFile.path,
      );
    } catch (e) {
      print('Error renaming file: $e');
      return null;
    }
  }

  // Delete file
  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
    return false;
  }

  // Save songs to local storage
  Future<bool> saveSongs(List<Song> songs) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = songs.map((song) => song.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      return await prefs.setString(_songsKey, jsonString);
    } catch (e) {
      print('Error saving songs: $e');
      return false;
    }
  }

  // Load songs from local storage
  Future<List<Song>> loadSongs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_songsKey);
      
      if (jsonString != null) {
        final jsonList = jsonDecode(jsonString) as List;
        final songs = jsonList.map((json) => Song.fromJson(json)).toList();
        
        // Filter out songs whose files no longer exist
        List<Song> validSongs = [];
        for (var song in songs) {
          if (await File(song.path).exists()) {
            validSongs.add(song);
          }
        }
        
        // Save valid songs back if list changed
        if (validSongs.length != songs.length) {
          await saveSongs(validSongs);
        }
        
        return validSongs;
      }
    } catch (e) {
      print('Error loading songs: $e');
    }
    return [];
  }

  // Get app documents directory
  Future<String> getAppDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
