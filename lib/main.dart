import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Esti',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EstiHome(),
    );
  }
}

class EstiHome extends StatefulWidget {
  @override
  _EstiHomeState createState() => _EstiHomeState();
}

class _EstiHomeState extends State<EstiHome> {
  final GlobalKey<_IntervalInputFormState> _formKey = GlobalKey<_IntervalInputFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esti'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Insertar periodos') {
                final state = _formKey.currentState;
                if (state != null) {
                  state.cleanAndInsertPeriods();
                }
              } else if (value == 'Calcular medidas de tendencia central') {
                _calculateMeasuresOfCentralTendency(context);
              } else if (value == 'Calcular medidas de dispersion') {
                // Handle dispersion measures calculation
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'Insertar periodos',
                child: Text('Insertar periodos'),
              ),
              PopupMenuItem(
                value: 'Calcular medidas de tendencia central',
                child: Text('Calcular medidas de tendencia central'),
              ),
              PopupMenuItem(
                value: 'Calcular medidas de dispersion',
                child: Text('Calcular medidas de dispersion'),
              ),
            ],
          ),
        ],
      ),
      body: IntervalInputForm(key: _formKey),
    );
  }

  void _calculateMeasuresOfCentralTendency(BuildContext context) {
    final state = _formKey.currentState;

    if (state != null && state.intervals.isNotEmpty) {
      double totalFrequency = 0;
      double sumOfProducts = 0;
      double harmonicSum = 0;

      for (var interval in state.intervals) {
        double midpoint = (interval['lowerLimit'] + interval['upperLimit']) / 2;
        int frequency = int.tryParse(interval['frequency'].text) ?? 0;

        totalFrequency += frequency;
        sumOfProducts += midpoint * frequency;
        if (midpoint != 0) {
          harmonicSum += frequency / midpoint;
        }
      }

      double arithmeticMean = sumOfProducts / totalFrequency;
      double harmonicMean = totalFrequency / harmonicSum;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Medidas de tendencia central'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Media Aritmética: $arithmeticMean'),
                Text('Media Armónica: $harmonicMean'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class PeriodInputDialog extends StatefulWidget {
  @override
  _PeriodInputDialogState createState() => _PeriodInputDialogState();
}

class _PeriodInputDialogState extends State<PeriodInputDialog> {
  final TextEditingController lowerLimitController = TextEditingController();
  final TextEditingController rangeController = TextEditingController();
  final TextEditingController numberOfIntervalsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Insertar periodos'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: lowerLimitController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Límite inferior absoluto'),
          ),
          TextField(
            controller: rangeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Rango'),
          ),
          TextField(
            controller: numberOfIntervalsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Cantidad de intervalos'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final double lowerLimit = double.parse(lowerLimitController.text);
            final double range = double.parse(rangeController.text);
            final int numberOfIntervals = int.parse(numberOfIntervalsController.text);

            Navigator.of(context).pop({
              'lowerLimit': lowerLimit,
              'range': range,
              'numberOfIntervals': numberOfIntervals,
            });
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}

class IntervalInputForm extends StatefulWidget {
  const IntervalInputForm({Key? key}) : super(key: key);

  @override
  _IntervalInputFormState createState() => _IntervalInputFormState();
}

class _IntervalInputFormState extends State<IntervalInputForm> {
  List<Map<String, dynamic>> intervals = [];

  @override
  void initState() {
    super.initState();    
    _addRow();
  }

  void _addRow() {
    setState(() {
      intervals.add({
        'lowerLimit': TextEditingController(),
        'upperLimit': TextEditingController(),
        'frequency': TextEditingController(),
      });
    });
  }

  void _cleanIntervals() {
    setState(() {
      intervals.clear();
      _addRow();
    });
  }

  void cleanAndInsertPeriods() {
    _cleanIntervals();
    Future.delayed(Duration.zero, () async {
      final result = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => PeriodInputDialog(),
      );
      if (result != null) {
        _generateIntervals(
          result['lowerLimit'],
          result['range'],
          result['numberOfIntervals'],
        );
      }
    });
  }

  void _generateIntervals(double lowerLimit, double range, int numberOfIntervals) {
    setState(() {
      intervals.clear();
      double currentLowerLimit = lowerLimit;

      for (int i = 0; i < numberOfIntervals; i++) {
        double upperLimit = currentLowerLimit + range;
        intervals.add({
          'lowerLimit': TextEditingController(text: currentLowerLimit.toString()),
          'upperLimit': TextEditingController(text: upperLimit.toString()),
          'frequency': TextEditingController(),
        });
        currentLowerLimit = upperLimit + 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: intervals.length,
              itemBuilder: (context, index) {
                final interval = intervals[index];
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: interval['lowerLimit'],
                        decoration: InputDecoration(labelText: 'Límite Inferior'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: interval['upperLimit'],
                        decoration: InputDecoration(labelText: 'Límite Superior'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: interval['frequency'],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: 'Frecuencia'),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _addRow,
            child: Text('Insertar Fila'),
          ),
          ElevatedButton(
            onPressed: _cleanIntervals,
            child: Text('Limpiar'),
          ),
        ],
      ),
    );
  }
}
