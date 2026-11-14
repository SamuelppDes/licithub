import 'package:flutter/material.dart';
import '../configuracoes/tema_app.dart';
import 'logo_licithub.dart';

/// Barra lateral (Sidebar) de navegação do painel interno do LicitHub,
/// incluindo Configurações/Usabilidade, alternância rápida de Modo Noturno/Claro,
/// perfil da empresa e botão de Sair (Logout).
class MenuLateral extends StatelessWidget {
  final int indiceSelecionado;
  final bool exibindoDetalhes;
  final ValueChanged<int> aoSelecionarItem;
  final VoidCallback? aoSair;

  const MenuLateral({
    super.key,
    required this.indiceSelecionado,
    required this.exibindoDetalhes,
    required this.aoSelecionarItem,
    this.aoSair,
  });

  void _executarLogout(BuildContext context) {
    if (aoSair != null) {
      aoSair!();
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 250,
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.only(top: 30, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: LogoLicitHub(
              primaryColor: Colors.white,
              subtitleColor: Color(0xFFD6E6FF),
              titleFontSize: 25,
              subtitleFontSize: 9.0,
            ),
          ),
          const SizedBox(height: 28),
          _construirItemMenu(0, Icons.home_outlined, 'Dashboard'),
          _construirItemMenu(1, Icons.search, 'Buscar Editais'),
          _construirItemMenu(2, Icons.filter_alt_outlined, 'Funil'),
          _construirItemMenu(3, Icons.description_outlined, 'Documentos'),
          _construirItemMenu(4, Icons.settings_outlined, 'Configurações'),
          const Spacer(),

          // Rodapé da Sidebar: Alternância rápida de Tema + Perfil da Empresa + Botão de Sair
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.domain_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Silva Soluções EPP',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'CNPJ 12.345.678/0001-90',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Colors.white12),
                  const SizedBox(height: 8),

                  // Botão rápido de Modo Noturno / Modo Claro
                  InkWell(
                    onTap: TemaApp.alternarModoTema,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isDark
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                                color: isDark
                                    ? const Color(0xFFFBBF24)
                                    : const Color(0xFF93C5FD),
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isDark ? 'Modo Noturno' : 'Modo Claro',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              isDark ? 'ON' : 'OFF',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFFFBBF24)
                                    : Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Divider(height: 1, color: Colors.white12),
                  const SizedBox(height: 8),

                  // Botão Sair
                  InkWell(
                    onTap: () => _executarLogout(context),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 4,
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFF87171),
                            size: 18,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Sair',
                            style: TextStyle(
                              color: Color(0xFFF87171),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirItemMenu(int index, IconData icon, String title) {
    final isSelected = indiceSelecionado == index && !exibindoDetalhes;
    return InkWell(
      onTap: () => aoSelecionarItem(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white60,
              size: 22,
            ),
            const SizedBox(width: 16),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Colors.white : Colors.white60,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
