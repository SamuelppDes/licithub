import 'package:flutter/material.dart';
import '../../configuracoes/tema_app.dart';
import '../../modelos/edital.dart';

typedef DetalhesEditalPage = TelaDetalhesEdital;

/// Sub-tela de Detalhes do Edital com Resumo Inteligente IA, Comparador de Preços PNCP e adição real ao Funil.
class TelaDetalhesEdital extends StatefulWidget {
  final Edital edital;
  final VoidCallback onBack;
  final ValueChanged<Edital>? onAdicionarAoFunil;
  final VoidCallback? onIrParaFunil;
  final bool jaNoFunil;

  const TelaDetalhesEdital({
    super.key,
    required this.edital,
    required this.onBack,
    this.onAdicionarAoFunil,
    this.onIrParaFunil,
    this.jaNoFunil = false,
  });

  @override
  State<TelaDetalhesEdital> createState() => _TelaDetalhesEditalState();
}

class _TelaDetalhesEditalState extends State<TelaDetalhesEdital> {
  late bool _adicionadoLocalmente;

  @override
  void initState() {
    super.initState();
    _adicionadoLocalmente = widget.jaNoFunil;
  }

  @override
  void didUpdateWidget(covariant TelaDetalhesEdital oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.edital.identificadorUnico !=
            widget.edital.identificadorUnico ||
        oldWidget.jaNoFunil != widget.jaNoFunil) {
      _adicionadoLocalmente = widget.jaNoFunil;
    }
  }

  void _handleAdicionarAoFunil() {
    widget.onAdicionarAoFunil?.call(widget.edital);
    setState(() {
      _adicionadoLocalmente = true;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        content: Text(
          '${widget.edital.titulo} (${widget.edital.orgao}) adicionado em "Mapeados" no Funil!',
        ),
        action: widget.onIrParaFunil != null
            ? SnackBarAction(
                label: 'Ver no Funil',
                textColor: const Color(0xFF34D399),
                onPressed: widget.onIrParaFunil!,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final edital = widget.edital;
    final bool altoMatch = edital.scoreCompatibilidade >= 85;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: corTexto,
                    ),
                    onPressed: widget.onBack,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Detalhes do Edital',
                    style: TextStyle(
                      fontFamily: TemaApp.fonteSerifada,
                      fontFamilyFallback: TemaApp.fallbackSerifada,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: altoMatch
                          ? const Color(0xFFECFDF5)
                          : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: altoMatch
                            ? const Color(0xFFA7F3D0)
                            : const Color(0xFFBFDBFE),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          altoMatch
                              ? Icons.auto_awesome_rounded
                              : Icons.insights_rounded,
                          size: 15,
                          color: altoMatch
                              ? const Color(0xFF059669)
                              : const Color(0xFF2563EB),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${edital.scoreCompatibilidade}% compatível com seu CNAE',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: altoMatch
                                ? const Color(0xFF059669)
                                : const Color(0xFF2563EB),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.notifications_none, color: corSubtexto),
                  const SizedBox(width: 16),
                  CircleAvatar(
                    backgroundColor:
                        isDark ? const Color(0xFF334155) : Colors.grey[300],
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Coluna Esquerda: Dados do Edital + Comparador de Preços PNCP + Itens Licitados
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: corCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: corBorda),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${edital.titulo} -\n${edital.orgao}',
                            style: TextStyle(
                              fontFamily: TemaApp.fonteSerifada,
                              fontFamilyFallback: TemaApp.fallbackSerifada,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: corTexto,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            edital.cnaeCompativel,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            edital.objeto,
                            style: TextStyle(
                              fontSize: 15,
                              color: corSubtexto,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Valor estimado: ${edital.valor}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Comparador de Preços / Histórico de Lances PNCP
                          _buildComparadorPrecosCard(context, edital),

                          const SizedBox(height: 24),
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Abrindo documento oficial do PNCP para ${edital.titulo}...',
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.picture_as_pdf_outlined,
                              color: Color(0xFF2563EB),
                            ),
                            label: const Text(
                              'Edital_Completo.pdf',
                              style: TextStyle(color: Color(0xFF2563EB)),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              side: const BorderSide(color: Color(0xFFBFDBFE)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            'Itens licitados',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: corTexto,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...edital.itens.map(
                            (item) => _buildBullet(context, item),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),

                // Coluna Direita: Resumo Inteligente IA + Ação Adicionar ao Funil
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resumo Inteligente IA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: corTexto,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF064E3B).withValues(alpha: 0.35)
                                : const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF059669)
                                  : const Color(0xFFBBF7D0),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildResumoRow(
                                context,
                                'Exige Atestado Técnico?',
                                edital.exigeAtestadoTecnico ? 'SIM' : 'NÃO',
                                edital.exigeAtestadoTecnico,
                              ),
                              Divider(
                                height: 24,
                                color: isDark
                                    ? const Color(0xFF065F46)
                                    : const Color(0xFFBBF7D0),
                              ),
                              _buildResumoRow(
                                context,
                                'Vistoria prévia?',
                                edital.exigeVistoriaPrevia ? 'SIM' : 'NÃO',
                                !edital.exigeVistoriaPrevia,
                              ),
                              Divider(
                                height: 24,
                                color: isDark
                                    ? const Color(0xFF065F46)
                                    : const Color(0xFFBBF7D0),
                              ),
                              _buildResumoRow(
                                context,
                                'Capital Social mínimo:',
                                edital.capitalSocialMinimo,
                                true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _handleAdicionarAoFunil,
                            icon: Icon(
                              _adicionadoLocalmente
                                  ? Icons.check_circle_outline
                                  : Icons.add,
                              color: Colors.white,
                            ),
                            label: Text(
                              _adicionadoLocalmente
                                  ? 'Adicionado ao Funil (Mapeados)'
                                  : 'Adicionar ao Funil',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _adicionadoLocalmente
                                  ? const Color(0xFF059669)
                                  : const Color(0xFF10B981),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        if (_adicionadoLocalmente &&
                            widget.onIrParaFunil != null) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: widget.onIrParaFunil,
                              icon: const Icon(
                                Icons.view_kanban_outlined,
                                size: 18,
                              ),
                              label: const Text('Abrir Funil de Disputa'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF2563EB),
                                side: const BorderSide(
                                  color: Color(0xFFBFDBFE),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Card visual comparando o Valor Estimado do Edital com a Média Histórica do PNCP.
  Widget _buildComparadorPrecosCard(BuildContext context, Edital edital) {
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);
    final Color corBorda = TemaApp.corBordaCard(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TemaApp.corSuperficieSecundaria(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: corBorda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.analytics_outlined,
                    size: 20,
                    color: Color(0xFF2563EB),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Comparador de Preços • Histórico PNCP',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: corTexto,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Text(
                  edital.comparativoPrecoTexto,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Barra 1: Valor Estimado do Edital
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Valor Estimado neste Edital',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: corTexto,
                ),
              ),
              Text(
                edital.valor,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.92,
              minHeight: 8,
              backgroundColor: corBorda,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(height: 14),

          // Barra 2: Média Histórica PNCP
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Média Histórica PNCP (últimos 12 meses em SP)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: corSubtexto,
                ),
              ),
              Text(
                edital.mediaHistoricaPncp,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: corTexto,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.80,
              minHeight: 8,
              backgroundColor: corBorda,
              color: const Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'O teto deste edital permite margem competitiva saudável em relação aos lances vencedores homologados no PNCP.',
            style: TextStyle(fontSize: 12, color: corSubtexto),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(BuildContext context, String text) {
    final Color corSubtexto = TemaApp.corTextoSecundario(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, right: 12),
            child: CircleAvatar(radius: 3, backgroundColor: corSubtexto),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: corSubtexto, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoRow(
    BuildContext context,
    String label,
    String value,
    bool isPositive,
  ) {
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: corTexto, fontSize: 13),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPositive
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              isPositive ? Icons.check_circle_outline : Icons.cancel_outlined,
              size: 16,
              color: isPositive
                  ? const Color(0xFF10B981)
                  : const Color(0xFFEF4444),
            ),
          ],
        ),
      ],
    );
  }
}
