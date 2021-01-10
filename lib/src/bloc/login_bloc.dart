
import 'dart:async';

import 'package:formvalidation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

// mixing usando Validators
class LoginBloc with Validators{

  // dos stream controller: email y password, se reemplazo por BehaviorSubject
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // se validan los datos con la clase Validators creada
  //Recuperar los datos del stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  //Combinando Stream
  // Stream retorna bool si los datos ingresados son validos para activar el boton
  Stream<bool> get formValidStream => Rx.combineLatest2(
      emailStream, 
      passwordStream, 
      (emailRes, passwordRes) => true
    );

  // Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Obtener el ultimo valor ingresado a los Streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }
}