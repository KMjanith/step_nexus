import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Cyclingorwalkingpastdetails extends StatelessWidget {
  Map<String, dynamic> pastData;
  Function? onDelete;
  Cyclingorwalkingpastdetails(
      {required this.pastData, required this.onDelete, super.key});

  Duration _parseDuration(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  Widget build(BuildContext context) {
    print(pastData['target_time']);
    print(pastData['time_spend']);
    // bool targetAchived = (pastData['distance_based'] == 1 &&
    //         (pastData['target_distance'] >= pastData['result_distance'])) ||
    //     (pastData['time_based'] == 1 &&
    //         (pastData['target_time'] >=
    //             _parseDuration(pastData['time_spend']).inHours));

    Duration duration = _parseDuration(pastData['time_spend']);
    double timeSpentInHours = duration.inSeconds / 3600.0;

    bool targetAchived = (pastData['distance_based'] == 1 &&
            (pastData['result_distance'] >= pastData['target_distance'])) ||
        (pastData['time_based'] == 1 &&
            (timeSpentInHours >= pastData['target_time']));

    String TARGET_ACHIEVED = pastData['distance_based'] == 1
        ? "Distance target ${pastData['target_distance']} km achieved!"
        : "Time target ${pastData['target_time']} hrs achieved!";

    String TARGET_NOT_ACHIEVED = pastData['distance_based'] == 1
        ? "Distance target ${pastData['target_distance']} km not achieved!"
        : "Time target ${pastData['target_time']} hrs not achieved!";
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 214, 214, 214),
          width: 2,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color.fromARGB(255, 0, 216, 180).withOpacity(0.2),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: const Offset(4, 4),
        //   ),
        // ],
        // color: targetAchived
        //     ? const Color.fromARGB(255, 255, 210, 210)
        //     : const Color.fromARGB(255, 228, 255, 209),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _topicFilling(targetAchived),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                    child: Text(
                        targetAchived ? TARGET_ACHIEVED : TARGET_NOT_ACHIEVED,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: targetAchived
                                ? const Color.fromARGB(255, 80, 185, 84)
                                : const Color.fromARGB(255, 255, 126, 126))),
                  ),
                  _topicFilling(targetAchived)
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Row(
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
                      Icon(Icons.timelapse,
                          color: const Color.fromARGB(255, 206, 65, 0)),
                      "${pastData['time_spend']}",
                      "hr:min:sec"),
                  _detailTab(
                      Icon(Icons.route,
                          color: const Color.fromARGB(255, 0, 13, 22)),
                      pastData['result_distance'] < 1
                          ? "${(pastData['result_distance'] * 1000).toStringAsFixed(1)} m"
                          : "${pastData['result_distance']}",
                      pastData['result_distance'] < 1 ? "m" : "km"),
                  _detailTab(
                      Icon(Icons.speed,
                          color: const Color.fromARGB(255, 146, 119, 0)),
                      "${pastData['result_avg_speed']}",
                      "km/h"),
                  IconButton(
                      color: const Color.fromARGB(255, 32, 41, 39),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: const Text(
                                  "Are you sure you want to delete this session?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Dismiss the dialog
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    onDelete!(pastData['id']);
                                  },
                                  child: const Text("Delete"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete,
                          color: const Color.fromARGB(255, 201, 0, 0))),
                ],
              ),
            ],
          )),
    );
  }
}

Widget _detailTab(Icon icon, String value, String unit) {
  return Column(
    children: [
      icon,
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      const SizedBox(height: 5),
      Text(
        unit,
        style: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
      ),
    ],
  );
}

Widget _topicFilling(bool targetAchived) {
  return Expanded(
    child: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: 3,
          decoration: BoxDecoration(
            color: targetAchived
                ? const Color.fromARGB(255, 175, 255, 178)
                : const Color.fromARGB(255, 255, 174, 174),
          ),
        );
      },
    ),
  );
}
