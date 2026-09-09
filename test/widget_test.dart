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
  });
}
