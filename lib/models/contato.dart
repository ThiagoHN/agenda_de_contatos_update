import 'package:flutter/widgets.dart';

class Contato with ChangeNotifier {
  String _id;
  String _nome;
  String _email;
  String _endereco;
  String _cep;
  String _telefone;
  String _aniversario;
  String _url;

  Contato(this._id, this._nome, this._email, this._endereco, this._cep,
      this._telefone, this._aniversario, this._url);

  String get idContact {
    return this._id;
  }

  String get nome {
    return this._nome;
  }

  String get email {
    return this._email;
  }

  String get endereco {
    return this._endereco;
  }

  String get cep {
    return this._cep;
  }

  String get telefone {
    return this._telefone;
  }

  String get aniversario {
    return this._aniversario;
  }

  String get url {
    return this._url;
  }

  set id(String id) {
    this._id = id;
  }

  set nome(String nome) {
    this._nome = nome;
  }

  set email(String email) {
    this._email = email;
  }

  set endereco(String endereco) {
    this._endereco = endereco;
  }

  set cep(String cep) {
    this._cep = cep;
  }

  set telefone(String telefone) {
    this._telefone = telefone;
  }

  set aniversario(String aniversario) {
    this._aniversario = aniversario;
  }

  set url(String url) {
    this._url = url;
  }

}