import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/rounded_button.dart';
import '../utils/utils.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  bool loading = false;
  final realTimeDatabase = FirebaseDatabase.instance.ref('Calculator');
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  double _addResult = 0.0;
  double _subResult = 0.0;
  double _mulResult = 0.0;
  double _divResult = 0.0;

  @override
  void initState() {
    super.initState();
  }

  void _calculateResults() {
    double value1 = double.parse(_controller1.text);
    double value2 = double.parse(_controller2.text);

    _addResult = AddFunction(value1, value2);
    _subResult = SubFunction(value1, value2);
    _mulResult = MulFunction(value1, value2);
    _divResult = DivFunction(value1, value2);

    realTimeDatabase.child('calculation').set({
      'Add Result': _addResult,
      'Sub Result': _subResult,
      'Mul Result': _mulResult,
      'Div Result': _divResult,
    }).then((value) {
      Utils().toastMessage("Added data to Realtime Database");
      setState(() {
        loading = false;
      });
    }).catchError((error) {
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  double AddFunction(double value1, double value2) {
    return value1 + value2;
  }

  double SubFunction(double value1, double value2) {
    return value1 - value2;
  }

  double MulFunction(double value1, double value2) {
    return value1 * value2;
  }

  double DivFunction(double value1, double value2) {
    return value1 / value2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _controller1,
              decoration: const InputDecoration(
                hintText: 'Enter Value 1',
              ),
            ),
            TextFormField(
              controller: _controller2,
              decoration: const InputDecoration(
                hintText: 'Enter Value 2',
              ),
            ),
            const SizedBox(height: 20),
            RoundButton(
              title: 'Calculate',
              onTap: () {
                _calculateResults();
              },
              loading: loading,
            ),
            const SizedBox(height: 20),
            Expanded(
                child: FirebaseAnimatedList(
              query: realTimeDatabase,
              defaultChild: const Center(child: CircularProgressIndicator()),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const Text('Add  = ', style: TextStyle(fontSize: 30)),
                        Text(snapshot.child('Add Result').value.toString(),
                            style: const TextStyle(fontSize: 30)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Sub = ', style: TextStyle(fontSize: 30)),
                        Text(snapshot.child('Sub Result').value.toString(),
                            style: const TextStyle(fontSize: 30)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Mul = ', style: TextStyle(fontSize: 30)),
                        Text(snapshot.child('Mul Result').value.toString(),
                            style: const TextStyle(fontSize: 30)),
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Div = ', style: TextStyle(fontSize: 30)),
                        Text(snapshot.child('Div Result').value.toString(),
                            style: const TextStyle(fontSize: 30)),
                      ],
                    ),
                  ],
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
