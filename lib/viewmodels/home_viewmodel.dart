import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/cardapio.dart';

enum TipoRefeicao { almoco, jantar }

class HomeViewModel extends ChangeNotifier {
  final List<CardapioDia> _cardapioSemanal = dummyCardapioSemanal;
  final Map<String, String> _infoGeral = dummyInfoGeral;

  int _diaSelecionadoIndex = 0;
  TipoRefeicao _refeicaoSelecionada = TipoRefeicao.almoco;

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
}
