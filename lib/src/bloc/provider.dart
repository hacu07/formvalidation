
// inherited widget personalizado

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
import 'package:formvalidation/src/bloc/productos_bloc.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart';


//maneja multiples instancias de bloc en un solo lugar
class Provider extends InheritedWidget{

  final loginBloc = new LoginBloc();
  final _productosBloc = new ProductosBloc();

  static Provider _instancia;

  // factory: si se retorna una nueva instancia de la clase o retorna una previamente creada
  factory Provider({Key key, Widget child}){
    if(_instancia == null){
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  //Constructor, implementa el inherited widget que tiene un bloc (loginbloc)
  Provider._internal({Key key, Widget child}): super(key: key, child:child);
  
  //Al actualizarse debe actualizar a los hijos, si se requiere.
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
  
  //Escala en el arbol de widgets hasta encontrar la instancia creada del provider en 
  //algun widget (el principal creado en el main.dart normalmente), de alli una vez 
  //lo encontra, retorna el bloc creado para usarlo a nivel general
  static LoginBloc of (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductosBloc productosBloc (BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
  }
}