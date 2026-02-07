import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';
import '../services/music_service.dart';
import '../utils/app_theme.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> with SingleTickerProviderStateMixin {
  final MusicService _musicService = MusicService();
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _musicService.playingStream.listen((playing) {
      if (playing) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.black,
              AppTheme.darkRed.withOpacity(0.3),
              AppTheme.black,
            ],
          ),
        ),
        child: SafeArea(
          child: StreamBuilder<Song?>(
            stream: _musicService.currentIndexStream.map(
              (index) => index != null && index < _musicService.playlist.length
                  ? _musicService.playlist[index]
                  : null,
            ),
            builder: (context, snapshot) {
              final song = snapshot.data;
              
              if (song == null) {
                return _buildEmptyState();
              }

              return Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildAlbumArt(song),
                        _buildSongInfo(song),
                        _buildProgressBar(),
                        _buildControls(),
                        _buildAdditionalControls(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_off,
            size: 100,
            color: AppTheme.neonRed.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'No song playing',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Add songs to start playing',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            iconSize: 32,
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            'NOW PLAYING',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            iconSize: 32,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(Song song) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: RotationTransition(
        turns: _rotationController,
        child: Container(
          width: 280,
          height: 280,
          decoration: AppTheme.neonGlow(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(140),
            child: Container(
              color: AppTheme.darkGray,
              child: Icon(
                Icons.music_note,
                size: 120,
                color: AppTheme.neonRed,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSongInfo(Song song) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: [
          Text(
            song.title,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            song.artist ?? 'Unknown Artist',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: StreamBuilder<Map<String, dynamic>>(
        stream: _musicService.playerStream,
        builder: (context, snapshot) {
          final position = snapshot.data?['position'] as Duration? ?? Duration.zero;
          final duration = snapshot.data?['duration'] as Duration? ?? Duration.zero;

          return Column(
            children: [
              ProgressBar(
                progress: position,
                total: duration,
                onSeek: (duration) {
                  _musicService.seek(duration);
                },
                barHeight: 4,
                thumbRadius: 8,
                progressBarColor: AppTheme.neonRed,
                baseBarColor: AppTheme.lightGray,
                bufferedBarColor: AppTheme.lightGray,
                thumbColor: AppTheme.neonRed,
                thumbGlowRadius: 20,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    _formatDuration(duration),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.skip_previous),
            iconSize: 48,
            onPressed: _musicService.previous,
            color: AppTheme.neonRed,
          ),
          StreamBuilder<bool>(
            stream: _musicService.playingStream,
            builder: (context, snapshot) {
              final isPlaying = snapshot.data ?? false;
              return Container(
                decoration: AppTheme.neonGlow(),
                child: IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 64,
                  onPressed: _musicService.togglePlayPause,
                  color: AppTheme.neonRed,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.skip_next),
            iconSize: 48,
            onPressed: _musicService.next,
            color: AppTheme.neonRed,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          StreamBuilder<bool>(
            stream: _musicService.shuffleStream,
            builder: (context, snapshot) {
              final isShuffle = snapshot.data ?? false;
              return IconButton(
                icon: Icon(
                  Icons.shuffle,
                  color: isShuffle ? AppTheme.neonRed : AppTheme.textGray,
                ),
                onPressed: _musicService.toggleShuffle,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.playlist_play),
            color: AppTheme.textGray,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          StreamBuilder<LoopMode>(
            stream: _musicService.loopModeStream,
            builder: (context, snapshot) {
              final loopMode = snapshot.data ?? LoopMode.off;
              IconData icon;
              Color color;

              switch (loopMode) {
                case LoopMode.off:
                  icon = Icons.repeat;
                  color = AppTheme.textGray;
                  break;
                case LoopMode.one:
                  icon = Icons.repeat_one;
                  color = AppTheme.neonRed;
                  break;
                case LoopMode.all:
                  icon = Icons.repeat;
                  color = AppTheme.neonRed;
                  break;
              }

              return IconButton(
                icon: Icon(icon, color: color),
                onPressed: _musicService.toggleLoopMode,
              );
            },
          ),
        ],
      ),
    );
  }
}
