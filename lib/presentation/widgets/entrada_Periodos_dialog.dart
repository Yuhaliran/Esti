import 'package:flutter/material.dart';

class PeriodInputDialog extends StatefulWidget {
  @override
  _PeriodInputDialogState createState() => _PeriodInputDialogState();
}

class _PeriodInputDialogState extends State<PeriodInputDialog> {
  final TextEditingController limiteInferiorController = TextEditingController();
  final TextEditingController rangoController = TextEditingController();
  final TextEditingController numeroDeIntervalosController = TextEditingController();

  @override
  Widget build(BuildContext contexto) {
    return AlertDialog(
      title: Text('Insertar periodos'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(limiteInferiorController, 'Límite inferior absoluto'),
          _buildTextField(rangoController, 'Rango'),
          _buildTextField(numeroDeIntervalosController, 'Cantidad de intervalos'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final double limiteInferior = double.parse(limiteInferiorController.text);
            final double rango = double.parse(rangoController.text);
            final int numeroDeIntervalos = int.parse(numeroDeIntervalosController.text);

            Navigator.of(contexto).pop({
              'limiteInferior': limiteInferior,
              'rango': rango,
              'numeroDeIntervalos': numeroDeIntervalos,
            });
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
    );
  }
}
