import 'dart:async';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../models/song.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  
  final BehaviorSubject<List<Song>> _playlistSubject = BehaviorSubject.seeded([]);
  final BehaviorSubject<int?> _currentIndexSubject = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool> _shuffleSubject = BehaviorSubject.seeded(false);
  final BehaviorSubject<LoopMode> _loopModeSubject = BehaviorSubject.seeded(LoopMode.off);

  // Streams
  Stream<List<Song>> get playlistStream => _playlistSubject.stream;
  Stream<int?> get currentIndexStream => _currentIndexSubject.stream;
  Stream<bool> get shuffleStream => _shuffleSubject.stream;
  Stream<LoopMode> get loopModeStream => _loopModeSubject.stream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<bool> get playingStream => _audioPlayer.playingStream;

  // Getters
  List<Song> get playlist => _playlistSubject.value;
  int? get currentIndex => _currentIndexSubject.value;
  Song? get currentSong => currentIndex != null && currentIndex! < playlist.length 
      ? playlist[currentIndex!] 
      : null;
  bool get isPlaying => _audioPlayer.playing;
  Duration get position => _audioPlayer.position;
  Duration? get duration => _audioPlayer.duration;

  // Combined stream for player state
  Stream<Map<String, dynamic>> get playerStream => Rx.combineLatest4(
    positionStream,
    durationStream,
    playingStream,
    currentIndexStream,
    (position, duration, playing, index) => {
      'position': position,
      'duration': duration,
      'playing': playing,
      'index': index,
    },
  );

  Future<void> setPlaylist(List<Song> songs, {int initialIndex = 0}) async {
    _playlistSubject.add(songs);
    if (songs.isNotEmpty && initialIndex < songs.length) {
      await playSongAt(initialIndex);
    }
  }

  Future<void> playSongAt(int index) async {
    if (index < 0 || index >= playlist.length) return;
    
    try {
      final song = playlist[index];
      _currentIndexSubject.add(index);
      
      await _audioPlayer.setFilePath(song.path);
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> play() async {
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> next() async {
    if (currentIndex == null || playlist.isEmpty) return;
    
    int nextIndex;
    if (_shuffleSubject.value) {
      nextIndex = (currentIndex! + 1) % playlist.length;
    } else {
      nextIndex = (currentIndex! + 1) % playlist.length;
    }
    
    await playSongAt(nextIndex);
  }

  Future<void> previous() async {
    if (currentIndex == null || playlist.isEmpty) return;
    
    // If more than 3 seconds played, restart current song
    if (position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }
    
    int prevIndex = (currentIndex! - 1 + playlist.length) % playlist.length;
    await playSongAt(prevIndex);
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> toggleShuffle() async {
    _shuffleSubject.add(!_shuffleSubject.value);
  }

  Future<void> toggleLoopMode() async {
    final modes = [LoopMode.off, LoopMode.one, LoopMode.all];
    final currentMode = _loopModeSubject.value;
    final currentModeIndex = modes.indexOf(currentMode);
    final nextMode = modes[(currentModeIndex + 1) % modes.length];
    
    _loopModeSubject.add(nextMode);
    await _audioPlayer.setLoopMode(nextMode);
  }

  void addSong(Song song) {
    final updatedPlaylist = List<Song>.from(playlist)..add(song);
    _playlistSubject.add(updatedPlaylist);
  }

  void addSongs(List<Song> songs) {
    final updatedPlaylist = List<Song>.from(playlist)..addAll(songs);
    _playlistSubject.add(updatedPlaylist);
  }

  void removeSong(int index) {
    if (index < 0 || index >= playlist.length) return;
    
    final updatedPlaylist = List<Song>.from(playlist)..removeAt(index);
    _playlistSubject.add(updatedPlaylist);
    
    if (currentIndex == index) {
      _currentIndexSubject.add(null);
      _audioPlayer.stop();
    } else if (currentIndex != null && currentIndex! > index) {
      _currentIndexSubject.add(currentIndex! - 1);
    }
  }

  void updateSong(int index, Song song) {
    if (index < 0 || index >= playlist.length) return;
    
    final updatedPlaylist = List<Song>.from(playlist);
    updatedPlaylist[index] = song;
    _playlistSubject.add(updatedPlaylist);
  }

  void clearPlaylist() {
    _playlistSubject.add([]);
    _currentIndexSubject.add(null);
    _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
    _playlistSubject.close();
    _currentIndexSubject.close();
    _shuffleSubject.close();
    _loopModeSubject.close();
  }
}
