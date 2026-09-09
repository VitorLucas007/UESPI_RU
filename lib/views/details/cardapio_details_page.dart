import 'package:flutter/material.dart';
import '../../models/cardapio.dart';
import '../../viewmodels/cardapio_details_viewmodel.dart';

class CardapioDetailsPage extends StatefulWidget {
  const CardapioDetailsPage({super.key});

  @override
  State<CardapioDetailsPage> createState() => _CardapioDetailsPageState();
}

class _CardapioDetailsPageState extends State<CardapioDetailsPage> {
  final CardapioDetailsViewModel _viewModel = CardapioDetailsViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF003366)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Cardápio da Semana',
          style: TextStyle(
            color: Color(0xFF003366),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: _viewModel.cardapioSemanal.length,
        itemBuilder: (context, index) {
          final dia = _viewModel.cardapioSemanal[index];
          return _buildDiaCard(dia);
        },
      ),
    );
  }

  Widget _buildDiaCard(CardapioDia dia) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho do Card com ícone de calendário, nome do dia e data
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF003366).withValues(alpha: 0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.calendar_month_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  dia.diaSemana,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF003366),
                  ),
                ),
                const Spacer(),
                Text(
                  dia.dataAbreviada,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Bloco Almoço
                _buildMealBlock(
                  titulo: 'Almoço',
                  icon: Icons.wb_sunny_rounded,
                  iconColor: Colors.amber.shade700,
                  refeicao: dia.almoco,
                ),

                const Divider(height: 24),

                // Bloco Jantar
                if (dia.janta != null)
                  _buildMealBlock(
                    titulo: 'Jantar',
                    icon: Icons.nightlight_round,
                    iconColor: Colors.indigo.shade600,
                    refeicao: dia.janta!,
                  )
                else
                  _buildClosedBlock(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealBlock({
    required String titulo,
    required IconData icon,
    required Color iconColor,
    required Refeicao refeicao,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 6),
            Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.grey.shade800,
              ),
            ),
            const Spacer(),
            Text(
              refeicao.horario,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Prato principal
        Text(
          refeicao.pratoPrincipal,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF212121),
          ),
        ),
        if (refeicao.acompanhamentoPrato.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            refeicao.acompanhamentoPrato,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
        const SizedBox(height: 8),

        // Chip / Badge Opção Vegana
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFA5D6A7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.eco, size: 14, color: Color(0xFF2E7D32)),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Opção Vegana: ${refeicao.opcaoVegetariana}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B5E20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClosedBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.nightlight_round, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Text(
            'Jantar: RU Fechado (sem funcionamento)',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
