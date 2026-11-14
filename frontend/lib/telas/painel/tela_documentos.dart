import 'package:flutter/material.dart';
import '../../configuracoes/tema_app.dart';

typedef DocumentosPage = TelaDocumentos;

/// Status possíveis de uma certidão ou documento de habilitação.
enum StatusCertidao {
  valida('Válida'),
  venceEmBreve('Vence em 5 dias'),
  vencida('Vencida');

  final String rotulo;
  const StatusCertidao(this.rotulo);
}

/// Modelo que representa um item do Checklist de Habilitação da empresa.
class CertidaoEmpresa {
  final String id;
  final String nome;
  final String orgaoEmissor;
  final String categoria;
  final String dataEmissao;
  final String dataValidade;
  final StatusCertidao status;
  final String codigoAutenticacao;

  const CertidaoEmpresa({
    required this.id,
    required this.nome,
    required this.orgaoEmissor,
    required this.categoria,
    required this.dataEmissao,
    required this.dataValidade,
    required this.status,
    required this.codigoAutenticacao,
  });

  CertidaoEmpresa copyWith({
    String? dataEmissao,
    String? dataValidade,
    StatusCertidao? status,
  }) {
    return CertidaoEmpresa(
      id: id,
      nome: nome,
      orgaoEmissor: orgaoEmissor,
      categoria: categoria,
      dataEmissao: dataEmissao ?? this.dataEmissao,
      dataValidade: dataValidade ?? this.dataValidade,
      status: status ?? this.status,
      codigoAutenticacao: codigoAutenticacao,
    );
  }
}

/// Aba 4: Painel de Certidões e Checklist de Habilitação da Empresa.
class TelaDocumentos extends StatefulWidget {
  const TelaDocumentos({super.key});

  @override
  State<TelaDocumentos> createState() => _TelaDocumentosState();
}

class _TelaDocumentosState extends State<TelaDocumentos> {
  StatusCertidao? _filtroStatus;

  late List<CertidaoEmpresa> _certidoes;

  @override
  void initState() {
    super.initState();
    _certidoes = [
      const CertidaoEmpresa(
        id: 'cnd_federal',
        nome: 'CND Federal (Débitos Relativos a Créditos Tributários Federais)',
        orgaoEmissor: 'Receita Federal / PGFN',
        categoria: 'Regularidade Fiscal',
        dataEmissao: '22/05/2026',
        dataValidade: '18/11/2026',
        status: StatusCertidao.venceEmBreve,
        codigoAutenticacao: 'RFB-9941.220A.771C.8832',
      ),
      const CertidaoEmpresa(
        id: 'fgts_crf',
        nome: 'Certificado de Regularidade do FGTS (CRF)',
        orgaoEmissor: 'Caixa Econômica Federal',
        categoria: 'Regularidade Fiscal e Social',
        dataEmissao: '01/11/2026',
        dataValidade: '30/11/2026',
        status: StatusCertidao.valida,
        codigoAutenticacao: 'CEF-202611010048921',
      ),
      const CertidaoEmpresa(
        id: 'cndt_trabalhista',
        nome: 'Certidão Negativa de Débitos Trabalhistas (CNDT)',
        orgaoEmissor: 'Tribunal Superior do Trabalho (TST)',
        categoria: 'Regularidade Trabalhista',
        dataEmissao: '14/08/2026',
        dataValidade: '10/02/2027',
        status: StatusCertidao.valida,
        codigoAutenticacao: 'TST-88219044-2026',
      ),
      const CertidaoEmpresa(
        id: 'contrato_social',
        nome: 'Contrato Social Consolidado e Cartão CNPJ',
        orgaoEmissor: 'Junta Comercial do Estado de São Paulo (JUCESP)',
        categoria: 'Habilitação Jurídica',
        dataEmissao: '10/02/2025',
        dataValidade: 'Vigente',
        status: StatusCertidao.valida,
        codigoAutenticacao: 'NIRE-35.299.184.201',
      ),
      const CertidaoEmpresa(
        id: 'atestado_tecnico',
        nome: 'Atestado de Capacidade Técnica Operacional (CAT)',
        orgaoEmissor: 'Acervo Técnico Registrado',
        categoria: 'Qualificação Técnica',
        dataEmissao: '05/04/2026',
        dataValidade: 'Permanente',
        status: StatusCertidao.valida,
        codigoAutenticacao: 'CAT-SP-2026-0491',
      ),
      const CertidaoEmpresa(
        id: 'cnd_estadual_municipal',
        nome: 'Certidão Negativa de Tributos Mobiliários (ISS / ICMS)',
        orgaoEmissor: 'Secretaria da Fazenda Municipal / Estadual - SP',
        categoria: 'Regularidade Fiscal',
        dataEmissao: '01/08/2026',
        dataValidade: '01/11/2026',
        status: StatusCertidao.vencida,
        codigoAutenticacao: 'SEFAZ-SP-4410982',
      ),
    ];
  }

