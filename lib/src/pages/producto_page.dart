import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/productos_bloc.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/utils/utils.dart' as Utils;
import 'package:image_picker/image_picker.dart';


class ProductoPage extends StatefulWidget {


  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _guardando = false;
  File foto;
  final picker = ImagePicker();

  ProductosBloc productosBloc;

  //Objeto que se enlaza con los campos del formulario
  ProductoModel producto = new ProductoModel();

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);

    final ProductoModel prodData  = ModalRoute.of(context).settings.arguments;

    print(prodData);
    if(prodData != null){
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual), 
            onPressed: _seleccionarFoto,
            ),
          IconButton(
            icon: Icon(Icons.camera_alt), 
            onPressed: _tomarFoto,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            //identificador unico del formulario
            key: formKey,
            child: Column(
              children: [
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _crearNombre(){
    // Solo trabajan con los form
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value){
        // este metodo se ejecuta una vez se ha validado el campo
        producto.titulo = value;
      },
      validator: (String value){
        if(value.length < 3){
          return 'Ingrese el nombre del producto';
        }else{
          return null;
        }
      },
    );
  }

  Widget _crearPrecio(){
    // Solo trabajan con los form
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value){
        producto.valor = double.parse(value);
      },
      validator: (String value){
        if(Utils.isNumeric(value)){
          // es un numero
          return null;
        }else{
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearDisponible(){
    return SwitchListTile(
      title: Text("Disponible"),
      value: producto.disponible,
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      }));
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_guardando) ? null :_submit,
    );
  }

  void _submit() async{

    if(!formKey.currentState.validate()) return;

    //Ejecuta el evento save de todos los textformfield del formulario
    formKey.currentState.save();

    setState(() {_guardando = true;});

    // carga imagen en cloudinary
    if(foto != null){
      producto.fotoUrl = await productosBloc.subirFoto(foto);
    }

    if(producto.id == null){
      productosBloc.agregarProducto(producto);  
    }else{
      productosBloc.editarProducto(producto);
    }

    mostrarSnackbar('Registro guardado.');
    //setState(() {_guardando = false;});

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje){
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
      );

      scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _mostrarFoto(){
    if(producto.fotoUrl != null){
      // TODO: tengo que hacer eso
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }else{
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {

    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async{
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async{
    
    final pickedFile = await ImagePicker.pickImage(
      source: origen,
    );
    
    this.foto = File(pickedFile.path);
 
    if (foto != null) {
      producto.fotoUrl = null;
    }
 
    setState(() {});
  }
}