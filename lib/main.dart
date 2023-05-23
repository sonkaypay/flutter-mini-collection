import 'package:flutter/material.dart';
import 'package:mini_collection_poc/data.dart';
import 'package:mini_collection_poc/mini_collection_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Dismissible(
          direction: DismissDirection.up,
          key: ValueKey(i),
          onDismissed: (_) {
            setState(() {
              i = (i + 1) % collections.length;
            });
          },
          child: MiniCollectionWidget(collections[i]),
        ),
      ),
    );
  }
}
