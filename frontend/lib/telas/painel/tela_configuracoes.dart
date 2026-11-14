import 'package:flutter/material.dart';
import '../../configuracoes/tema_app.dart';

typedef ConfiguracoesPage = TelaConfiguracoes;

/// Aba 5: Tela de Configurações e Usabilidade (Modo Claro / Modo Noturno, Escala de Fonte e Alto Contraste).
class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  bool _alertaMatchEmail = true;
  bool _alertaCertidoes = true;
  bool _sincronizacaoAutomaticaPncp = true;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configurações e Usabilidade',
            style: TextStyle(
              fontFamily: TemaApp.fonteSerifada,
              fontFamilyFallback: TemaApp.fallbackSerifada,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: corTexto,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Personalize a aparência (Modo Claro ou Noturno), acessibilidade visual e alertas do sistema.',
            style: TextStyle(fontSize: 14, color: corSubtexto),
          ),
          const SizedBox(height: 32),

          // 1. Seção Aparência: Modo Claro vs Modo Noturno
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: corCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: corBorda),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: const Color(0xFF2563EB),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Tema da Interface',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Escolha entre o Modo Claro tradicional ou o Modo Noturno para reduzir o cansaço visual.',
                  style: TextStyle(fontSize: 13.5, color: corSubtexto),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _buildCardEscolhaTema(
                        titulo: 'Modo Claro',
                        descricao: 'Fundo claro com alto brilho para ambientes iluminados.',
                        icone: Icons.light_mode_rounded,
                        selecionado: !isDark,
                        corPreviewFundo: const Color(0xFFF8FAFC),
                        corPreviewCard: Colors.white,
                        corPreviewTexto: const Color(0xFF0F172A),
                        onTap: () => TemaApp.definirModoNoturno(false),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildCardEscolhaTema(
                        titulo: 'Modo Noturno',
                        descricao: 'Tons escuros suaves para maior conforto visual.',
                        icone: Icons.dark_mode_rounded,
                        selecionado: isDark,
                        corPreviewFundo: const Color(0xFF0B1120),
                        corPreviewCard: const Color(0xFF1E293B),
                        corPreviewTexto: const Color(0xFFF8FAFC),
                        onTap: () => TemaApp.definirModoNoturno(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 2. Seção Usabilidade e Acessibilidade
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: corCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: corBorda),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.accessibility_new_rounded,
                      color: Color(0xFF10B981),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Usabilidade e Acessibilidade',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Escala de fonte
                Text(
                  'Tamanho da Fonte (Escala de Leitura)',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w600,
                    color: corTexto,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ajuste o tamanho dos textos em todas as telas para facilitar a leitura de editais.',
                  style: TextStyle(fontSize: 13, color: corSubtexto),
                ),
                const SizedBox(height: 14),
                ValueListenableBuilder<double>(
                  valueListenable: TemaApp.escalaFonte,
                  builder: (context, escalaAtual, _) {
                    return Wrap(
                      spacing: 12,
                      runSpacing: 10,
                      children: [
                        _buildOpcaoEscalaFonte(
                          rotulo: 'Padrão (100%)',
                          valor: 1.0,
                          escalaAtual: escalaAtual,
                        ),
                        _buildOpcaoEscalaFonte(
                          rotulo: 'Confortável (110%)',
                          valor: 1.1,
                          escalaAtual: escalaAtual,
                        ),
                        _buildOpcaoEscalaFonte(
                          rotulo: 'Ampliado (120%)',
                          valor: 1.2,
                          escalaAtual: escalaAtual,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 22),
                Divider(color: corBorda, height: 1),
                const SizedBox(height: 16),

                // Alto Contraste
                ValueListenableBuilder<bool>(
                  valueListenable: TemaApp.altoContraste,
                  builder: (context, altoContrasteAtivo, _) {
                    return SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      activeColor: const Color(0xFF2563EB),
                      title: Text(
                        'Destaque de Bordas e Alto Contraste',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600,
                          color: corTexto,
                        ),
                      ),
                      subtitle: Text(
                        'Reforça o contorno dos cards e indicadores para melhor distinção em projetores e apresentações.',
                        style: TextStyle(fontSize: 13, color: corSubtexto),
                      ),
                      value: altoContrasteAtivo,
                      onChanged: (valor) {
                        TemaApp.altoContraste.value = valor;
                        setState(() {});
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Seção Preferências Operacionais da Empresa
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: corCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: corBorda),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.tune_rounded,
                      color: Color(0xFF004CA3),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Notificações e Automação PNCP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF2563EB),
                  title: Text(
                    'Alertas automáticos de editais com Match ≥ 85%',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: corTexto,
                    ),
                  ),
                  subtitle: Text(
                    'Envia aviso imediato quando o motor de recomendação encontrar editais compatíveis com seu CNAE.',
                    style: TextStyle(fontSize: 13, color: corSubtexto),
                  ),
                  value: _alertaMatchEmail,
                  onChanged: (v) => setState(() => _alertaMatchEmail = v),
                ),
                Divider(color: corBorda, height: 16),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF2563EB),
                  title: Text(
                    'Aviso antecipado de vencimento de certidões (CND / FGTS / Trabalhista)',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: corTexto,
                    ),
                  ),
                  subtitle: Text(
                    'Exibe alerta amarelo no Dashboard quando uma certidão estiver a menos de 15 dias do vencimento.',
                    style: TextStyle(fontSize: 13, color: corSubtexto),
                  ),
                  value: _alertaCertidoes,
                  onChanged: (v) => setState(() => _alertaCertidoes = v),
                ),
                Divider(color: corBorda, height: 16),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  activeColor: const Color(0xFF2563EB),
                  title: Text(
                    'Comparativo automático com média histórica do PNCP',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: corTexto,
                    ),
                  ),
                  subtitle: Text(
                    'Calcula automaticamente a diferença percentual entre o valor estimado e a média praticada no estado.',
                    style: TextStyle(fontSize: 13, color: corSubtexto),
                  ),
                  value: _sincronizacaoAutomaticaPncp,
                  onChanged: (v) =>
                      setState(() => _sincronizacaoAutomaticaPncp = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardEscolhaTema({
    required String titulo,
    required String descricao,
    required IconData icone,
    required bool selecionado,
    required Color corPreviewFundo,
    required Color corPreviewCard,
    required Color corPreviewTexto,
    required VoidCallback onTap,
  }) {
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selecionado
              ? const Color(0xFF2563EB).withValues(alpha: 0.08)
              : TemaApp.corSuperficieSecundaria(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selecionado
                ? const Color(0xFF2563EB)
                : TemaApp.corBordaCard(context),
            width: selecionado ? 2.0 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mini preview visual do tema
            Container(
              height: 64,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: corPreviewFundo,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: corPreviewCard,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 8,
                          width: 80,
                          decoration: BoxDecoration(
                            color: corPreviewTexto.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      icone,
                      size: 20,
                      color: selecionado ? const Color(0xFF2563EB) : corTexto,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                  ],
                ),
                Icon(
                  selecionado
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selecionado ? const Color(0xFF2563EB) : corSubtexto,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              descricao,
              style: TextStyle(fontSize: 12.5, color: corSubtexto),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcaoEscalaFonte({
    required String rotulo,
    required double valor,
    required double escalaAtual,
  }) {
    final bool selecionado = (escalaAtual - valor).abs() < 0.01;
    final Color corTexto = TemaApp.corTextoPrincipal(context);

    return InkWell(
      onTap: () {
        TemaApp.escalaFonte.value = valor;
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selecionado
              ? const Color(0xFF2563EB)
              : TemaApp.corSuperficieSecundaria(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selecionado
                ? const Color(0xFF2563EB)
                : TemaApp.corBordaCard(context),
          ),
        ),
        child: Text(
          rotulo,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: selecionado ? Colors.white : corTexto,
          ),
        ),
      ),
    );
  }
}
