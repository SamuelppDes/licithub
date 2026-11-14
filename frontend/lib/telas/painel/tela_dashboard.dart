import 'package:flutter/material.dart';
import '../../configuracoes/tema_app.dart';
import '../../servicos/api_servico.dart';
import '../../servicos/formatadores.dart';

typedef DashboardPage = TelaDashboard;

/// Aba 1: Dashboard de indicadores (KPIs), alertas e gráficos conectado à API C#
/// (com suporte completo a Modo Claro / Modo Noturno).
class TelaDashboard extends StatefulWidget {
  const TelaDashboard({super.key});

  @override
  State<TelaDashboard> createState() => _TelaDashboardState();
}

class _TelaDashboardState extends State<TelaDashboard> {
  late Future<Map<String, dynamic>> _dadosFuture;

  @override
  void initState() {
    super.initState();
    _dadosFuture = buscarDadosDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return FutureBuilder<Map<String, dynamic>>(
      future: _dadosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final bool usandoFallbackOffline = snapshot.hasError;
        final Map<String, dynamic> dados = snapshot.hasData
            ? snapshot.data!
            : <String, dynamic>{
                'licitacoesAtivas': 12,
                'disputasGanhas': 450000,
                'alerta':
                    'Você tem 3 novos matches de editais hoje  •  Certidão Federal vence em 5 dias!',
              };

        final licitacoesAtivas = dados['licitacoesAtivas']?.toString() ?? '12';
        final disputasGanhas = formatarMoeda(dados['disputasGanhas'] ?? 450000);
        final mensagemAlerta =
            dados['alerta']?.toString() ??
            'Você tem 3 novos matches de editais hoje  •  Certidão Federal vence em 5 dias!';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Olá, Carlos Eduardo!',
                    style: TextStyle(
                      fontFamily: TemaApp.fonteSerifada,
                      fontFamilyFallback: TemaApp.fallbackSerifada,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: corTexto,
                    ),
                  ),
                  Row(
                    children: [
                      if (usandoFallbackOffline)
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _dadosFuture = buscarDadosDashboard();
                              });
                            },
                            icon: const Icon(Icons.sync, size: 16),
                            label: const Text('Sincronizar API'),
                            style: TextButton.styleFrom(
                              foregroundColor: corSubtexto,
                            ),
                          ),
                        ),
                      Icon(
                        Icons.notifications_none,
                        color: corSubtexto,
                      ),
                      const SizedBox(width: 16),
                      CircleAvatar(
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF422006)
                      : const Color(0xFFFEF9C3),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFFA16207)
                        : const Color(0xFFFDE047),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: isDark
                          ? const Color(0xFFFACC15)
                          : const Color(0xFFCA8A04),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        mensagemAlerta,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFFFEF08A)
                              : const Color(0xFF854D0E),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  _buildKpiCard(
                    context,
                    'Licitações Ativas:',
                    licitacoesAtivas,
                  ),
                  const SizedBox(width: 24),
                  _buildKpiCard(context, 'Disputas Ganhas:', disputasGanhas),
                ],
              ),
              const SizedBox(height: 32),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: corCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: corBorda),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Volume das licitações',
                            style: TextStyle(
                              fontFamily: TemaApp.fonteSerifada,
                              fontFamilyFallback: TemaApp.fallbackSerifada,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: corTexto,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 240,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildBarraGrafico(context, 100, 'Nov'),
                                _buildBarraGrafico(context, 160, 'Dez'),
                                _buildBarraGrafico(context, 130, 'Jan'),
                                _buildBarraGrafico(context, 110, 'Fev'),
                                _buildBarraGrafico(context, 150, 'Mar'),
                                _buildBarraGrafico(context, 190, 'Abr'),
                                _buildBarraGrafico(context, 120, 'Mai'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: corCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: corBorda),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Últimas Oportunidades',
                            style: TextStyle(
                              fontFamily: TemaApp.fonteSerifada,
                              fontFamilyFallback: TemaApp.fallbackSerifada,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: corTexto,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildListaOportunidade(
                            context,
                            Icons.account_balance,
                            Colors.orange,
                            'Prefeitura de SP',
                            'Pregão 48/2026',
                          ),
                          Divider(height: 32, color: corBorda),
                          _buildListaOportunidade(
                            context,
                            Icons.local_hospital,
                            Colors.teal,
                            'Hospital das Clínicas',
                            'Pregão 15/2026',
                            tag: '75% completo',
                          ),
                          Divider(height: 32, color: corBorda),
                          _buildListaOportunidade(
                            context,
                            Icons.account_balance,
                            Colors.blue,
                            'Governo do Estado de SP',
                            'Pregão 12/2026',
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
      },
    );
  }

  Widget _buildKpiCard(BuildContext context, String titulo, String valor) {
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: corCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: corBorda),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                color: corSubtexto,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              valor,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: corTexto,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarraGrafico(BuildContext context, double altura, String mes) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 32,
          height: altura,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          mes,
          style: TextStyle(
            color: TemaApp.corTextoSecundario(context),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildListaOportunidade(
    BuildContext context,
    IconData icone,
    Color corIcone,
    String orgao,
    String pregao, {
    String? tag,
  }) {
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: corIcone.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icone, color: corIcone, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orgao,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: corTexto,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    pregao,
                    style: TextStyle(color: corSubtexto, fontSize: 13),
                  ),
                  if (tag != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        Icon(Icons.chevron_right, color: corSubtexto),
      ],
    );
  }
}
