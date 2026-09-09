import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/cardapio.dart';

class CardapioDetailsViewModel extends ChangeNotifier {
  final List<CardapioDia> cardapioSemanal = dummyCardapioSemanal;
}
