import 'dart:io';
import 'package:agenda_de_contatos/imagePicker/pick_user_image.dart';
import 'package:agenda_de_contatos/models/contato.dart';
import 'package:agenda_de_contatos/provider/contatos_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:via_cep_flutter/via_cep_flutter.dart';

class CriadorContato extends StatefulWidget {
  final Contato c;

  CriadorContato({this.c});

  @override
  _CriadorContato createState() => _CriadorContato();
}

class _CriadorContato extends State<CriadorContato> {
  final GlobalKey<FormState> globalKey = GlobalKey();

  TextEditingController cepIdentifier = TextEditingController();
  String nome = '';
  String email = '';
  String endereco = '';
  String cep = '';
  String telefone = '';
  DateTime aniversario;
  File imagem;
  bool atualizar = false;

  void initState() {
    super.initState();
    if (widget.c != null) {
      nome = widget.c.nome;
      email = widget.c.email;
      endereco = widget.c.endereco;
      cep = widget.c.cep;
      telefone = widget.c.telefone;
      cepIdentifier.text = endereco;
      if (DateTime.tryParse(widget.c.aniversario) != null) {aniversario = DateTime.parse(widget.c.aniversario);}
      else {aniversario = DateTime.now();}
      atualizar = true;
    }
  }

  void _storeUserImageFile(File imagem) {
    this.imagem = imagem;
  }

  selecionaData() {
  DateTime hoje = DateTime.now().add(Duration(days: 1));
  showDatePicker(
          context: context,
          initialDate: hoje,
          firstDate: hoje,
          lastDate: DateTime(hoje.year + 1))
      .then((value) => setState(() {
          aniversario = value;
      }));
  }

  criarContato() async {
    if (!globalKey.currentState.validate() && aniversario != null) return false;
    globalKey.currentState.save();

    if (!atualizar)
      await Provider.of<ContatosProvider>(context, listen: false)
          .add(nome, email, endereco, cep, telefone,aniversario.toIso8601String(),imagem);
    else {
      widget.c.nome = nome;
      widget.c.email = email;
      widget.c.endereco = endereco;
      widget.c.cep = cep;
      widget.c.telefone = telefone;
      widget.c.aniversario = aniversario.toIso8601String();

      await Provider.of<ContatosProvider>(context, listen: false)
          .update(widget.c,imagem);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(atualizar ? 'Modificar contato' : 'Inserir contato'),
      ),
      body: Form(
          key: globalKey,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                PickUserImage(
                  _storeUserImageFile,
                  initialValue: widget.c?.url ?? '',
                ),
                  TextFormField(
                    initialValue: nome,
                    decoration: InputDecoration(
                        labelText: 'Nome',
                        icon: Icon(Icons.person),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      nome = value;
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: email,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: cepIdentifier,
                    decoration: InputDecoration(
                        labelText: 'Endereço',
                        icon: Icon(Icons.location_city),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      endereco = value;
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: cep,
                    decoration: InputDecoration(
                        labelText: 'CEP',
                        icon: Icon(Icons.add_location),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                    onSaved: (value) {
                      cep = value;
                    },
                    onChanged: (value) async {
                      if (value.length < 8)
                        return;
                      final adressData = await readAddressByCep(value);
                      if (adressData.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CEP inválido')));
                        return;
                      }
                      setState(() {
                        cepIdentifier.text = adressData['street'] + ',' + adressData['neighborhood'] + ',' + adressData['state'];
                        endereco = cepIdentifier.text; 
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: telefone,
                    decoration: InputDecoration(
                        labelText: 'Telefone',
                        icon: Icon(Icons.phone_android),
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      telefone = value;
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        aniversario == null
                            ? Text('Nenhuma data \n foi selecionada')
                            : Text(DateFormat('dd/MM/yyyy').format(aniversario)),
                        Expanded(
                                                  child: ElevatedButton(
                              onPressed: selecionaData,
                              child: Text('Escolha uma data')),
                        ),
                      ]),

                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: criarContato, child: Text('Confirmar'))
                ],
              ),
            ),
          ));
  }
}
