import 'package:flutter/material.dart';
import '../../configuracoes/tema_app.dart';
import '../../modelos/edital.dart';

typedef BuscarEditaisPage = TelaBuscarEditais;

/// Aba 2: Busca interativa e listagem de Editais com Score de Compatibilidade (Match % por CNAE).
class TelaBuscarEditais extends StatefulWidget {
  final ValueChanged<Edital> onAnalisar;
  final ValueChanged<Edital>? onAdicionarAoFunil;
  final Set<String> idsNoFunil;

  const TelaBuscarEditais({
    super.key,
    required this.onAnalisar,
    this.onAdicionarAoFunil,
    this.idsNoFunil = const {},
  });

  static const List<Edital> editais = [
    Edital(
      titulo: 'Pregão Eletrônico 45/2026',
      orgao: 'Prefeitura de São Paulo',
      objeto:
          'Contratação de serviços de limpeza predial para as unidades administrativas, com fornecimento de mão de obra, materiais e equipamentos.',
      valor: 'R\$ 250.000,00',
      scoreCompatibilidade: 94,
      cnaeCompativel: 'CNAE 8121-4/00 • Limpeza em Prédios',
      mediaHistoricaPncp: 'R\$ 223.200,00',
      percentualDiferencaMedia: 12.0,
      comparativoPrecoTexto: '12% acima da média praticada em SP',
      resumoFunil: 'Prefeitura de SP - Limpeza',
      valorCurto: 'R\$ 250k',
      exigeAtestadoTecnico: true,
      exigeVistoriaPrevia: false,
      capitalSocialMinimo: 'R\$ 25.000',
      tags: ['Limpeza', 'São Paulo', '> R\$ 100k'],
      itens: [
        'Limpeza e conservação das áreas internas e externas',
        'Fornecimento de materiais de higiene e limpeza',
        'Equipe com supervisão dedicada',
        'Capital social mínimo: R\$ 25.000',
      ],
    ),
    Edital(
      titulo: 'Pregão Eletrônico 12/2026',
      orgao: 'Governo do Estado de SP',
      objeto:
          'Fornecimento de licenças de software de gestão, com serviços de implantação, treinamento e suporte técnico.',
      valor: 'R\$ 840.000,00',
      scoreCompatibilidade: 78,
      cnaeCompativel: 'CNAE 6202-3/00 • Software e Gestão',
      mediaHistoricaPncp: 'R\$ 792.450,00',
      percentualDiferencaMedia: 6.0,
      comparativoPrecoTexto: '6% acima da média praticada em SP',
      resumoFunil: 'Governo do Estado de SP - Software',
      valorCurto: 'R\$ 840k',
      exigeAtestadoTecnico: true,
      exigeVistoriaPrevia: false,
      capitalSocialMinimo: 'R\$ 80.000',
      tags: ['Tecnologia', 'São Paulo', '> R\$ 100k'],
      itens: [
        'Licenças de uso por 24 meses',
        'Implantação e migração de dados',
        'Treinamento das equipes',
        'Suporte técnico em horário comercial',
      ],
    ),
    Edital(
      titulo: 'Pregão Eletrônico 29/2026',
      orgao: 'Secretaria da Educação de SP',
      objeto:
          'Prestação de serviços contínuos de higienização, conservação e apoio operacional para unidades escolares da rede estadual.',
      valor: 'R\$ 310.000,00',
      scoreCompatibilidade: 91,
      cnaeCompativel: 'CNAE 8121-4/00 • Limpeza e Conservação',
      mediaHistoricaPncp: 'R\$ 284.400,00',
      percentualDiferencaMedia: 9.0,
      comparativoPrecoTexto: '9% acima da média praticada em SP',
      resumoFunil: 'Secretaria da Educação - Conservação',
      valorCurto: 'R\$ 310k',
      exigeAtestadoTecnico: true,
      exigeVistoriaPrevia: true,
      capitalSocialMinimo: 'R\$ 30.000',
      tags: ['Limpeza', 'São Paulo', '> R\$ 100k'],
      itens: [
        'Conservação de áreas escolares internas e pátios',
        'Insumos biodegradáveis inclusos no contrato',
        'Cronograma mensal com fiscalização escolar',
        'Capital social mínimo: R\$ 30.000',
      ],
    ),
  ];

  @override
  State<TelaBuscarEditais> createState() => _TelaBuscarEditaisState();
}

class _TelaBuscarEditaisState extends State<TelaBuscarEditais> {
  final TextEditingController _buscaController = TextEditingController();
  String _termoBusca = '';
  String? _tagFiltroAtiva;
  final bool _ordenarPorMatch = true;

  static const List<String> _tagsDisponiveis = [
    'Limpeza',
    'São Paulo',
    '> R\$ 100k',
    'Tecnologia',
  ];

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  List<Edital> get _editaisFiltrados {
    final termo = _termoBusca.trim().toLowerCase();
    final filtrados = TelaBuscarEditais.editais.where((edital) {
      final bateTermo = termo.isEmpty ||
          edital.titulo.toLowerCase().contains(termo) ||
          edital.orgao.toLowerCase().contains(termo) ||
          edital.objeto.toLowerCase().contains(termo) ||
          edital.cnaeCompativel.toLowerCase().contains(termo) ||
          edital.valor.toLowerCase().contains(termo);

      final bateTag =
          _tagFiltroAtiva == null || edital.tags.contains(_tagFiltroAtiva);

      return bateTermo && bateTag;
    }).toList();

    if (_ordenarPorMatch) {
      filtrados.sort(
        (a, b) => b.scoreCompatibilidade.compareTo(a.scoreCompatibilidade),
      );
    }
    return filtrados;
  }

