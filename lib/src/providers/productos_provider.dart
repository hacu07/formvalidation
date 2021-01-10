//Encargado de hacer las interacciones directas con la bd

import 'dart:convert';
import 'dart:io';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ProductosProvider{
  final String _url = "https://flutter-varios-80909.firebaseio.com";
  final _prefs = new PreferenciasUsuario();

  //Se consumen servicios REST de firebase
  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';

    final response = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final response = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(response.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async{
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();

    if(decodeData == null) return [];

    if(decodeData['error'] != null) return [];

    decodeData.forEach((id, producto) {
      final prodTemp = ProductoModel.fromJson(producto);
      prodTemp.id = id;

      productos.add(prodTemp);
    });

    return productos;
  }

  Future<int> borrarProducto(String id)  async{
    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    print(jsonDecode(resp.body));

    return 1;
  }

  Future<String> subirImagen(File imagen) async{

    final  url = Uri.parse('https://api.cloudinary.com/v1_1/da69fjucb/image/upload?upload_preset=tilfws6z');

    //obtiene tipo de imagen
    final mimetype = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file', 
      imagen.path,
      contentType: MediaType(mimetype[0], mimetype[1])
    );

    // agrega la imagen a enviar
    // Si se requieren enviar varias imagenes solo es copiar la linea y agregar los file
    imageUploadRequest.files.add(file);

    // ejecuta peticion
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(
        resp.statusCode != 200 && 
        resp.statusCode != 201
      ){
        print('Algo salio mal.');
        print(resp.body);
        return null;
    }

    final respData = json.decode(resp.body);

    print(respData['secure_url']);
    return respData['secure_url'];
  }
}