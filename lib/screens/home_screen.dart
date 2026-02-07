import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/music_service.dart';
import '../services/file_service.dart';
import '../utils/app_theme.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MusicService _musicService = MusicService();
  final FileService _fileService = FileService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    setState(() => _isLoading = true);
    final songs = await _fileService.loadSongs();
    await _musicService.setPlaylist(songs);
    setState(() => _isLoading = false);
  }

  Future<void> _importFiles() async {
    final hasPermission = await _fileService.requestPermission();
    if (!hasPermission) {
      _showMessage('Storage permission denied');
      return;
    }

    final songs = await _fileService.pickAudioFiles();
    if (songs.isNotEmpty) {
      _musicService.addSongs(songs);
      await _fileService.saveSongs(_musicService.playlist);
      _showMessage('${songs.length} songs added');
    }
  }

  Future<void> _importFolder() async {
    final hasPermission = await _fileService.requestPermission();
    if (!hasPermission) {
      _showMessage('Storage permission denied');
      return;
    }

    setState(() => _isLoading = true);
    final songs = await _fileService.pickFolder();
    setState(() => _isLoading = false);

    if (songs.isNotEmpty) {
      _musicService.addSongs(songs);
      await _fileService.saveSongs(_musicService.playlist);
      _showMessage('${songs.length} songs added from folder');
    }
  }

  Future<void> _deleteSong(int index, Song song) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkGray,
        title: const Text('Delete Song'),
        content: Text('Delete "${song.title}"?\nThis will remove the file from your device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.neonRed),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final deleted = await _fileService.deleteFile(song.path);
      if (deleted) {
        _musicService.removeSong(index);
        await _fileService.saveSongs(_musicService.playlist);
        _showMessage('Song deleted');
      } else {
        _showMessage('Failed to delete song');
      }
    }
  }

  Future<void> _renameSong(int index, Song song) async {
    final controller = TextEditingController(text: song.title);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkGray,
        title: const Text('Rename Song'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'New name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Rename'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && newName != song.title) {
      final renamedSong = await _fileService.renameFile(song, newName);
      if (renamedSong != null) {
        _musicService.updateSong(index, renamedSong);
        await _fileService.saveSongs(_musicService.playlist);
        _showMessage('Song renamed');
      } else {
        _showMessage('Failed to rename song');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.darkGray,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Player'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            color: AppTheme.darkGray,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.file_open, color: AppTheme.neonRed),
                    SizedBox(width: 12),
                    Text('Import Files'),
                  ],
                ),
                onTap: () => Future.delayed(
                  Duration.zero,
                  () => _importFiles(),
                ),
              ),
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.folder_open, color: AppTheme.neonRed),
                    SizedBox(width: 12),
                    Text('Import Folder'),
                  ],
                ),
                onTap: () => Future.delayed(
                  Duration.zero,
                  () => _importFolder(),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.neonRed))
          : StreamBuilder<List<Song>>(
              stream: _musicService.playlistStream,
              builder: (context, snapshot) {
                final songs = snapshot.data ?? [];

                if (songs.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return _buildSongTile(song, index);
                  },
                );
              },
            ),
      bottomNavigationBar: _buildMiniPlayer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _importFiles,
        backgroundColor: AppTheme.neonRed,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note,
            size: 100,
            color: AppTheme.neonRed.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'No songs yet',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Tap + to add music',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _importFiles,
            icon: const Icon(Icons.file_open),
            label: const Text('Import Files'),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _importFolder,
            icon: const Icon(Icons.folder_open),
            label: const Text('Import Folder'),
          ),
        ],
      ),
    );
  }

  Widget _buildSongTile(Song song, int index) {
    return StreamBuilder<int?>(
      stream: _musicService.currentIndexStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data == index;

        return Dismissible(
          key: Key(song.id),
          background: Container(
            color: Colors.red.withOpacity(0.3),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.red),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            await _deleteSong(index, song);
            return false;
          },
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: AppTheme.neonGlow(
                  color: isPlaying ? AppTheme.neonRed : AppTheme.darkRed,
                ),
                child: Icon(
                  isPlaying ? Icons.equalizer : Icons.music_note,
                  color: isPlaying ? AppTheme.neonRed : AppTheme.textGray,
                ),
              ),
              title: Text(
                song.title,
                style: TextStyle(
                  color: isPlaying ? AppTheme.neonRed : AppTheme.textWhite,
                  fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                song.artist ?? 'Unknown Artist',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                color: AppTheme.darkGray,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.edit, color: AppTheme.neonRed, size: 20),
                        SizedBox(width: 12),
                        Text('Rename'),
                      ],
                    ),
                    onTap: () => Future.delayed(
                      Duration.zero,
                      () => _renameSong(index, song),
                    ),
                  ),
                  PopupMenuItem(
                    child: const Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red, size: 20),
                        SizedBox(width: 12),
                        Text('Delete'),
                      ],
                    ),
                    onTap: () => Future.delayed(
                      Duration.zero,
                      () => _deleteSong(index, song),
                    ),
                  ),
                ],
              ),
              onTap: () => _musicService.playSongAt(index),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMiniPlayer() {
    return StreamBuilder<Song?>(
      stream: _musicService.currentIndexStream.map(
        (index) => index != null && index < _musicService.playlist.length
            ? _musicService.playlist[index]
            : null,
      ),
      builder: (context, snapshot) {
        final song = snapshot.data;
        if (song == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlayerScreen()),
            );
          },
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppTheme.darkGray,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.neonRed.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: AppTheme.neonGlow(),
                  child: const Icon(
                    Icons.music_note,
                    color: AppTheme.neonRed,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title,
                          style: const TextStyle(
                            color: AppTheme.textWhite,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          song.artist ?? 'Unknown Artist',
                          style: const TextStyle(
                            color: AppTheme.textGray,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder<bool>(
                  stream: _musicService.playingStream,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppTheme.neonRed,
                      ),
                      iconSize: 32,
                      onPressed: _musicService.togglePlayPause,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: AppTheme.neonRed),
                  iconSize: 28,
                  onPressed: _musicService.next,
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
