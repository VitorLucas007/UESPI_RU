import 'package:flutter/material.dart';
import '../../viewmodels/home_viewmodel.dart';
import 'widgets/header_card.dart';
import 'widgets/meal_selector.dart';
import 'widgets/today_menu_section.dart';
import 'widgets/upcoming_days_section.dart';
import 'widgets/notice_banner.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diaAtual = _viewModel.diaAtual;
    final refeicaoAtual = _viewModel.refeicaoAtual;
    final infoGeral = _viewModel.infoGeral;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF003366)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Menu lateral em desenvolvimento'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'RU UESPI',
          style: TextStyle(
            color: Color(0xFF003366),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF003366)),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            HeaderCard(
              campus: infoGeral['campus'] ?? 'Campus Torquato Neto',
              statusRu: infoGeral['statusRu'] ?? 'RU ABERTO',
              tarifa: infoGeral['tarifa'] ?? 'R\$ 1,00',
              tarifaRotulo: infoGeral['tarifaRotulo'] ?? 'Tarifa Estudante',
              horario: refeicaoAtual?.horario ?? diaAtual.almoco.horario,
              onLocationTap: () {
                Navigator.pushNamed(context, '/location');
              },
            ),
            const SizedBox(height: 16),

            // Selector de Refeição (Almoço / Jantar)
            MealSelector(
              selectedMeal: _viewModel.refeicaoSelecionada,
              onMealChanged: (novoTipo) {
                _viewModel.selecionarRefeicao(novoTipo);
              },
            ),
            const SizedBox(height: 20),

            // Seção "Cardápio de Hoje"
            TodayMenuSection(
              dia: diaAtual,
              refeicao: refeicaoAtual,
              onViewAllTap: () {
                Navigator.pushNamed(context, '/details');
              },
            ),
            const SizedBox(height: 24),

            // Seção "Próximos dias"
            UpcomingDaysSection(
              dias: _viewModel.cardapioSemanal,
              selectedIndex: _viewModel.diaSelecionadoIndex,
              onDaySelected: (index) {
                _viewModel.selecionarDia(index);
              },
            ),
            const SizedBox(height: 20),

            // Banner Inferior
            NoticeBanner(
              message: infoGeral['alertaHorario'] ??
                  'Atenção ao horário: O acesso ao refeitório encerra rigorosamente às 13:30.',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
