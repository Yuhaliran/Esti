class ServicioEstadistico {
  static Map<String, double> CalcularMedidasDeTendenciaCentral(List<Map<String, dynamic>> intervalos) {
    double frecuenciaTotal = 0;
    double sumaDeProductos = 0;
    double paraSumaArmonica = 0;

    for (var inter in intervalos) {
      double puntoMedio = (double.parse(inter['limiteInferior'].text) + double.parse(inter['limiteSuperior'].text)) / 2;
      int frecuencia = int.tryParse(inter['frecuencia'].text) ?? 0;

      frecuenciaTotal += frecuencia;
      sumaDeProductos += puntoMedio * frecuencia;
      if (puntoMedio != 0) {
        paraSumaArmonica += frecuencia / puntoMedio;
      }
    }
    return {
      'mediaAritmetica': sumaDeProductos / frecuenciaTotal,
      'mediaArmonica': frecuenciaTotal / paraSumaArmonica,
    };
  }
}
