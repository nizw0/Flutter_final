import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:final_project/main.dart';

void main() => runApp(const TaxiPage());

class TaxiPage extends StatelessWidget {
  const TaxiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        title: '叫車',
        iconButton: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: const TaxiStepper(),
      bottomNavigationBar: const BottomNavigator(),
      floatingActionButton: null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}

class TaxiStepper extends StatefulWidget {
  const TaxiStepper({Key? key}) : super(key: key);

  @override
  State<TaxiStepper> createState() => _TaxiStepperState();
}

class _TaxiStepperState extends State<TaxiStepper> {
  var _index = 0;
  final _date = GlobalKey<_DatePickerState>();
  final _location = GlobalKey<_MenuButtonState>();
  final _address = TextEditingController();
  final _comment = TextEditingController();

  static const _titleStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static const _contentStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static const _submitStyle = TextStyle(fontSize: 16);

  List<Step> stepList() => [
        Step(
          state: _index <= 0 ? StepState.indexed : StepState.complete,
          isActive: _index >= 0,
          title: const Text('日期', style: _titleStyle),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                child: DatePicker(key: _date),
                width: 300,
              ),
            ],
          ),
        ),
        Step(
            state: _index <= 1 ? StepState.indexed : StepState.complete,
            isActive: _index >= 1,
            title: const Text('出發地點', style: _titleStyle),
            content: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: _contentStyle,
                    controller: _address,
                    decoration: InputDecoration(
                      counterStyle: _contentStyle,
                      suffixIcon: _address.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _address.clear,
                              icon: const Icon(Icons.clear),
                            ),
                    ),
                  ),
                ),
              ],
            )),
        Step(
            state: _index <= 2 ? StepState.indexed : StepState.complete,
            isActive: _index >= 2,
            title: const Text('到達地點', style: _titleStyle),
            content: Column(
              children: [
                MenuButton(key: _location),
              ],
            )),
        Step(
            state: _index <= 3 ? StepState.indexed : StepState.complete,
            isActive: _index >= 3,
            title: const Text('備註', style: _titleStyle),
            content: Column(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    style: _contentStyle,
                    controller: _comment,
                    decoration: InputDecoration(
                      counterStyle: _contentStyle,
                      suffixIcon: _comment.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _comment.clear,
                              icon: const Icon(Icons.clear),
                            ),
                    ),
                  ),
                ),
              ],
            )),
        Step(
            state: StepState.complete,
            isActive: _index >= 4,
            title: const Text('確認以上項目', style: _titleStyle),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('日期︰${_date.currentState?.getText()}', style: _contentStyle),
                Text('出發地點︰${_address.text}', style: _contentStyle),
                Text('到達地點︰${_location.currentState?.value}', style: _contentStyle),
                _comment.text.isEmpty ? Container() : Text('備註︰${_comment.text}', style: _contentStyle),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ))
      ];

  @override
  void initState() {
    super.initState();
    _comment.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

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
        if (_index < 4) {
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
              width: MediaQuery.of(context).size.width,
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
                onPressed: isLastStep
                    ? () async {
                        FirebaseFirestore.instance.collection('order').doc().set({
                          'uid': FirebaseAuth.instance.currentUser?.uid,
                          'datetime': _date.currentState?.dateTime.toString().trim(),
                          'address': _address.text.trim(),
                          'location': _location.currentState?.value.toString().trim(),
                          'comment': _comment.text.trim()
                        });
                        Navigator.pop(context);
                      }
                    : controls.onStepContinue,
                child: Padding(
                    padding: const EdgeInsets.all(8.0), child: Text(isLastStep ? '送出' : '下一步', style: _submitStyle)),
              ),
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
  late DateTime dateTime = DateTime.now();
  final _themeData = ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(primary: Color.fromARGB(255, 66, 66, 66)),
      buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary));
  final _style = const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);

  String getText() => DateFormat('yyyy/MM/dd HH:mm').format(dateTime);

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<DateTime?> pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: _themeData,
          child: child!,
        );
      },
    );

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    final newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: _themeData,
          child: child!,
        );
      },
    );

    if (newTime == null) return null;
    return newTime;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(40),
        primary: Colors.white,
      ),
      child: FittedBox(
        child: Text(
          getText(),
          style: _style,
        ),
      ),
      onPressed: () => pickDateTime(context),
    );
  }
}

class MenuButton extends StatefulWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  String value = 'A醫院';
  final _style = const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 10,
      borderRadius: BorderRadius.zero,
      style: _style,
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? newValue) {
        setState(() {
          value = newValue!;
        });
      },
      items: <String>['A醫院', 'B醫院', 'C醫院', 'D醫院', 'E醫院', 'F醫院', 'G醫院'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
