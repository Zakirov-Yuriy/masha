import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../video_player_screen.dart';

class CartoonListScreen extends StatelessWidget {
  final List<Map<String, String>> cartoons = [
    {
      'title': 'Маша и Медведь - Эпизод 1',
      'image': 'assets/masha.png',
      'videoUrl':
          'https://firebasestorage.googleapis.com/v0/b/masha-6b967.appspot.com/o/%D0%BC%D0%B0%D1%88%D0%B0-%D0%B8-%D0%BC%D0%B5%D0%B4%D0%B2%D0%B5%D0%B4%D1%8C-%D0%BF%D0%B5%D1%80%D0%B2%D0%B0%D1%8F-%D0%B2%D1%81%D1%82.mp4?alt=media&token=e3dd0885-7d5b-4406-83c9-14ac19c8c2be',
    },
    {
      'title': 'Маша и Медведь - Эпизод 2',
      'image': 'assets/masha.png',
      'videoUrl':
          'https://firebasestorage.googleapis.com/v0/b/masha-6b967.appspot.com/o/%D0%BC%D0%B0%D1%88%D0%B0-%D0%B8-%D0%BC%D0%B5%D0%B4%D0%B2%D0%B5%D0%B4%D1%8C-%D0%B4%D0%BE-%D0%B2%D0%B5%D1%81%D0%BD%D1%8B-%D0%BD_.mp4?alt=media&token=04a5f318-6a13-49f4-b829-03501592cc32',
    },
    {
      'title': 'Маша и Медведь - Эпизод 3',
      'image': 'assets/masha.png',
      'videoUrl':
          'https://firebasestorage.googleapis.com/v0/b/masha-6b967.appspot.com/o/%D0%BC%D0%B0%D1%88%D0%B0-%D0%B8-%D0%BC%D0%B5%D0%B4%D0%B2%D0%B5%D0%B4%D1%8C-%D0%B4%D0%BE-%D0%B2%D0%B5%D1%81%D0%BD%D1%8B-%D0%BD_.mp4?alt=media&token=04a5f318-6a13-49f4-b829-03501592cc32',
    },
    // Добавь другие эпизоды
    {
      'title': 'Маша и Медведь - Эпизод 4',
      'image': 'assets/masha.png',
      'videoUrl':
          'https://firebasestorage.googleapis.com/v0/b/masha-6b967.appspot.com/o/%D0%BC%D0%B0%D1%88%D0%B0-%D0%B8-%D0%BC%D0%B5%D0%B4%D0%B2%D0%B5%D0%B4%D1%8C-%D0%B4%D0%BE-%D0%B2%D0%B5%D1%81%D0%BD%D1%8B-%D0%BD_.mp4?alt=media&token=04a5f318-6a13-49f4-b829-03501592cc32',
    },
  ];

  CartoonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список мультфильмов'),
      ),
      body: ListView.builder(
        itemCount: cartoons.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.asset(cartoons[index]['image']!), // Превью видео
              title: Text(cartoons[index]['title']!), // Название
              onTap: () {
                // Переход на видеоплеер при нажатии
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoPlayerScreen(
                      cartoons: cartoons,
                      currentIndex: index,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
