import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/notificacao.dart';

class NotificacaoViewModel extends ChangeNotifier {
  final List<Notificacao> notificacoes = dummyNotificacoes;
}
