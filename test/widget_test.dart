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
}
