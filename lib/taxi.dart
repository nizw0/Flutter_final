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

class _TaxiStepperState extends State<TaxiStepper> {
  final int _length = 3;
  int _index = 0;
  late final DateTime date;
  TextEditingController time = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController comment = TextEditingController();

  List<Step> stepList() => [
        Step(
          state: _index <= 0 ? StepState.editing : StepState.complete,
          isActive: _index >= 0,
          title: const Text('日期'),
          content: Column(
            children: [
              DatePicker(),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
        Step(
            state: _index <= 1 ? StepState.editing : StepState.complete,
            isActive: _index >= 1,
            title: const Text('地點'),
            content: Column(
              children: [
                TextField(
                  controller: location,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            )),
        Step(
            state: _index <= 2 ? StepState.editing : StepState.complete,
            isActive: _index >= 2,
            title: const Text('備註'),
            content: Column(
              children: [
                TextField(
                  controller: comment,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            )),
        Step(
            state: StepState.complete,
            isActive: _index >= 3,
            title: const Text('確認以上項目'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  Text(comment.text.isEmpty ? '' : '備註: ${comment.text}'),
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
      controlsBuilder: (context, ControlsDetails controls) {
        final isLastStep = _index == stepList().length - 1;
        return Column(
          children: [
            // Expanded(
            //   child: ElevatedButton(
            //     onPressed: onStepContinue,
            //     child: (isLastStep) ? const Text('送出申請') : const Text('下一步'),
            //   ),
            // ),
            SizedBox(
              width: 280,
              child: ElevatedButton(
                onPressed: controls.onStepContinue,
                child: (isLastStep) ? const Text('送出申請') : const Text('下一步'),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            // if (_index > 0)
            //   Expanded(
            //     child: ElevatedButton(
            //       onPressed: controls.onStepCancel,
            //       child: const Text('返回'),
            //     ),
            //   )
          ],
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
