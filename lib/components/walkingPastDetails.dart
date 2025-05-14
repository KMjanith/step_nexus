import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Walkingpastdetails extends StatelessWidget {
  Map<String, dynamic> pastData;
  Walkingpastdetails({required this.pastData, super.key});

  @override
  Widget build(BuildContext context) {
    print(pastData);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(109, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 1, 113, 141),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        pastData['date'].toString().split("-")[0],
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 35,
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Text(
                        "${pastData['date'].toString().split("-")[1]}-${pastData['date'].toString().split("-")[2]}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              _detailTab(
                  Icon(Icons.directions_walk,
                      color: const Color.fromARGB(255, 1, 141, 94)),
                  "${pastData['result_steps']}"),
              _detailTab(
                  Icon(Icons.timelapse,
                      color: const Color.fromARGB(255, 206, 65, 0)),
                  "${pastData['time_spend']}"),
              _detailTab(
                  Icon(Icons.route,
                      color: const Color.fromARGB(255, 0, 13, 22)),
                  "${pastData['result_distance']} km"),
              _detailTab(
                  Icon(Icons.speed,
                      color: const Color.fromARGB(255, 201, 164, 0)),
                  "${pastData['result_avg_speed']} km/h"),
            ],
          )),
    );
  }
}

Widget _detailTab(Icon icon, String text) {
  return Column(
    children: [
      icon,
      SizedBox(
        height: 5,
      ),
      Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      )
    ],
  );
}
