class LocalizacaoRu {
  final double latitude;
  final double longitude;
  final String campus;
  final String nome;
  final String pontoReferencia;
  final String tempoCaminhada;

  const LocalizacaoRu({
    required this.latitude,
    required this.longitude,
    required this.campus,
    required this.nome,
    required this.pontoReferencia,
    required this.tempoCaminhada,
  });

  String get googleMapsUrl =>
      'https://www.google.com/maps/search/?api=1&query=,';
}
