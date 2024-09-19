import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cartoon_list_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Устанавливаем ориентацию в горизонтальное положение
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // Список с путями к изображениям
    final List<String> images = [
      'assets/masha_and_bear.png',
      'assets/masha.png',
      'assets/masha.png',
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Фоновое изображение
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/landscape.avif'), // Путь к фоновому изображению
                fit: BoxFit.fill, // Заполняет весь экран
              ),
            ),
          ),
          // Контент (4 окна)

          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.count(
                shrinkWrap:
                    true, // Делаем GridView подстраивающимся под контент
                crossAxisCount: 3, // 2 элемента в ряду
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: List.generate(3, (index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartoonListScreen(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(30),
                        // border: Border.all(
                        //   color: const Color.fromARGB(255, 255, 255, 255),
                        //   width: 3,
                        // ), // Закругляем углы
                        image: DecorationImage(
                          image: AssetImage(images[
                              index]), // Разные изображения для каждого окна
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