  @override
  Widget build(BuildContext context) {
    final editaisExibidos = _editaisFiltrados;
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho da tela de busca
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buscar Editais',
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
                    'Oportunidades ranqueadas automaticamente pelo perfil e CNAE da sua empresa.',
                    style: TextStyle(fontSize: 14, color: corSubtexto),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.verified_rounded,
                      size: 16,
                      color: Color(0xFF059669),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Perfil CNAE Ativo: 8121-4/00 & 6202-3/00',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Barra de busca interativa
          Container(
            decoration: BoxDecoration(
              color: corCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: corBorda),
            ),
            child: TextField(
              controller: _buscaController,
              style: TextStyle(color: corTexto),
              onChanged: (valor) {
                setState(() {
                  _termoBusca = valor;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por objeto, órgão ou CNAE...',
                hintStyle: TextStyle(color: corSubtexto),
                prefixIcon: Icon(Icons.search, color: corSubtexto),
                suffixIcon: _termoBusca.isNotEmpty
                    ? IconButton(
                        tooltip: 'Limpar busca',
                        icon: Icon(Icons.clear, color: corSubtexto),
                        onPressed: () {
                          _buscaController.clear();
                          setState(() {
                            _termoBusca = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Linha de filtros rápidos
          Wrap(
            spacing: 12,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final tag in _tagsDisponiveis) _buildFiltroTag(tag),
              if (_tagFiltroAtiva != null || _termoBusca.isNotEmpty)
                TextButton.icon(
                  onPressed: () {
                    _buscaController.clear();
                    setState(() {
                      _termoBusca = '';
                      _tagFiltroAtiva = null;
                    });
                  },
                  icon: const Icon(Icons.filter_alt_off_outlined, size: 16),
                  label: const Text('Mostrar todos'),
                  style: TextButton.styleFrom(
                    foregroundColor: corSubtexto,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),

          // Lista de editais filtrados
          Expanded(
            child: editaisExibidos.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: corSubtexto,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Nenhum edital encontrado para esse filtro.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: corTexto,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            _buscaController.clear();
                            setState(() {
                              _termoBusca = '';
                              _tagFiltroAtiva = null;
                            });
                          },
                          child: const Text('Limpar filtros de busca'),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: editaisExibidos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final edital = editaisExibidos[index];
                      final isTecnologia = edital.tags.contains('Tecnologia');
                      return _buildCardEdital(
                        context: context,
                        icone: isTecnologia
                            ? Icons.business
                            : Icons.account_balance,
                        corIcone:
                            isTecnologia ? Colors.redAccent : Colors.orange,
                        edital: edital,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroTag(String texto) {
    final bool selecionada = _tagFiltroAtiva == texto;
    return InkWell(
      onTap: () {
        setState(() {
          _tagFiltroAtiva = selecionada ? null : texto;
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selecionada
              ? const Color(0xFF2563EB)
              : const Color(0xFFEFF6FF),
          border: Border.all(
            color: selecionada
                ? const Color(0xFF1D4ED8)
                : const Color(0xFFBFDBFE),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              texto,
              style: TextStyle(
                color: selecionada ? Colors.white : const Color(0xFF2563EB),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              selecionada ? Icons.close : Icons.filter_list_rounded,
              size: 14,
              color: selecionada ? Colors.white : const Color(0xFF2563EB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeloCompatibilidade(Edital edital) {
    final int score = edital.scoreCompatibilidade;
    final bool altoMatch = score >= 85;

    final Color corFundo =
        altoMatch ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF);
    final Color corBorda =
        altoMatch ? const Color(0xFFA7F3D0) : const Color(0xFFBFDBFE);
    final Color corTexto =
        altoMatch ? const Color(0xFF059669) : const Color(0xFF2563EB);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: corBorda),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            altoMatch ? Icons.auto_awesome_rounded : Icons.insights_rounded,
            size: 15,
            color: corTexto,
          ),
          const SizedBox(width: 6),
          Text(
            '$score% compatível com seu CNAE',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: corTexto,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardEdital({
    required BuildContext context,
    required IconData icone,
    required Color corIcone,
    required Edital edital,
  }) {
    final titulo = '${edital.orgao} - ${edital.titulo}';
    final objeto = edital.objeto;
    final valor = edital.valor;
    final bool jaNoFunil =
        widget.idsNoFunil.contains(edital.identificadorUnico);
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: corCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: corIcone.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icone, color: corIcone, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                    _buildSeloCompatibilidade(edital),
                    if (jaNoFunil)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: TemaApp.corSuperficieSecundaria(context),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: corBorda),
                        ),
                        child: Text(
                          'No Funil',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: corSubtexto,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  edital.cnaeCompativel,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: corSubtexto,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  objeto,
                  style: TextStyle(fontSize: 15, color: corSubtexto),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 24,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Valor Estimado:',
                          style: TextStyle(fontSize: 13, color: corSubtexto),
                        ),
                        Text(
                          valor,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: TemaApp.corSuperficieSecundaria(context),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: corBorda),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.compare_arrows_rounded,
                            size: 15,
                            color: Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Média PNCP: ${edital.mediaHistoricaPncp} (${edital.comparativoPrecoTexto})',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: corTexto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.more_horiz, color: corSubtexto),
              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () => widget.onAnalisar(edital),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Analisar Edital',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
