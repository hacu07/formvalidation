

import 'package:flutter/material.dart';

bool isNumeric(String value){
  if(value.isEmpty) return false;

  final n = num.tryParse(value);

  return (n == null)? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(mensaje),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop()
            ),
        ],
      );
    }
  );
}