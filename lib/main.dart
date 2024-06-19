import 'package:arrow_navigator/camera_services.dart';
import 'package:arrow_navigator/extensions/dartz_x.dart';
import 'package:arrow_navigator/stream_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Stream App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LiveStreamPage(),
    );
  }
}

class LiveStreamPage extends StatelessWidget {
  const LiveStreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Path Finder')),
      body: FutureBuilder(
          future: CameraServices().initCamera(),
          builder: (context, snapshot) {
            final failureOrController = snapshot.data;
            if (failureOrController == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (failureOrController.isLeft()) {
              return Center(
                child: Text(
                  failureOrController.getLeft().message,
                ),
              );
            }
            final controller = failureOrController.getOrCrash();
            return CameraView(controller: controller);
          }),
    );
  }
}

class ManualCamView extends StatelessWidget {
  final CameraController controller;

  const ManualCamView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: CameraServices().imageStream(controller),
        builder: (context, snapshot) {
          final bytes = snapshot.data;
          if (bytes == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Image.memory(bytes);
        });
  }
}

class CameraView extends StatefulWidget {
  final CameraController controller;

  const CameraView({super.key, required this.controller});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static const style =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green);
  Widget direction = const Text('Connecting...',
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red));
  @override
  void initState() {
    super.initState();
    StreamService().startStreaming(widget.controller, (step) {
      setState(() {
        direction = Text(step.message(), style: style);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CameraPreview(widget.controller),
        const SizedBox(height: 20),
        Expanded(child: Center(child: direction)),
      ],
    );
  }
}