  List<CertidaoEmpresa> get _certidoesFiltradas {
    if (_filtroStatus == null) return _certidoes;
    return _certidoes.where((c) => c.status == _filtroStatus).toList();
  }

  int _contarPorStatus(StatusCertidao status) =>
      _certidoes.where((c) => c.status == status).length;

  void _renovarCertidao(CertidaoEmpresa certidao) {
    setState(() {
      final idx = _certidoes.indexWhere((c) => c.id == certidao.id);
      if (idx != -1) {
        _certidoes[idx] = _certidoes[idx].copyWith(
          dataEmissao: '13/11/2026',
          dataValidade: '12/05/2027',
          status: StatusCertidao.valida,
        );
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        content: Text(
          '${certidao.nome} revalidada com sucesso até 12/05/2027!',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalValidas = _contarPorStatus(StatusCertidao.valida);
    final totalVencendo = _contarPorStatus(StatusCertidao.venceEmBreve);
    final totalVencidas = _contarPorStatus(StatusCertidao.vencida);
    final percentualApto =
        ((totalValidas / _certidoes.length) * 100).round();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Checklist de Habilitação e Certidões',
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
                    'Controle centralizado de certidões negativas, FGTS, trabalhista e documentos societários.',
                    style: TextStyle(fontSize: 14, color: corSubtexto),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: percentualApto == 100
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: percentualApto == 100
                        ? const Color(0xFFA7F3D0)
                        : const Color(0xFFBFDBFE),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      percentualApto == 100
                          ? Icons.verified_user_rounded
                          : Icons.shield_outlined,
                      size: 18,
                      color: percentualApto == 100
                          ? const Color(0xFF059669)
                          : const Color(0xFF004CA3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Índice de Habilitação: $percentualApto% regular',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: percentualApto == 100
                            ? const Color(0xFF059669)
                            : const Color(0xFF004CA3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Alerta conectado ao Dashboard ("Certidão Federal vence em 5 dias")
          if (totalVencendo > 0) ...[
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
                borderRadius: BorderRadius.circular(10),
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
                      'Alerta de Prazo: Sua Certidão Federal (CND Receita Federal / PGFN) vence em 5 dias! Renove agora para não bloquear sua participação no Pregão 45/2026.',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFFFEF08A)
                            : const Color(0xFF854D0E),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () {
                      final cnd = _certidoes.firstWhere(
                        (c) => c.status == StatusCertidao.venceEmBreve,
                      );
                      _renovarCertidao(cnd);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFCA8A04),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                    child: const Text(
                      'Revalidar CND Federal',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Cards de resumo de status
          Row(
            children: [
              _buildCardResumoStatus(
                context: context,
                titulo: 'Certidões Válidas',
                quantidade: totalValidas,
                cor: const Color(0xFF10B981),
                corFundo: const Color(0xFFECFDF5),
                icone: Icons.check_circle_outline_rounded,
              ),
              const SizedBox(width: 20),
              _buildCardResumoStatus(
                context: context,
                titulo: 'Vence em 5 dias',
                quantidade: totalVencendo,
                cor: const Color(0xFFD97706),
                corFundo: const Color(0xFFFEF3C7),
                icone: Icons.schedule_rounded,
              ),
              const SizedBox(width: 20),
              _buildCardResumoStatus(
                context: context,
                titulo: 'Vencidas / Pendentes',
                quantidade: totalVencidas,
                cor: const Color(0xFFEF4444),
                corFundo: const Color(0xFFFEE2E2),
                icone: Icons.error_outline_rounded,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Filtros de status
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildChipFiltro(context, null, 'Todas (${_certidoes.length})'),
              _buildChipFiltro(
                context,
                StatusCertidao.valida,
                'Válida ($totalValidas)',
              ),
              _buildChipFiltro(
                context,
                StatusCertidao.venceEmBreve,
                'Vence em 5 dias ($totalVencendo)',
              ),
              _buildChipFiltro(
                context,
                StatusCertidao.vencida,
                'Vencida ($totalVencidas)',
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Lista de certidões
          for (final certidao in _certidoesFiltradas) ...[
            _buildCertidaoItemCard(context, certidao),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  Widget _buildCardResumoStatus({
    required BuildContext context,
    required String titulo,
    required int quantidade,
    required Color cor,
    required Color corFundo,
    required IconData icone,
  }) {
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: corCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: corBorda),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: corFundo,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icone, color: cor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: corSubtexto,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$quantidade',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: cor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipFiltro(
    BuildContext context,
    StatusCertidao? status,
    String label,
  ) {
    final bool selecionado = _filtroStatus == status;
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corTexto = TemaApp.corTextoPrincipal(context);

    return InkWell(
      onTap: () {
        setState(() {
          _filtroStatus = status;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? const Color(0xFF2563EB) : corCard,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selecionado ? const Color(0xFF2563EB) : corBorda,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selecionado ? Colors.white : corTexto,
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeStatus(StatusCertidao status) {
    late final Color corTexto;
    late final Color corFundo;
    late final Color corBorda;
    late final IconData icone;

    switch (status) {
      case StatusCertidao.valida:
        corTexto = const Color(0xFF059669);
        corFundo = const Color(0xFFECFDF5);
        corBorda = const Color(0xFFA7F3D0);
        icone = Icons.check_circle_rounded;
      case StatusCertidao.venceEmBreve:
        corTexto = const Color(0xFFB45309);
        corFundo = const Color(0xFFFEF3C7);
        corBorda = const Color(0xFFFDE68A);
        icone = Icons.warning_amber_rounded;
      case StatusCertidao.vencida:
        corTexto = const Color(0xFFDC2626);
        corFundo = const Color(0xFFFEE2E2);
        corBorda = const Color(0xFFFECACA);
        icone = Icons.cancel_rounded;
    }

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
          Icon(icone, size: 15, color: corTexto),
          const SizedBox(width: 6),
          Text(
            status.rotulo,
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

  Widget _buildCertidaoItemCard(BuildContext context, CertidaoEmpresa certidao) {
    final bool precisaRenovar = certidao.status != StatusCertidao.valida;
    final Color corCard = TemaApp.corSuperficieCard(context);
    final Color corBorda = TemaApp.corBordaCard(context);
    final Color corTexto = TemaApp.corTextoPrincipal(context);
    final Color corSubtexto = TemaApp.corTextoSecundario(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: corCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: certidao.status == StatusCertidao.vencida
              ? const Color(0xFFFECACA)
              : certidao.status == StatusCertidao.venceEmBreve
                  ? const Color(0xFFFDE68A)
                  : corBorda,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: TemaApp.corSuperficieSecundaria(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: Color(0xFF2563EB),
              size: 26,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      certidao.nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: corTexto,
                      ),
                    ),
                    _buildBadgeStatus(certidao.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${certidao.categoria} • Órgão: ${certidao.orgaoEmissor}',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: corSubtexto,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Emissão: ${certidao.dataEmissao}   |   Validade: ${certidao.dataValidade}   |   Autenticação: ${certidao.codigoAutenticacao}',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: corSubtexto,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (precisaRenovar)
            ElevatedButton.icon(
              onPressed: () => _renovarCertidao(certidao),
              icon: const Icon(Icons.autorenew_rounded, size: 17),
              label: const Text('Renovar Agora'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Certidão ${certidao.codigoAutenticacao} verificada e pronta para envio.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.download_outlined, size: 17),
              label: const Text('Baixar PDF'),
              style: OutlinedButton.styleFrom(
                foregroundColor: corTexto,
                side: BorderSide(color: corBorda),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
