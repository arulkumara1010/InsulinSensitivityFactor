import 'package:flutter/material.dart';

class CalculateInsulinPage extends StatefulWidget {
  @override
  _CalculateInsulinPageState createState() => _CalculateInsulinPageState();
}

class _CalculateInsulinPageState extends State<CalculateInsulinPage> {
  final _formKey = GlobalKey<FormState>();

  // Variables to store input values
  double carbs = 0;
  double insulinToCarbRatio = 0;
  double currentBloodSugar = 0;
  double targetBloodSugar = 0;
  double correctionFactor = 0;

  double totalInsulinDose = 0;
  String resultText = '';

  // Function to calculate insulin dosage
  void calculateInsulin() {
    // Carbohydrate coverage dose
    double carbCoverageDose = carbs / insulinToCarbRatio;

    // High blood sugar correction dose
    double correctionDose =
        (currentBloodSugar - targetBloodSugar) / correctionFactor;

    // Total insulin dose
    totalInsulinDose = carbCoverageDose + correctionDose;

    // Display result
    setState(() {
      resultText =
          'Total Insulin Dose: ${totalInsulinDose.toStringAsFixed(2)} units';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculate Insulin Dosage'),
        backgroundColor: Colors.pink.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Carbs input field
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Total Carbs in Meal (grams)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the carbs';
                  }
                  return null;
                },
                onSaved: (value) {
                  carbs = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),

              // Insulin-to-carb ratio input field
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Insulin to Carb Ratio (e.g. 1:10)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the insulin to carb ratio';
                  }
                  return null;
                },
                onSaved: (value) {
                  insulinToCarbRatio = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),

              // Current blood sugar input field
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Current Blood Sugar (mg/dL)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current blood sugar';
                  }
                  return null;
                },
                onSaved: (value) {
                  currentBloodSugar = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),

              // Target blood sugar input field
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Target Blood Sugar (mg/dL)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your target blood sugar';
                  }
                  return null;
                },
                onSaved: (value) {
                  targetBloodSugar = double.parse(value!);
                },
              ),
              SizedBox(height: 16.0),

              // Correction factor input field
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Correction Factor (mg/dL per unit of insulin)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your correction factor';
                  }
                  return null;
                },
                onSaved: (value) {
                  correctionFactor = double.parse(value!);
                },
              ),
              SizedBox(height: 20.0),

              // Calculate button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      calculateInsulin();
                    }
                  },
                  child: Text('Calculate'),
                  style: ElevatedButton.styleFrom(),
                ),
              ),

              // Result display
              SizedBox(height: 20.0),
              Text(
                resultText,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.pink,
      scaffoldBackgroundColor: Colors.pink.shade50,
    ),
    home: CalculateInsulinPage(),
  ));
}
