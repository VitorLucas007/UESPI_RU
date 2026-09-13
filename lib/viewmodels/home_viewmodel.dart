import 'dart:async';
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/cardapio.dart';

enum TipoRefeicao { almoco, jantar }

/// Status de funcionamento do RU baseado no horário atual.
enum StatusRu {
  /// O RU está atendendo agora (dentro do horário de almoço ou jantar).
  aberto,

  /// O RU está fora do horário de funcionamento.
  fechado,

  /// O RU abre em menos de 30 minutos.
  abreEmBreve,
}

class HomeViewModel extends ChangeNotifier {
  final List<CardapioDia> _cardapioSemanal = dummyCardapioSemanal;
  final Map<String, String> _infoGeral = dummyInfoGeral;

  int _diaSelecionadoIndex = 0;
  TipoRefeicao _refeicaoSelecionada = TipoRefeicao.almoco;
  Timer? _timerStatus;

  HomeViewModel() {
    _iniciarTimerStatus();
  }

  // Getters existentes

  List<CardapioDia> get cardapioSemanal => _cardapioSemanal;
  Map<String, String> get infoGeral => _infoGeral;
  int get diaSelecionadoIndex => _diaSelecionadoIndex;
  TipoRefeicao get refeicaoSelecionada => _refeicaoSelecionada;

  CardapioDia get diaAtual => _cardapioSemanal[_diaSelecionadoIndex];

  Refeicao? get refeicaoAtual {
    return _refeicaoSelecionada == TipoRefeicao.almoco
        ? diaAtual.almoco
        : diaAtual.jantar;
  }

  bool get estaFechado => refeicaoAtual == null;

  // Status dinâmico do RU

  /// Retorna o [StatusRu] calculado para o horário atual.
  StatusRu get statusRu => _calcularStatus(DateTime.now());

  /// Texto legível do status para exibição na UI.
  String get statusRuTexto {
    switch (statusRu) {
      case StatusRu.aberto:
        return 'RU ABERTO';
      case StatusRu.abreEmBreve:
        return 'ABRE EM BREVE';
      case StatusRu.fechado:
        return 'RU FECHADO';
    }
  }

  /// Calcula o status baseado em [agora] comparando com os horários de
  /// almoço e jantar do dia selecionado.
  StatusRu _calcularStatus(DateTime agora) {
    final dia = diaAtual;
    final horaAtual = agora.hour * 60 + agora.minute; // minutos desde 00:00

    // Verifica almoço
    final intervaloAlmoco = _parseIntervalo(dia.almoco.horario);
    if (intervaloAlmoco != null) {
      if (horaAtual >= intervaloAlmoco.$1 && horaAtual <= intervaloAlmoco.$2) {
        return StatusRu.aberto;
      }
      // Abre em breve: faltam 30 min ou menos para o início
      if (horaAtual >= intervaloAlmoco.$1 - 30 &&
          horaAtual < intervaloAlmoco.$1) {
        return StatusRu.abreEmBreve;
      }
    }

    // Verifica jantar (se existir)
    if (dia.temJantar) {
      final intervaloJantar = _parseIntervalo(dia.janta!.horario);
      if (intervaloJantar != null) {
        if (horaAtual >= intervaloJantar.$1 &&
            horaAtual <= intervaloJantar.$2) {
          return StatusRu.aberto;
        }
        if (horaAtual >= intervaloJantar.$1 - 30 &&
            horaAtual < intervaloJantar.$1) {
          return StatusRu.abreEmBreve;
        }
      }
    }

    return StatusRu.fechado;
  }

  /// Faz o parse de uma string como "11:00 às 13:30" e retorna um record
  /// (inicioMinutos, fimMinutos). Retorna null se o formato for inesperado.
  (int, int)? _parseIntervalo(String horario) {
    // Normaliza variações: "às", "as", "-", "a"
    final partes = horario
        .replaceAll('às', '|')
        .replaceAll('as', '|')
        .replaceAll('-', '|')
        .replaceAll(' a ', '|')
        .split('|')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    if (partes.length != 2) return null;

    final inicio = _parseHora(partes[0]);
    final fim = _parseHora(partes[1]);
    if (inicio == null || fim == null) return null;

    return (inicio, fim);
  }

  /// Converte "HH:MM" em minutos desde 00:00.
  int? _parseHora(String hora) {
    final componentes = hora.split(':');
    if (componentes.length != 2) return null;
    final h = int.tryParse(componentes[0]);
    final m = int.tryParse(componentes[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  // Timer para atualização automática
  void _iniciarTimerStatus() {
    // Atualiza a cada 60 segundos para recalcular o status
    _timerStatus = Timer.periodic(const Duration(seconds: 60), (_) {
      notifyListeners();
    });
  }

  // Seleção de dia e refeição
  void selecionarDia(int index) {
    if (index >= 0 && index < _cardapioSemanal.length) {
      _diaSelecionadoIndex = index;
      notifyListeners();
    }
  }

  void selecionarRefeicao(TipoRefeicao tipo) {
    if (_refeicaoSelecionada != tipo) {
      _refeicaoSelecionada = tipo;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timerStatus?.cancel();
    super.dispose();
  }
}
