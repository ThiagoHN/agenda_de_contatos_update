import 'dart:io';

import 'package:agenda_de_contatos/models/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class ContatosProvider with ChangeNotifier {
  FirebaseFirestore storage = FirebaseFirestore.instance;
  List<Contato> _items = [];
  final mainCollection = 'usuarios';
  final subCollection = 'contatos';
  final imageStorage = FirebaseStorage.instance;

  String idUsuario;

  ContatosProvider();
  ContatosProvider.logado(this.idUsuario);

  List<Contato> get items {
    return [..._items];
  }

  Contato find(String id) =>
      _items.firstWhere((element) => element.idContact == id);

  Future<void> getDados() async {
    final allContacts = await storage
        .collection(mainCollection)
        .doc(idUsuario)
        .collection(subCollection)
        .get();
    final userContacts = allContacts.docs;
    if (userContacts.length == 0) return;
    _items = userContacts.map((e) {
      final contactData = e.data();
      return Contato(e.id, contactData['nome'], contactData['email'],
          contactData['endereco'], contactData['cep'], contactData['telefone'], contactData['aniversario'], contactData['url'], );
    }).toList();
    notifyListeners();
  }

  Future<void> add(String nome, String email, String endereco, String cep,
      String telefone, String aniversario, File imagem) async {
    final contatoID = DateTime.now().toIso8601String();
    String url = '';
    if (imagem.existsSync()) {
      final ref = imageStorage
          .ref()
          .child('contact_image')
          .child(idUsuario + contatoID + '.jpg');

      await ref.putFile(imagem);

      url = await ref.getDownloadURL();
    }
    await storage
        .collection(mainCollection)
        .doc(idUsuario)
        .collection(subCollection)
        .doc(contatoID)
        .set({
      'nome': nome,
      'email': email,
      'endereco': endereco,
      'cep': cep,
      'telefone': telefone,
      'url': url
    });

    Contato novaConta =
        Contato(contatoID, nome, email, endereco, cep, telefone, aniversario, url);
    _items.add(novaConta);
    notifyListeners();
  }

  Future<void> remove(Contato contatoSelecionado) async {
    _items.remove(contatoSelecionado);
    await storage
        .collection(mainCollection)
        .doc(idUsuario)
        .collection(subCollection)
        .doc(contatoSelecionado.idContact)
        .delete();

    if (contatoSelecionado.url != '') {
      final ref = imageStorage
          .ref()
          .child('contact_image')
          .child(idUsuario + contatoSelecionado.idContact + '.jpg');

      ref.delete();
    }

    notifyListeners();
  }

  Future<void> update(Contato contatoSelecionado, File imagem) async {
    final contaIndex = _items.indexWhere(
        (element) => element.idContact == contatoSelecionado.idContact);
    if (contaIndex == -1) return false;
    String url = '';
    if (imagem.existsSync()) {
      final ref = imageStorage
          .ref()
          .child('contact_image')
          .child(idUsuario + contatoSelecionado.idContact + '.jpg');

      await ref.putFile(imagem);

      url = await ref.getDownloadURL();
    }
    else {
      url = contatoSelecionado.url;
    }
    
    _items[contaIndex] = contatoSelecionado;
    _items[contaIndex].url = url;

    await storage
        .collection(mainCollection)
        .doc(idUsuario)
        .collection(subCollection)
        .doc(contatoSelecionado.idContact)
        .update({
      'nome': contatoSelecionado.nome,
      'email': contatoSelecionado.email,
      'endereco': contatoSelecionado.endereco,
      'cep': contatoSelecionado.cep,
      'telefone': contatoSelecionado.telefone,
      'aniversario': contatoSelecionado.aniversario,
      'url': url
    });
    notifyListeners();
  }

  List<Contato> get aniversariantes => _items.where((element) => DateTime.tryParse(element.aniversario) != null).toList();

}
