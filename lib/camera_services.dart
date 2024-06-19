import 'dart:async';
import 'dart:typed_data';

import 'package:arrow_navigator/failure.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

class CameraServices {
  Future<Either<Failure, CameraController>> initCamera() async {
    try {
      final cameras = await availableCameras();
      final cameraController = CameraController(
          cameras[0], ResolutionPreset.medium,
          imageFormatGroup: ImageFormatGroup.yuv420);
      await cameraController.initialize();
      return Right(cameraController);
    } catch (e) {
      return Left(Failure('Failed to initialize camera'));
    }
  }

  Stream<Uint8List> imageStream(CameraController controller) async* {
    final StreamController<Uint8List> streamController = StreamController();
    _getImages(controller, (imgBytes) {
      streamController.add(imgBytes);
    });
    yield* streamController.stream;
  }

  void _getImages(
      CameraController controller, Function(Uint8List) onFrame) async {
    while (true) {
      final img = await controller.takePicture();
      final imgBytes = await img.readAsBytes();
      onFrame(imgBytes);
    }
  }
}
