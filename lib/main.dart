import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Forms',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Forms'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String changed = '';
  String submitted = '';
  late int? itemSelected = 0;
  bool isSwitched = false;
  double sliderValue = 0.0;
  String date = DateTime.now().toString();
  String hour = TimeOfDay.now().toString();

  List<Widget> radioList() {
    List<Widget> list = [];

    for (int x = 0; x < 4; x++) {
      Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Choix du numéro ${x + 1}'),
        Radio(
            value: x,
            groupValue: itemSelected,
            onChanged: (i) {
              setState(() {
                itemSelected = i;
              });
            })
      ]);
      list.add(row);
    }
    return list;
  }

  Map check = {
    'Carottes': false,
    'Bananes': false,
    'Yaourt': false,
    'Pain': false
  };

  List<Widget> checkList() {
    List<Widget> list = [];
    check.forEach((key, value) {
      Row row = Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(key),
        Checkbox(
            value: value,
            onChanged: (bool? b) {
              setState(() {
                check[key] = b;
              });
            })
      ]);
      list.add(row);
    });
    return list;
  }

  Future openDate() async {
    DateTime? selectedDate = await showDatePicker(
        context: context,
        // initialDatePickerMode: DatePickerMode.year,
        initialDate: DateTime.now(),
        firstDate: DateTime(1983),
        lastDate: DateTime(2045));
    if (selectedDate != null) {
      setState(() {
        date = selectedDate.toString();
      });
    }
  }

  Future openHour() async {
    TimeOfDay? selectedHour =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedHour != null) {
      setState(() {
        hour = selectedHour.toString();
      });
    }
  }

  // GestureDetector et FocusScope pour pallier soucis
  // d'input number sur iOS sans onSubmitted

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: () {
        //   FocusScope.of(context).requestFocus(FocusNode());
        // },
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(onPressed: openDate, child: const Text('Date')),
            ElevatedButton(onPressed: openHour, child: const Text('Heure')),
          ]),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (String value) {
                    changed = value;
                  },
                  onSubmitted: (String value) {
                    submitted = value;
                  },
                  decoration:
                      const InputDecoration(labelText: "Entrer votre nom"))),
          Text(changed),
          Text(submitted),
          Column(children: checkList()),
          Column(children: radioList()),
          Column(
            children: [
              const Text('Newsletter ?'),
              Switch(
                  value: isSwitched,
                  inactiveTrackColor: Colors.red,
                  activeColor: Colors.green,
                  onChanged: (bool b) {
                    setState(() {
                      isSwitched = b;
                    });
                  })
            ],
          ),
          Column(
            children: [
              Text('$sliderValue'),
              Slider(
                  value: sliderValue,
                  min: 0.0,
                  max: 10.0,
                  inactiveColor: Colors.pinkAccent,
                  activeColor: Colors.greenAccent,
                  divisions: 5,
                  onChanged: (double d) {
                    setState(() {
                      sliderValue = d;
                    });
                  })
            ],
          )
        ],
      )),
    ));
  }
}
