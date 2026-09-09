class Refeicao {
  final String horario;
  final String pratoPrincipal;
  final String acompanhamentoPrato;
  final String opcaoVegetariana;
  final String descricaoVegetariana;
  final String base;
  final String descricaoBase;
  final String salada;
  final String sobremesa;
  final String suco;

  const Refeicao({
    required this.horario,
    required this.pratoPrincipal,
    required this.acompanhamentoPrato,
    required this.opcaoVegetariana,
    required this.descricaoVegetariana,
    required this.base,
    required this.descricaoBase,
    required this.salada,
    required this.sobremesa,
    required this.suco,
  });

  String get opcaoVeg => opcaoVegetariana;
  String get acompanhamento => acompanhamentoPrato;
}

class CardapioDia {
  final String id;
  final String diaSemana;
  final String dataAbreviada;
  final String dataCompleta;
  final Refeicao almoco;
  final Refeicao? janta;

  const CardapioDia({
    required this.id,
    required this.diaSemana,
    required this.dataAbreviada,
    required this.dataCompleta,
    required this.almoco,
    this.janta,
  });

  bool get temJantar => janta != null;
  Refeicao? get jantar => janta;
  String get diaAbreviado => dataAbreviada;
  String get dataFormatada => dataCompleta;
}
