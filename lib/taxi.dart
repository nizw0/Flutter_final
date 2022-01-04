import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/main.dart';
import 'package:final_project/widget/widget.dart';

void main() => runApp(const TaxiPage());

class TaxiPage extends StatelessWidget {
  const TaxiPage({Key? key}) : super(key: key);

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        body: Column(
          children: [
            TaxiStepper(),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaxiStepper extends StatefulWidget {
  const TaxiStepper({Key? key}) : super(key: key);

  @override
  State<TaxiStepper> createState() => _TaxiStepperState();
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stepper(
      controlsBuilder: (BuildContext context, {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
        return Row(
          children: [
            TextButton(
              onPressed: onStepContinue,
              child: const Text('NEXT'),
            ),
            TextButton(
              onPressed: onStepCancel,
              child: const Text('CANCEL'),
            ),
          ],
        );
      },
      steps: const <Step>[
        Step(
          title: Text('A'),
          content: SizedBox(
            width: 100.0,
            height: 100.0,
          ),
        ),
        Step(
          title: Text('B'),
          content: SizedBox(
            width: 100.0,
            height: 100.0,
          ),
        ),
      ],
    );
  }
}

class _TaxiStepperState extends State<TaxiStepper> {
  final int _length = 3;
  int _index = 0;
  TextEditingController date = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController comment = TextEditingController();

  List<Step> stepList() => [
        Step(
          state: _index <= 0 ? StepState.editing : StepState.complete,
          isActive: _index >= 0,
          title: const Text('地點'),
          content: Column(
            children: [
              TextField(
                controller: date,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Full Name',
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              DatePicker(),
            ],
          ),
        ),
        Step(
            state: _index <= 1 ? StepState.editing : StepState.complete,
            isActive: _index >= 1,
            title: const Text('時間'),
            content: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: date,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full House Address',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: date,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pin Code',
                  ),
                ),
              ],
            )),
        Step(
            state: _index <= 2 ? StepState.editing : StepState.complete,
            isActive: _index >= 2,
            title: const Text('備註'),
            content: Column(
              children: [
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: date,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full House Address',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: date,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Pin Code',
                  ),
                ),
              ],
            )),
        Step(
            state: StepState.complete,
            isActive: _index >= 3,
            title: const Text('Confirm'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Name: ${date.text}'),
                Text('Email: ${date.text}'),
                const Text('Password: *****'),
                Text('Address : ${date.text}'),
                Text('PinCode : ${date.text}'),
              ],
            ))
      ];

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index--;
          });
        }
      },
      onStepContinue: () {
        if (_index < _length) {
          setState(() {
            _index++;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      controlsBuilder: (context, {onStepContinue, onStepCancel}) {
        final isLastStep = _index == stepList().length - 1;
        return Container(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onStepContinue,
                  child: (isLastStep) ? const Text('Submit') : const Text('Next'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              if (_index > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onStepCancel,
                    child: const Text('Back'),
                  ),
                )
            ],
          ),
        );
      },
      steps: stepList(),
    );
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late DateTime? date = DateTime.now();

  getText() {
      return DateFormat('yyyy/MM/dd, EEEE').format(date!);
  }

  @override
  Widget build(BuildContext context) => ButtonHeaderWidget(
        title: 'Date',
        text: getText(),
        onClicked: () => pickDate(context),
      );

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: date ?? initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() => date = newDate);
  }
}
