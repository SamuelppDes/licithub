/// Etapas do quadro Kanban no Funil de Disputa.
enum EtapaFunil {
  mapeados('Mapeados'),
  documentacao('Documentação'),
  prontoParaLance('Pronto para Lance'),
  resultados('Resultados');

  final String rotulo;
  const EtapaFunil(this.rotulo);
}

/// Representa um card dentro do Funil de Disputa (Kanban).
class ItemFunil {
  final String id;
  final String titulo;
  final String valor;
  final EtapaFunil etapa;
  final int? scoreCompatibilidade;
  final double? progresso;
  final String? textoProgresso;
  final String? tagResultado;

  const ItemFunil({
    required this.id,
    required this.titulo,
    required this.valor,
    required this.etapa,
    this.scoreCompatibilidade,
    this.progresso,
    this.textoProgresso,
    this.tagResultado,
  });

  ItemFunil copyWith({
    String? id,
    String? titulo,
    String? valor,
    EtapaFunil? etapa,
    int? scoreCompatibilidade,
    double? progresso,
    String? textoProgresso,
    String? tagResultado,
  }) {
    return ItemFunil(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      valor: valor ?? this.valor,
      etapa: etapa ?? this.etapa,
      scoreCompatibilidade: scoreCompatibilidade ?? this.scoreCompatibilidade,
      progresso: progresso ?? this.progresso,
      textoProgresso: textoProgresso ?? this.textoProgresso,
      tagResultado: tagResultado ?? this.tagResultado,
    );
  }
}

/// Modelo de dados que representa um Edital de licitação pública.
class Edital {
  final String titulo;
  final String orgao;
  final String objeto;
  final String valor;
  final List<String> itens;
  final int scoreCompatibilidade;
  final String cnaeCompativel;
  final String mediaHistoricaPncp;
  final double percentualDiferencaMedia;
  final String comparativoPrecoTexto;
  final String? resumoFunil;
  final String? valorCurto;
  final bool exigeAtestadoTecnico;
  final bool exigeVistoriaPrevia;
  final String capitalSocialMinimo;
  final List<String> tags;

  const Edital({
    required this.titulo,
    required this.orgao,
    required this.objeto,
    required this.valor,
    required this.itens,
    this.scoreCompatibilidade = 94,
    this.cnaeCompativel = 'CNAE 8121-4/00',
    this.mediaHistoricaPncp = 'R\$ 223.200,00',
    this.percentualDiferencaMedia = 12.0,
    this.comparativoPrecoTexto = '12% acima da média praticada em SP',
    this.resumoFunil,
    this.valorCurto,
    this.exigeAtestadoTecnico = true,
    this.exigeVistoriaPrevia = false,
    this.capitalSocialMinimo = 'R\$ 25.000',
    this.tags = const ['São Paulo', '> R\$ 100k'],
  });

  String get identificadorUnico => '$orgao|$titulo';

  String get tituloCompactoFunil => resumoFunil ?? '$orgao - $titulo';

  String get valorCompactoFunil => valorCurto ?? valor;
}
