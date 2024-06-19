import 'package:arrow_navigator/camera_services.dart';
import 'package:arrow_navigator/direction.dart';
import 'package:arrow_navigator/extensions/dartz_x.dart';
import 'package:arrow_navigator/failure.dart';
import 'package:camera/camera.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class StreamService {
  void startStreaming(
      CameraController controller, Function(NavigationSteps) onStep) async {
    CameraServices().imageStream(controller).listen((imgBytes) async {
      final failureOrDirection = await _uploadImage(imgBytes);
      if (failureOrDirection.isRight()) {
        onStep(failureOrDirection.getOrCrash());
      }
      if (failureOrDirection.isLeft()) {
        onStep(
            NavigationSteps(direction: failureOrDirection.getLeft().message));
      }
    });
  }

  Future<Either<Failure, NavigationSteps>> _uploadImage(List<int> data) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.8.101:5000/upload'),
        headers: {"Content-Type": "application/octet-stream"},
        body: data,
      );
      if (response.statusCode != 200) {
        return Left(Failure('Failed to upload image'));
      }
      final direction = response.body;
      final navigationSteps = NavigationSteps.fromJson(direction);
      return Right(navigationSteps);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
