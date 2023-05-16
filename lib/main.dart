import 'dart:math';
import 'dart:developer' as devetools show log;
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var color1 = Colors.yellow;
  var color2 = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Home Page'),
        ),
      ),
      body: AvailableColorWiget(
        color1: color1,
        color2: color2,
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      color1 = colors.getRandomColors();
                    });
                  },
                  child: const Text("Change color1"),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      color2 = colors.getRandomColors();
                    });
                  },
                  child: const Text("Change color2"),
                )
              ],
            ),
            const ColorWidget(
              color: AvailableColors.one,
            ), 
            const ColorWidget(
              color: AvailableColors.two,
            )
          ],
        ),
      ),
    );
  }
}

enum AvailableColors { one, two }

class AvailableColorWiget extends InheritedModel<AvailableColors> {
  final MaterialColor color1;
  final MaterialColor color2;

  const AvailableColorWiget({
    Key? key,
    required this.color1,
    required this.color2,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static AvailableColorWiget of(
    BuildContext context,
    AvailableColors aspect,
  ) {
    return InheritedModel.inheritFrom<AvailableColorWiget>(
      context,
      aspect: aspect,
    )!;
  }

  @override
  bool updateShouldNotify(covariant AvailableColorWiget oldWidget) {
    devetools.log("updateShouldNotify");
    return color1 != oldWidget.color1 || color2 != oldWidget.color2;
  }

  @override
  bool updateShouldNotifyDependent(covariant AvailableColorWiget oldWidget,
      Set<AvailableColors> dependencies) {
    devetools.log("updateShouldNotifyDependent");
    if (dependencies.contains(AvailableColors.one) &&
        color1 != oldWidget.color1) {
      return true;
    }
    if (dependencies.contains(AvailableColors.two) &&
        color2 != oldWidget.color2) {
      return true;
    }
    return false;
  }
}

final colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.cyan,
  Colors.amber,
  Colors.lime,
  Colors.indigo,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
];

extension RandomElement<T> on Iterable<T> {
  T getRandomColors() => elementAt(
        Random().nextInt(length),
      );
}

class ColorWidget extends StatelessWidget {
  final AvailableColors color;

  const ColorWidget({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (color) {
      case AvailableColors.one:
        devetools.log("Color1 has been rebuilt");
        break;
      case AvailableColors.two:
        devetools.log("Color2 has been rebuilt");
        break;
    }

    final provider = AvailableColorWiget.of(
      context,
      color,
    );
    return Container(
      height: 100,
      color: color == AvailableColors.one ? provider.color1 : provider.color2,
    );
  }
}
