class Notificacao {
  final String id;
  final String titulo;
  final String mensagem;
  final String horarioEnvio;
  final String tipo; // 'status_ru', 'alerta', 'aviso'

  const Notificacao({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.horarioEnvio,
    required this.tipo,
  });

  String get horario => horarioEnvio;
}
