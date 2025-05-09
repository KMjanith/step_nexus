import 'package:flutter/material.dart';
import 'package:walking_nexus/pages/CyclingDashboard.dart';
import 'package:walking_nexus/pages/Homepage.dart';
import 'package:walking_nexus/pages/TravellingDashboard.dart';
import 'package:walking_nexus/pages/WalkingRunningDashboard.dart';

// Model for target data
class Target {
  final String type; // "time", "distance", or "steps"
  final double value; // Value in hours (time), kilometers (distance), or steps

  Target({required this.type, required this.value});
}

class TargetSelectionScreen extends StatefulWidget {
  final Activity activity;

  const TargetSelectionScreen({required this.activity, super.key});

  @override
  _TargetSelectionScreenState createState() => _TargetSelectionScreenState();
}

class _TargetSelectionScreenState extends State<TargetSelectionScreen> {
  String? _selectedTargetType; // "time", "distance", or "steps"
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _stepsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedTargetType = 'time';
  }

  @override
  void dispose() {
    _timeController.dispose();
    _distanceController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  void _confirmTarget() {
    if (_formKey.currentState!.validate()) {
      double value;
      String type = _selectedTargetType!;

      switch (type) {
        case 'time':
          value = double.parse(_timeController.text); // Hours
          break;
        case 'distance':
          value = double.parse(_distanceController.text); // Kilometers
          break;
        case 'steps':
          value = double.parse(_stepsController.text); // Steps
          break;
        default:
          return;
      }

      Target target = Target(type: type, value: value);

      // Navigate to the appropriate dashboard based on activity
      switch (widget.activity) {
        case Activity.walking:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WalkingRunningDashboard(target: target),
            ),
          );
          break;
        case Activity.cycling:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CyclingDashboard(target: target),
            ),
          );
          break;
        case Activity.travelling:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => TravellingDashboard(target: target),
            ),
          );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWalking = widget.activity == Activity.walking;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.activity.toString().split('.').last.toUpperCase()} Target'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Target Type',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                RadioListTile<String>(
                  title: const Text('Target Time Duration (hours)'),
                  value: 'time',
                  groupValue: _selectedTargetType,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      _selectedTargetType = value;
                    });
                  },
                ),
                if (_selectedTargetType == 'time') ...[
                  TextFormField(
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Time (hours)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a time';
                      }
                      double? parsed = double.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        return 'Please enter a valid positive number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
                RadioListTile<String>(
                  title: const Text('Target Distance (km)'),
                  value: 'distance',
                  groupValue: _selectedTargetType,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      _selectedTargetType = value;
                    });
                  },
                ),
                if (_selectedTargetType == 'distance') ...[
                  TextFormField(
                    controller: _distanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Distance (km)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a distance';
                      }
                      double? parsed = double.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        return 'Please enter a valid positive number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],
                if (isWalking) ...[
                  RadioListTile<String>(
                    title: const Text('Target Number of Steps'),
                    value: 'steps',
                    groupValue: _selectedTargetType,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _selectedTargetType = value;
                      });
                    },
                  ),
                  if (_selectedTargetType == 'steps') ...[
                    TextFormField(
                      controller: _stepsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Steps',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a step count';
                        }
                        double? parsed = double.tryParse(value);
                        if (parsed == null || parsed <= 0) {
                          return 'Please enter a valid positive number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _confirmTarget,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      //border raious
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      //width 100%
                      minimumSize: Size(double.infinity, 50),
                    ),
                    child: const Text('Confirm Target'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
