import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ru_uespi/main.dart';

void main() {
  testWidgets('App smoke test loads SplashPage and navigates to HomePage', (WidgetTester tester) async {
    await tester.pumpWidget(const RuUespiApp());
    expect(find.text('RU UESPI'), findsOneWidget);
    expect(find.text('CARREGANDO'), findsOneWidget);

    // Aguarda o timer da Splash Screen (2,5s) concluir a transição
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));

    // Valida que chegou na HomePage
    expect(find.text('Cardápio de Hoje'), findsOneWidget);
    expect(find.text('PRATO PRINCIPAL'), findsOneWidget);
    expect(find.text('R\$ 1,00 - Tarifa Estudante'), findsOneWidget);

    // Valida que um dos status dinâmicos do RU está presente
    final statusAberto = find.text('RU ABERTO');
    final statusFechado = find.text('RU FECHADO');
    final statusEmBreve = find.text('ABRE EM BREVE');
    expect(
      statusAberto.evaluate().isNotEmpty ||
          statusFechado.evaluate().isNotEmpty ||
          statusEmBreve.evaluate().isNotEmpty,
      isTrue,
      reason: 'Deve exibir um dos status do RU: ABERTO, FECHADO ou ABRE EM BREVE',
    );
  });

  testWidgets('AppDrawer opens and displays all navigation items and footer', (WidgetTester tester) async {
    await tester.pumpWidget(const RuUespiApp());
    await tester.pumpAndSettle(const Duration(milliseconds: 3000));

    // Clica no botão de menu da AppBar para abrir o drawer
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // Valida o cabeçalho e marca
    expect(find.text('RU UESPI'), findsWidgets);

    // Valida os itens de navegação principal
    expect(find.text('Cardápio Completo'), findsOneWidget);
    expect(find.text('Localização'), findsOneWidget);
    expect(find.text('Informações sobre o RU'), findsOneWidget);
    expect(find.text('Configurações'), findsOneWidget);

    // Valida o footer
    expect(find.text('Sair do App'), findsOneWidget);
  });
}
