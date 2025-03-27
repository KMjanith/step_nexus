import 'package:flutter/material.dart';

class SetStepGoal extends StatefulWidget {
  const SetStepGoal({super.key});

  @override
  _SetStepGoalState createState() => _SetStepGoalState();
}

class _SetStepGoalState extends State<SetStepGoal> {
  String _selectedGoalType = "Exact Steps"; // Default selection
  final TextEditingController _stepsController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Step Goal'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Image
          // Container(
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       image: AssetImage('assets/backgroud.png'), // Change to your image path
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),

          // Content with Scrolling
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal Type Selection
                  Text(
                    "Choose Goal Type",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedGoalType,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.lightGreen.shade100.withOpacity(0.8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    items: ["Exact Steps", "Distance-based", "Time-based"]
                        .map((goal) {
                      return DropdownMenuItem(
                        value: goal,
                        child: Text(goal),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGoalType = value!;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  // Dynamic Input Fields
                  if (_selectedGoalType == "Exact Steps") _buildStepInput(),
                  if (_selectedGoalType == "Distance-based")
                    _buildDistanceInput(),
                  if (_selectedGoalType == "Time-based") _buildTimeInput(),

                  SizedBox(height: 30),

                  // Save Button
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _saveGoal();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      child: Text("Set Goal"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget for Step Input
  Widget _buildStepInput() {
    return _buildInputField(
        "Enter Step Goal", _stepsController, "e.g., 5000 steps");
  }

  // Widget for Distance Input
  Widget _buildDistanceInput() {
    return _buildInputField(
        "Enter Distance (km)", _distanceController, "e.g., 3.0 km");
  }

  // Widget for Time Input
  Widget _buildTimeInput() {
    return _buildInputField(
        "Enter Duration (minutes)", _timeController, "e.g., 30 min");
  }

  // Generalized Input Field Widget
  Widget _buildInputField(
      String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.lightGreen.shade100.withOpacity(0.8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // Function to Handle Goal Saving
  void _saveGoal() {
    String goal;
    if (_selectedGoalType == "Exact Steps") {
      goal = "${_stepsController.text} steps";
    } else if (_selectedGoalType == "Distance-based") {
      goal = "${_distanceController.text} km";
    } else {
      goal = "${_timeController.text} minutes";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Goal Set: $goal"),
        backgroundColor: Colors.green,
      ),
    );
  }
}
