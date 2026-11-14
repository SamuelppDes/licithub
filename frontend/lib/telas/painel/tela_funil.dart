import 'package:flutter/material.dart';
import '../../configuracoes/tema_app.dart';
import '../../modelos/edital.dart';

typedef FunilPage = TelaFunil;

/// Aba 3: Quadro Kanban interativo do Funil de Disputa (suporta Drag-and-Drop, clique rápido e Modo Noturno/Claro).
class TelaFunil extends StatefulWidget {
  final List<ItemFunil>? itens;
  final void Function(String id, EtapaFunil novaEtapa)? onMoverCard;

  const TelaFunil({
    super.key,
    this.itens,
    this.onMoverCard,
  });

  static List<ItemFunil> obterItensIniciais() => const [
    ItemFunil(
      id: 'Prefeitura de São Paulo|Pregão Eletrônico 45/2026',
      titulo: 'Prefeitura de SP - Limpeza',
      valor: 'R\$ 250k',
      etapa: EtapaFunil.mapeados,
      scoreCompatibilidade: 94,
    ),
    ItemFunil(
      id: 'Governo do Estado de SP|Pregão Eletrônico 12/2026',
      titulo: 'Governo do Estado de SP - Software',
      valor: 'R\$ 840k',
      etapa: EtapaFunil.mapeados,
      scoreCompatibilidade: 78,
    ),
    ItemFunil(
      id: 'Secretaria de Educação|Uniformes',
      titulo: 'Secretaria de Educação - Uniformes',
      valor: 'R\$ 120k',
      etapa: EtapaFunil.mapeados,
      scoreCompatibilidade: 88,
    ),
    ItemFunil(
      id: 'Hospital das Clínicas|Insumos',
      titulo: 'Hospital das Clínicas - Insumos',
      valor: 'R\$ 120k',
      etapa: EtapaFunil.documentacao,
      progresso: 0.75,
      textoProgresso: '75% completo',
    ),
    ItemFunil(
      id: 'Tribunal de Justiça|TI',
      titulo: 'Tribunal de Justiça - TI',
      valor: 'R\$ 95k',
      etapa: EtapaFunil.prontoParaLance,
    ),
    ItemFunil(
      id: 'Câmara de SP|Móveis',
      titulo: 'Câmara de SP - Móveis',
      valor: '(R\$ 45k)',
      etapa: EtapaFunil.resultados,
      tagResultado: '[Ganho]',
    ),
  ];

  @override
  State<TelaFunil> createState() => _TelaFunilState();
}

class _TelaFunilState extends State<TelaFunil> {
  late List<ItemFunil> _itensInternos;

  @override
  void initState() {
    super.initState();
    _itensInternos = List<ItemFunil>.from(TelaFunil.obterItensIniciais());
  }

  List<ItemFunil> get _listaAtiva => widget.itens ?? _itensInternos;

  void _moverItem(ItemFunil item, EtapaFunil destino) {
    if (item.etapa == destino) return;

    if (widget.onMoverCard != null) {
      widget.onMoverCard!(item.id, destino);
    } else {
      setState(() {
        final idx = _itensInternos.indexWhere((e) => e.id == item.id);
        if (idx != -1) {
          _itensInternos[idx] = _atualizarMetadadosEtapa(
            _itensInternos[idx],
            destino,
          );
        }
      });
    }
  }

  static ItemFunil _atualizarMetadadosEtapa(
    ItemFunil item,
    EtapaFunil destino,
  ) {
    if (destino == EtapaFunil.documentacao) {
      return item.copyWith(
        etapa: destino,
        progresso: item.progresso ?? 0.75,
        textoProgresso: item.textoProgresso ?? '75% completo',
      );
    }
    if (destino == EtapaFunil.resultados) {
      return item.copyWith(
        etapa: destino,
        tagResultado: item.tagResultado ?? '[Ganho]',
      );
    }
    return item.copyWith(etapa: destino);
  }

  EtapaFunil? _proximaEtapa(EtapaFunil atual) {
    final valores = EtapaFunil.values;
    final idx = valores.indexOf(atual);
    if (idx >= 0 && idx < valores.length - 1) {
      return valores[idx + 1];
    }
    return null;
  }

