import 'package:flutter/material.dart';
import '../../domain/services/statistics_service.dart';
import '../widgets/entrada_intervalos_form.dart';

class EstiHome extends StatefulWidget {
  @override
  _EstiHomeState createState() => _EstiHomeState();
}

class _EstiHomeState extends State<EstiHome> {
  final GlobalKey<entradaIntervalosFormState> _formKey = GlobalKey<entradaIntervalosFormState>();

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esti'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Insertar periodos') {
                _formKey.currentState?.limpiarEInsertarPeriodos();
              } else if (value == 'Calcular medidas de tendencia central') {
                _calculateMeasuresOfCentralTendency();
              }
            },
            itemBuilder: (contexto) => [
              PopupMenuItem(value: 'Insertar periodos', child: Text('Insertar periodos')),
              PopupMenuItem(value: 'Calcular medidas de tendencia central', child: Text('Calcular medidas de tendencia central')),
            ],
          ),
        ],
      ),
      body: entradaIntervalosForm(key: _formKey),
    );
  }

  void _calculateMeasuresOfCentralTendency() {
    final state = _formKey.currentState;
    if (state != null && state.intervalos.isNotEmpty) {
      final result = ServicioEstadistico.CalcularMedidasDeTendenciaCentral(state.intervalos);

      showDialog(
        context: context,
        builder: (contexto) {
          return AlertDialog(
            title: Text('Medidas de tendencia central'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Media Aritmética: ${result['mediaAritmetica']}'),
                Text('Media Armónica: ${result['mediaArmonica']}'),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(contexto), child: Text('OK')),
            ],
          );
        },
      );
    }
  }
}
