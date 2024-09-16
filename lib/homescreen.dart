import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv_app/raw_data.dart';
import 'package:tv_app/video_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Webkul Tv App'),
        ),
        body: SingleChildScrollView(child: sampleVideoGrid()),
      ),
    );
  }

  Widget sampleVideoGrid() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            children: images
                .map((url) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => VideoPlayerScreen(
                              url: links[images.indexOf(url)],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          url,
                          height: 150,
                          width: 150,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
