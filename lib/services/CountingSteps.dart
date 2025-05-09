import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class Countingsteps {
  static  List<String> countStepsFromData(List<AccelerometerEvent> data) {
    List<String> magnitudes = [];

    if (data.isEmpty) {
      print("No accelerometer data available.");
      return [];
    }

    double threahsold = 11.5;

    int end = data.length;
    double value_1 = sqrt(
        data[0].x * data[0].x + data[0].y * data[0].y + data[0].z * data[0].z);
    double value_2 = sqrt(
        data[1].x * data[1].x + data[1].y * data[1].y + data[1].z * data[1].z);
    double value_3 = sqrt(
        data[2].x * data[2].x + data[2].y * data[2].y + data[2].z * data[2].z);

    if (value_2 > value_1 && value_2 > value_3 && value_2 > threahsold) {
      print("Step detected at index 1 with magnitude $value_2");
        magnitudes.add("M: ${value_2.toString()} , time: ${data[1].timestamp}");
    }

  

    for (int i = 3; i < end; i++) {
      value_1 = value_2;
      value_2 = value_3;
      value_3 = sqrt(data[i].x * data[i].x +
          data[i].y * data[i].y +
          data[i].z * data[i].z);
      if (value_2 > value_1 && value_2 > value_3 &&
          value_2 > threahsold) {
        print("Step detected at index 1 with magnitude $value_2");
        magnitudes.add("M: ${value_2.toString()} , time: ${data[i].timestamp}");
      }

    }

    return magnitudes;
  }

}
