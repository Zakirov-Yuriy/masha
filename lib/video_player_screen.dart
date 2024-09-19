import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class VideoPlayerScreen extends StatefulWidget {
  final List<Map<String, String>> cartoons;
  final int currentIndex;

  const VideoPlayerScreen({
    Key? key,
    required this.cartoons,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isLooping = false;
  bool _isLocked = false; // Флаг для блокировки экрана
  int _currentIndex = 0;
  String _currentPassword = ''; // Текущий пароль для разблокировки
  bool _areControlsVisible = true; // Флаг для видимости контролов
  Timer? _hideControlsTimer; // Таймер для скрытия контролов

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    // Блокируем ориентацию в горизонтальное положение
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Инициализация контроллера видеоплеера
    _initializeVideo();
  }

  void _initializeVideo() {
    _controller = VideoPlayerController.network(
      widget.cartoons[_currentIndex]['videoUrl']!,
    )..initialize().then((_) {
        setState(() {}); // Обновляем состояние, когда видео будет готово
        _controller.play();
        _isPlaying = true;
        _controller.addListener(_videoEndListener);

        // Устанавливаем таймер для скрытия контролов
        _startHideControlsTimer();
      });
    _controller.setLooping(_isLooping);
  }

  // Метод для запуска таймера скрытия контролов
  void _startHideControlsTimer() {
    _hideControlsTimer
        ?.cancel(); // Отменяем предыдущий таймер, если он существует
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _areControlsVisible = false;
      });
    });
  }

  void _videoEndListener() {
    if (_controller.value.position >= _controller.value.duration) {
      _playNextVideo();
    }
  }

  void _playNextVideo() {
    if (_currentIndex < widget.cartoons.length - 1) {
      setState(() {
        _currentIndex++;
        _controller.removeListener(
            _videoEndListener); // Удаляем слушателя для предыдущего видео
        _controller.dispose(); // Освобождаем текущий контроллер
        _initializeVideo(); // Инициализируем следующий видеоролик
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoEndListener);
    _controller.dispose(); // Освобождаем ресурсы
    _hideControlsTimer?.cancel(); // Отменяем таймер

    super.dispose();
  }

  void _showUnlockDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String enteredPassword = '';
        return AlertDialog(
          title: const Text('Введите пароль'),
          content: TextField(
            obscureText: true,
            maxLength: 4,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              enteredPassword = value;
            },
            decoration: const InputDecoration(
              counterText: '', // Скрыть счетчик символов
              hintText: '4 цифры',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (enteredPassword == _currentPassword) {
                  setState(() {
                    _isLocked = false; // Разблокируем экран
                  });
                  Navigator.of(context).pop();
                } else {
                  // Показываем ошибку, если пароль неверный
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Неправильный пароль'),
                    ),
                  );
                }
              },
              child: const Text('ОК'),
            ),
          ],
        );
      },
    );
  }

  void _showSetPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String enteredPassword = '';
        return AlertDialog(
          title: const Text('Установите пароль'),
          content: TextField(
            obscureText: true,
            maxLength: 4,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              enteredPassword = value;
            },
            decoration: const InputDecoration(
              counterText: '', // Скрыть счетчик символов
              hintText: '4 цифры',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (enteredPassword.length == 4) {
                  setState(() {
                    _currentPassword = enteredPassword;
                    _isLocked = true; // Блокируем экран
                  });
                  Navigator.of(context).pop();
                } else {
                  // Показываем ошибку, если пароль неверный
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Пароль должен состоять из 4 цифр'),
                    ),
                  );
                }
              },
              child: const Text('Установить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _areControlsVisible = true; // Показываем контролы
              });
              _startHideControlsTimer(); // Запускаем таймер скрытия контролов
            },
            child: Center(
              child: _controller.value.isInitialized
                  ? SizedBox.expand(
                      // Растягиваем видео на весь экран
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: _controller.value.size.width,
                          height: _controller.value.size.height,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                    )
                  : const CircularProgressIndicator(), // Индикатор загрузки, пока видео не готово
            ),
          ),
          if (_isLocked)
            GestureDetector(
              onTap: _showUnlockDialog, // Показываем диалог ввода пароля
              child: Container(
                color: Colors.black.withOpacity(0.5), // Полупрозрачный слой
                alignment: Alignment.center,
                child: const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          if (!_isLocked && _areControlsVisible)
            Positioned(
              top: 20, // Положение кнопки "Назад"
              left: 20,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.pop(context); // Возврат на предыдущий экран
                },
              ),
            ),
          // Кнопка воспроизведения/паузы в центре экрана
          if (!_isLocked && _areControlsVisible)
            Center(
              child: IconButton(
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 50,
                ),
                onPressed: () {
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                      _isPlaying = false;
                    } else {
                      _controller.play();
                      _isPlaying = true;
                    }
                  });
                },
              ),
            ),
          if (!_isLocked && _areControlsVisible)
            _buildControls(), // Отображаем контроллеры
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                _isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isMuted = !_isMuted;
                  _controller.setVolume(_isMuted ? 0.0 : 1.0);
                });
              },
            ),
            IconButton(
              icon: Icon(
                _isLooping ? Icons.repeat_one : Icons.repeat,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isLooping = !_isLooping;
                  _controller.setLooping(_isLooping);
                });
              },
            ),
            IconButton(
              icon: Icon(
                _isLocked ? Icons.lock_open : Icons.lock,
                color: Colors.white,
              ),
              onPressed: () {
                _showSetPasswordDialog(); // Запрашиваем пароль перед блокировкой
              },
            ),
          ],
        ),
      ),
    );
  }
}