  EtapaFunil? _etapaAnterior(EtapaFunil atual) {
    final valores = EtapaFunil.values;
    final idx = valores.indexOf(atual);
    if (idx > 0) {
      return valores[idx - 1];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Funil de Disputa',
                    style: TextStyle(
                      fontFamily: TemaApp.fonteSerifada,
                      fontFamilyFallback: TemaApp.fallbackSerifada,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Arraste os cards entre as colunas ou clique nas setas para avançar a etapa da licitação.',
                    style: TextStyle(fontSize: 13.5, color: corSubtexto),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.drag_indicator_rounded,
                      size: 16,
                      color: Color(0xFF2563EB),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Total no funil: ${_listaAtiva.length} processos',
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D4ED8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildKanbanColumn(context, etapa: EtapaFunil.mapeados),
                const SizedBox(width: 20),
                _buildKanbanColumn(context, etapa: EtapaFunil.documentacao),
                const SizedBox(width: 20),
                _buildKanbanColumn(context, etapa: EtapaFunil.prontoParaLance),
                const SizedBox(width: 20),
                _buildKanbanColumn(context, etapa: EtapaFunil.resultados),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn(BuildContext context, {required EtapaFunil etapa}) {
    final itensColuna =
        _listaAtiva.where((item) => item.etapa == etapa).toList();
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return Expanded(
      child: DragTarget<ItemFunil>(
        onWillAcceptWithDetails: (details) => details.data.etapa != etapa,
        onAcceptWithDetails: (details) => _moverItem(details.data, etapa),
        builder: (context, candidateData, rejectedData) {
          final bool recebendoDrag = candidateData.isNotEmpty;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: recebendoDrag
                  ? const Color(0xFF2563EB).withValues(alpha: 0.10)
                  : corCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: recebendoDrag ? const Color(0xFF2563EB) : corBorda,
                width: recebendoDrag ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '${etapa.rotulo} (${itensColuna.length})',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: corTexto,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: TemaApp.corSuperficieSecundaria(context),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${itensColuna.length}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: corSubtexto,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: itensColuna.isEmpty
                      ? Center(
                          child: Text(
                            recebendoDrag
                                ? 'Solte aqui para mover'
                                : 'Arraste um edital para cá',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: recebendoDrag
                                  ? const Color(0xFF2563EB)
                                  : corSubtexto,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: itensColuna.length,
                          itemBuilder: (context, index) {
                            final item = itensColuna[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildDraggableKanbanCard(context, item),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDraggableKanbanCard(BuildContext context, ItemFunil item) {
    final cardWidget = _buildKanbanCardVisual(context, item);

    return Draggable<ItemFunil>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: 240,
          child: Opacity(
            opacity: 0.92,
            child: cardWidget,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.35,
        child: cardWidget,
      ),
      child: cardWidget,
    );
  }

  Widget _buildKanbanCardVisual(BuildContext context, ItemFunil item) {
    final anterior = _etapaAnterior(item.etapa);
    final proxima = _proximaEtapa(item.etapa);
    final mostrarProgresso =
        item.etapa == EtapaFunil.documentacao && item.progresso != null;
    final mostrarTagResultado =
        item.etapa == EtapaFunil.resultados && item.tagResultado != null;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);
    final Color corBorda = TemaApp.corBordaCard(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.etapa == EtapaFunil.resultados
            ? (isDark
                  ? const Color(0xFF064E3B).withValues(alpha: 0.35)
                  : const Color(0xFFF0FDF4))
            : TemaApp.corSuperficieSecundaria(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: item.etapa == EtapaFunil.resultados
              ? (isDark ? const Color(0xFF059669) : const Color(0xFFBBF7D0))
              : corBorda,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.titulo,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: corTexto,
                    fontSize: 14,
                  ),
                ),
              ),
              Icon(
                Icons.drag_handle_rounded,
                size: 16,
                color: corSubtexto,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.valor,
                style: TextStyle(
                  color: corSubtexto,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (item.scoreCompatibilidade != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: item.scoreCompatibilidade! >= 85
                        ? const Color(0xFFECFDF5)
                        : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${item.scoreCompatibilidade}% match',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: item.scoreCompatibilidade! >= 85
                          ? const Color(0xFF059669)
                          : const Color(0xFF2563EB),
                    ),
                  ),
                ),
            ],
          ),
          if (mostrarProgresso) ...[
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: item.progresso,
              backgroundColor: corBorda,
              color: const Color(0xFF2563EB),
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),
            const SizedBox(height: 6),
            Text(
              item.textoProgresso ?? '',
              style: TextStyle(color: corSubtexto, fontSize: 12),
            ),
          ],
          if (mostrarTagResultado) ...[
            const SizedBox(height: 10),
            Text(
              item.tagResultado!,
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (anterior != null)
                InkWell(
                  onTap: () => _moverItem(item, anterior),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 11,
                          color: corSubtexto,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          anterior.rotulo,
                          style: TextStyle(
                            fontSize: 11,
                            color: corSubtexto,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),
              if (proxima != null)
                InkWell(
                  onTap: () => _moverItem(item, proxima),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Mover p/ ${proxima.rotulo}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 12,
                          color: Color(0xFF2563EB),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
