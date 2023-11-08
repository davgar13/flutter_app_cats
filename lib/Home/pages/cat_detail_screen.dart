import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CatDetailScreen extends StatefulWidget {
  final Map<String, dynamic> catData;

  const CatDetailScreen({Key? key, required this.catData}) : super(key: key);

  @override
  _CatDetailScreenState createState() => _CatDetailScreenState();
}

class _CatDetailScreenState extends State<CatDetailScreen> {
  late Map<String, dynamic> catData;
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    catData = widget.catData;
    isOwner = FirebaseAuth.instance.currentUser?.uid == catData['owner_id'];
  }

  void changeCatStatus(String status) async {
    String? catId = catData['id'];
    if (catId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ID del gato no proporcionado.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('gatos')
          .doc(catId)
          .update({'estado': status});
      if (status == 'Eliminado') {
        await FirebaseFirestore.instance
            .collection('gatos')
            .doc(catId)
            .delete();
        Navigator.of(context).pop('Gato eliminado exitosamente');
      } else {
        setState(() {
          catData['estado'] = status;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el estado: $e')),
      );
    }
  }

  void adoptCat() {
    // Implement the logic to adopt the cat
    print('Adoptar gato');
    // For example, update the status to 'Adoptado' and assign the new owner
  }

  @override
  Widget build(BuildContext context) {
    Widget imageSection =
        catData['image_url'] != null && catData['image_url'].isNotEmpty
            ? Image.network(
                catData['image_url'],
                width: double.infinity,
                height: 350.0,
                fit: BoxFit.cover,
              )
            : Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(17.0)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  height: 200.0,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.photo_size_select_actual,
                    size: 100,
                    color: Colors.grey[700],
                  ),
                ),
              );

    return Scaffold(
      appBar: AppBar(
        title: Text(catData['nombre'] ?? 'Detalle del Gato'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(17.0)),
              child: imageSection,
            ),
            Transform.translate(
              offset: Offset(0, -50),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catData['nombre'] ?? 'No disponible',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Raza: ${catData['raza'] ?? 'No disponible'}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    Text(
                      'Edad: ${catData['edad'] ?? 'No disponible'}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    Text(
                      'Sexo: ${catData['sexo'] ?? 'No disponible'}',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Descripción:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      catData['descripcion'] ?? 'No disponible',
                      style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Estado: ${catData['estado'] ?? 'En adopción'}',
                      style: TextStyle(
                        fontSize: 20,
                        color: catData['estado'] == 'Adoptado'
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isOwner)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                            ),
                            child: Text('Marcar como Adoptado'),
                            onPressed: () => changeCatStatus('Adoptado'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                            ),
                            child: Text('Eliminar'),
                            onPressed: () => changeCatStatus('Eliminado'),
                          ),
                        ],
                      )
                    else
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                        ),
                        child: Text('Adoptar'),
                        onPressed: adoptCat,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
