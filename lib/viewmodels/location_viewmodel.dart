import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/dummy_data.dart';
import '../models/localizacao.dart';

class LocationViewModel extends ChangeNotifier {
  final LocalizacaoRu localizacao = dummyLocalizacao;

  Future<bool> abrirNoGoogleMaps() async {
    final Uri url = Uri.parse(localizacao.googleMapsUrl);
    if (await canLaunchUrl(url)) {
      return await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Fallback
      return await launchUrl(url);
    }
  }
}
