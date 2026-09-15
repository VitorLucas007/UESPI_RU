import 'package:flutter/material.dart';
import '../../../viewmodels/home_viewmodel.dart';

class HeaderCard extends StatelessWidget {
  final String campus;
  final StatusRu statusRu;
  final String statusRuTexto;
  final String tarifa;
  final String tarifaRotulo;
  final String horario;
  final VoidCallback onLocationTap;

  const HeaderCard({
    super.key,
    required this.campus,
    required this.statusRu,
    required this.statusRuTexto,
    required this.tarifa,
    required this.tarifaRotulo,
    required this.horario,
    required this.onLocationTap,
  });

  /// Cor principal do badge de acordo com o status.
  Color _corStatus() {
    switch (statusRu) {
      case StatusRu.aberto:
        return const Color(0xFF2E7D32); // verde
      case StatusRu.abreEmBreve:
        return const Color(0xFFF57F17); // âmbar
      case StatusRu.fechado:
        return const Color(0xFFC62828); // vermelho
    }
  }

  @override
  Widget build(BuildContext context) {
    final valorLimpo = tarifa.trim();
    final valorFormatado =
        valorLimpo.startsWith(r'R$') ? valorLimpo : 'R\$ $valorLimpo';
    final rotuloLimpo = tarifaRotulo.trim();
    final textoTarifa = rotuloLimpo.isNotEmpty
        ? '$valorFormatado - $rotuloLimpo'
        : valorFormatado;

    final corBadge = _corStatus();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Pin + Campus clicável
              Expanded(
                child: InkWell(
                  onTap: onLocationTap,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF003366), size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            campus,
                            style: const TextStyle(
                              color: Color(0xFF003366),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Badge RU ABERTO
              // Badge status dinâmico
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: corBadge.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: corBadge.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: corBadge,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      statusRuTexto,
                      style: TextStyle(
                        color: corBadge,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tarifa
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.attach_money, color: Color(0xFFF57F17), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textoTarifa,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Color(0xFF212121),
                            ),
                          ),
                          const Text(
                            'Pagamento via PIX/Ticket',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Horário
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.access_time, color: Color(0xFF1976D2), size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    horario,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF424242),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
