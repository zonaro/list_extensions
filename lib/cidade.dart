import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:innerlibs/innerlibs.dart';

/// Classe que representa uma cidade.
///
/// Esta classe contém informações sobre uma cidade, como se é capital,
/// o código IBGE, o código SIAFI, o DDD, o fuso horário e o estado ao qual
/// a cidade pertence.
class Cidade implements Comparable<Cidade> {
  /// O nome da cidade.
  final String nome;

  /// Indica se a cidade é capital do estado.
  final bool capital;

  /// O código IBGE da cidade.
  final int ibge;

  /// O código SIAFI da cidade.
  final int siafi;

  /// O DDD da cidade.
  final int ddd;

  /// O fuso horário da cidade.
  final String timeZone;

  /// O estado ao qual a cidade pertence.
  Estado get estado => Estado.fromUForIbge(ibge);

  /// A região do estado ao qual a cidade pertence.
  Regiao get regiao => estado.regiao;

  /// Obtém uma lista de todas as cidades.
  static Future<List<Cidade>> get pegarCidades async {
    final data = await rootBundle.loadString('packages/innerlibs/lib/brasil.json', cache: true);
    var items = JsonTable.from(jsonDecode(data));
    List<Cidade> cidades = [];
    for (var json in items) {
      cidades.add(Cidade._(json['Nome'], json['Capital'], json['IBGE'], json['SIAFI'], json['DDD'], json['TimeZone']));
    }
    return cidades..sort((a, b) => a.nome.compareTo(b.nome));
  }

  /// Obtém uma cidade a partir do nome, UF ou IBGE e estado.
  ///
  /// Parâmetros:
  /// - [nomeCidadeOuIBGE]: O nome da cidade, UF ou IBGE.
  /// - [nomeOuUFOuIBGE]: O nome do estado, UF ou IBGE (opcional).
  static Future<Cidade?> pegar(dynamic nomeCidadeOuIBGE, [dynamic nomeOuUFOuIBGE]) async => await Brasil.pegarCidade(nomeCidadeOuIBGE, nomeOuUFOuIBGE);

  /// Pesquisa uma cidade no Brasil todo ou em algum estado especifico se [nomeOuUFOuIBGE] for especificado.
  ///
  /// Parâmetros:
  /// - [nomeCidadeOuIBGE]: O nome da cidade, UF ou IBGE.
  /// - [nomeOuUFOuIBGE]: O nome da cidade, UF ou IBGE (opcional).
  static Future<Iterable<Cidade>> pesquisar(String nomeCidadeOuIBGE, [String nomeOuUFOuIBGE = ""]) async => await Brasil.pesquisarCidade(nomeCidadeOuIBGE, nomeOuUFOuIBGE);

  @override
  String toString() => nome;

  Cidade._(this.nome, this.capital, this.ibge, this.siafi, this.ddd, this.timeZone);

  /// Converte a instância de Cidade para um mapa JSON.
  Map<String, dynamic> toJson() => {'Nome': nome, 'Capital': capital, 'IBGE': ibge, 'SIAFI': siafi, 'DDD': ddd, 'TimeZone': timeZone, "Estado": estado.toJson()};

  @override
  bool operator ==(Object other) {
    if (other is Cidade) {
      return ibge == other.ibge;
    }

    if (other is Estado) {
      return estado.ibge == other.ibge;
    }

    if (other is num) {
      return ibge == other.toDouble().floor();
    }
    if (other is string) {
      if (other.isNumericOnly) {
        return ibge == int.parse(other);
      } else {
        return nome.flatEqual(other);
      }
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(ibge, 0);

  @override
  int compareTo(other) => nome.compareTo(other.nome);
}