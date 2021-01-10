

import 'dart:async';

class Validators{

  //<String,String> Entra un String y sale un String
  final validarEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (email, sink){
      // valida que sea un correo
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);

      if(regExp.hasMatch(email)){
        sink.add(email);
      }else{
        sink.addError('Email no es correcto.');
      }
    }
  );

  //<String,String> Entra un String y sale un String
  final validarPassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (password, sink){
      if(password.length >= 6){
        // Si la contrasena es mayor a 6 la deja continuar
        sink.add(password);
      }else{
        // Muestra error
        sink.addError('Ingrese mas de 6 caracteres.');
      }
    }
  );

}