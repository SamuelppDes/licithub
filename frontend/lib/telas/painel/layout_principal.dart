import 'package:flutter/material.dart';
import '../../componentes/menu_lateral.dart';
import '../../configuracoes/tema_app.dart';
import '../../modelos/edital.dart';
import 'tela_buscar_editais.dart';
import 'tela_configuracoes.dart';
import 'tela_dashboard.dart';
import 'tela_detalhes_edital.dart';
import 'tela_documentos.dart';
import 'tela_funil.dart';

typedef MainLayout = LayoutPrincipal;

/// Estrutura principal do painel interno (Menu Lateral + Navegação em Abas + Estado compartilhado do Funil).
class LayoutPrincipal extends StatefulWidget {
  const LayoutPrincipal({super.key});

  @override
  State<LayoutPrincipal> createState() => _LayoutPrincipalState();
}

class _LayoutPrincipalState extends State<LayoutPrincipal> {
  int _selectedIndex = 0;
  Edital? _editalSelecionado;
  late final List<ItemFunil> _itensFunil;

  @override
  void initState() {
    super.initState();
    _itensFunil = List<ItemFunil>.from(TelaFunil.obterItensIniciais());
  }

  Set<String> get _idsNoFunil => _itensFunil.map((e) => e.id).toSet();

  void _adicionarEditalAoFunil(Edital edital) {
    setState(() {
      final id = edital.identificadorUnico;
      final indiceExistente = _itensFunil.indexWhere((item) => item.id == id);

      if (indiceExistente != -1) {
        final existente = _itensFunil.removeAt(indiceExistente);
        _itensFunil.insert(
          0,
          existente.copyWith(etapa: EtapaFunil.mapeados),
        );
      } else {
        _itensFunil.insert(
          0,
          ItemFunil(
            id: id,
            titulo: edital.tituloCompactoFunil,
            valor: edital.valorCompactoFunil,
            etapa: EtapaFunil.mapeados,
            scoreCompatibilidade: edital.scoreCompatibilidade,
          ),
        );
      }
    });
  }

  void _moverCardFunil(String id, EtapaFunil novaEtapa) {
    setState(() {
      final idx = _itensFunil.indexWhere((item) => item.id == id);
      if (idx == -1) return;

      var item = _itensFunil[idx];
      if (novaEtapa == EtapaFunil.documentacao) {
        item = item.copyWith(
          etapa: novaEtapa,
          progresso: item.progresso ?? 0.75,
          textoProgresso: item.textoProgresso ?? '75% completo',
        );
      } else if (novaEtapa == EtapaFunil.resultados) {
        item = item.copyWith(
          etapa: novaEtapa,
          tagResultado: item.tagResultado ?? '[Ganho]',
        );
      } else {
        item = item.copyWith(etapa: novaEtapa);
      }
      _itensFunil[idx] = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    final idsFunil = _idsNoFunil;

    final List<Widget> pages = [
      const TelaDashboard(),
      TelaBuscarEditais(
        idsNoFunil: idsFunil,
        onAdicionarAoFunil: _adicionarEditalAoFunil,
        onAnalisar: (edital) {
          setState(() {
            _editalSelecionado = edital;
          });
        },
      ),
      TelaFunil(
        itens: _itensFunil,
        onMoverCard: _moverCardFunil,
      ),
      const TelaDocumentos(),
      const TelaConfiguracoes(),
    ];

    return Scaffold(
      body: Row(
        children: [
          // Menu Lateral (Sidebar)
          MenuLateral(
            indiceSelecionado: _selectedIndex,
            exibindoDetalhes: _editalSelecionado != null,
            aoSelecionarItem: (index) {
              setState(() {
                _selectedIndex = index;
                _editalSelecionado = null;
              });
            },
          ),

          // Área Principal de Conteúdo (suporta Modo Claro e Modo Noturno)
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: TemaApp.corFundoPainel(context),
              child: Stack(
                children: [
                  Offstage(
                    offstage: _editalSelecionado != null,
                    child: IndexedStack(index: _selectedIndex, children: pages),
                  ),
                  if (_editalSelecionado != null)
                    TelaDetalhesEdital(
                      edital: _editalSelecionado!,
                      jaNoFunil: idsFunil.contains(
                        _editalSelecionado!.identificadorUnico,
                      ),
                      onAdicionarAoFunil: _adicionarEditalAoFunil,
                      onIrParaFunil: () {
                        setState(() {
                          _editalSelecionado = null;
                          _selectedIndex = 2;
                        });
                      },
                      onBack: () {
                        setState(() {
                          _editalSelecionado = null;
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
