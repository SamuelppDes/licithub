// Testes integrados dos componentes e fluxos interativos do LicitHub
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/main.dart';

void main() {
  testWidgets(
    'monta o painel principal, exibe Match %, comparador PNCP, funil interativo, checklist de documentos e botao Sair',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1440, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: TemaApp.obterTemaClaro(),
          home: const LayoutPrincipal(),
        ),
      );
      await tester.pump();

      // 1. Verifica Sidebar, Logo, Perfil da Empresa e Botão Sair
      expect(find.text('LicitHub'), findsOneWidget);
      expect(find.text('LICITAÇÕES'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Buscar Editais'), findsOneWidget);
      expect(find.text('Funil'), findsOneWidget);
      expect(find.text('Documentos'), findsOneWidget);
      expect(find.text('Silva Soluções EPP'), findsOneWidget);
      expect(find.text('Sair'), findsOneWidget);

      // 2. Navega para Buscar Editais e verifica Score de Compatibilidade (Match %)
      await tester.tap(find.text('Buscar Editais'));
      await tester.pumpAndSettle();

      expect(find.text('94% compatível com seu CNAE'), findsOneWidget);
      expect(find.text('78% compatível com seu CNAE'), findsOneWidget);
      expect(find.text('91% compatível com seu CNAE'), findsOneWidget);

      // 3. Abre Detalhes do 3º Edital (Secretaria da Educação - 91% match) e verifica Comparador PNCP
      final botoesAnalisar = find.text('Analisar Edital');
      expect(botoesAnalisar, findsNWidgets(3));
      await tester.tap(botoesAnalisar.at(1)); // 2º da lista ordenada por Match (91%)
      await tester.pumpAndSettle();

      expect(
        find.text('Comparador de Preços • Histórico PNCP'),
        findsOneWidget,
      );
      expect(find.text('9% acima da média praticada em SP'), findsOneWidget);

      // 4. Adiciona ao Funil e abre a aba Funil
      await tester.tap(find.text('Adicionar ao Funil'));
      await tester.pumpAndSettle();

      expect(find.text('Adicionado ao Funil (Mapeados)'), findsOneWidget);
      await tester.tap(find.text('Abrir Funil de Disputa'));
      await tester.pumpAndSettle();

      // Verifica que o novo card foi adicionado em Mapeados (4 itens agora em Mapeados)
      expect(find.text('Mapeados (4)'), findsOneWidget);
      expect(
        find.text('Secretaria da Educação - Conservação'),
        findsOneWidget,
      );

      // Move um card de Mapeados para Documentação com 1 clique
      final botoesMoverParaDoc = find.text('Mover p/ Documentação');
      expect(botoesMoverParaDoc, findsWidgets);
      await tester.tap(botoesMoverParaDoc.first);
      await tester.pumpAndSettle();

      expect(find.text('Mapeados (3)'), findsOneWidget);
      expect(find.text('Documentação (2)'), findsOneWidget);

      // 5. Navega para Documentos (Checklist de Habilitação)
      await tester.tap(find.text('Documentos'));
      await tester.pumpAndSettle();

      expect(
        find.text('Checklist de Habilitação e Certidões'),
        findsOneWidget,
      );
      expect(
        find.text(
          'CND Federal (Débitos Relativos a Créditos Tributários Federais)',
        ),
        findsOneWidget,
      );
      expect(find.text('Vence em 5 dias'), findsWidgets);
      expect(find.text('Vencida'), findsWidgets);

      // Renova a CND Federal e verifica atualização de status
      await tester.tap(find.text('Revalidar CND Federal'));
      await tester.pumpAndSettle();
      expect(find.text('Vence em 5 dias (0)'), findsOneWidget);
    },
  );
}
