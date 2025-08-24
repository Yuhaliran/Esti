import 'package:flutter/material.dart';
import 'entrada_Periodos_dialog.dart';

class entradaIntervalosForm extends StatefulWidget {
  const entradaIntervalosForm({Key? key}) : super(key: key);

  @override
  entradaIntervalosFormState createState() => entradaIntervalosFormState();
}

class entradaIntervalosFormState extends State<entradaIntervalosForm> {
  List<Map<String, dynamic>> intervalos = [];

  @override
  void initState() {
    super.initState();
    _aniadirFila();
  }

  void _aniadirFila() {
    setState(() {
      intervalos.add({
        'limiteInferior': TextEditingController(),
        'limiteSuperior': TextEditingController(),
        'frecuencia': TextEditingController(),
      });
    });
  }

  void _limpiarIntervalos() {
    setState(() {
      intervalos.clear();
      _aniadirFila();
    });
  }

  void limpiarEInsertarPeriodos() {
    _limpiarIntervalos();
    Future.delayed(Duration.zero, () async {
      final resultado = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) => PeriodInputDialog(),
      );
      if (resultado != null) {
        _generarIntervalos(
          resultado['limiteInferior'],
          resultado['rango'],
          resultado['numeroDeIntervalos'],
        );
      }
    });
  }

  void _generarIntervalos(double limiteInferior, double range, int numeroIntervalos) {
    setState(() {
      intervalos.clear();
      double limiteInferiorActual = limiteInferior;

      for (int i = 0; i < numeroIntervalos; i++) {
        double limiteSuperior = limiteInferiorActual + range;
        intervalos.add({
          'limiteInferior': TextEditingController(text: limiteInferiorActual.toString()),
          'limiteSuperior': TextEditingController(text: limiteSuperior.toString()),
          'frecuencia': TextEditingController(),
        });
        limiteInferiorActual = limiteSuperior + 1;
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
              itemCount: intervalos.length,
              itemBuilder: (context, index) {
                final interval = intervalos[index];
                return Row(
                  children: [
                    _buildInput(interval['limiteInferior'], 'Límite Inferior'),
                    SizedBox(width: 10),
                    _buildInput(interval['limiteSuperior'], 'Límite Superior'),
                    SizedBox(width: 10),
                    _buildInput(interval['frecuencia'], 'Frecuencia', esNumero: true),
                  ],
                );
              },
            ),
          ),
          ElevatedButton(onPressed: _aniadirFila, child: Text('Insertar Fila')),
          ElevatedButton(onPressed: _limpiarIntervalos, child: Text('Limpiar')),
        ],
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String label, {bool esNumero = false}) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: esNumero ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
