import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import '../models/contato.dart';
import '../provider/contatos_provider.dart';

    List<String> meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

class Aniversariantes extends StatelessWidget {
  static const routeName = 'Aniversariantes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Lista de Aniversariantes')),body: SingleChildScrollView(child: 
                    Consumer<ContatosProvider>(
                      builder: (ctx, contas, _) => GroupedListView<Contato, int>(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          elements: contas.aniversariantes,
          groupBy: (element) => DateTime.parse(element.aniversario).month,
          groupSeparatorBuilder: (group_by_value) =>
              Text(meses[group_by_value - 1]),
          itemBuilder: (context, element) => buildListTile(element),
          groupComparator: (item1, item2) => item1.compareTo(item2),
          useStickyGroupSeparators: true,
          floatingHeader: true,
        ),
        ),
      )
    );    
  }

  ListTile buildListTile(Contato contato) {
    return ListTile(
        leading: CircleAvatar(),
        title: Text(contato.nome),
        subtitle: Text(contato.telefone),
    );
  }
}