import 'package:flutter/material.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          return Container(
            width: width,
            height: height,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.5, -0.0),
                end: Alignment(0.5, 1.0),
                colors: [
                  Color.fromARGB(255, 249, 129, 43),
                  Color.fromARGB(201, 196, 151, 89),
                  Color.fromARGB(255, 99, 163, 223),
                  Color.fromARGB(255, 32, 132, 238),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(1.48, 0.0),
                        end: Alignment(0.0, 1.0),
                        colors: [
                          Color.fromARGB(255, 249, 129, 43),
                          Color.fromARGB(201, 196, 151, 89),
                          Color.fromARGB(255, 99, 163, 223),
                          Color.fromARGB(255, 17, 124, 238),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: width * 0.35,
                    height: width * 0.35,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
