import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> catData; // Datos del gato

  const CatDetailScreen({Key? key, required this.catData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar si el usuario actual es el dueño del gato
    final bool isOwner =
        FirebaseAuth.instance.currentUser?.uid == catData['owner_id'];

    // Método para cambiar el estado del gato
    void changeCatStatus(String status) {
      FirebaseFirestore.instance
          .collection('gatos')
          .doc(catData[
              'id']) // Asegúrate de que 'id' es el ID del documento del gato en Firestore
          .update({'estado': status})
          .then((_) => Navigator.of(context).pop())
          .catchError(
              (error) => print('Error al actualizar el estado: $error'));
    }

    // Método para adoptar el gato
    void adoptCat() {
      // Aquí la lógica para adoptar el gato
      print('Adoptar gato');
      // Puede involucrar actualizar el estado a 'Adoptado' y asignar el nuevo dueño, por ejemplo.
    }

    // Sección de la imagen con un placeholder en caso de que no haya imagen
    Widget imageSection = catData['image_url'] != null &&
            catData['image_url'].isNotEmpty
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
                  const BorderRadius.vertical(bottom: Radius.circular(17.0)),
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
            // Imagen del gato o placeholder
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(17.0)),
              child: imageSection,
            ),
            // Contenedor de información del gato
            Transform.translate(
              offset: const Offset(0, -50),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(25.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catData['nombre'] ?? 'No disponible',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 20),
                    Text(
                      'Estado: ${catData['estado'] ?? 'En adopción'}',
                      style: TextStyle(
                        fontSize: 20,
                        color: (catData['estado'] == 'Adoptado')
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
                            child: const Text('Marcar como Adoptado'),
                            onPressed: () => changeCatStatus('Adoptado'),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                            ),
                            child: const Text('Eliminar'),
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
                        child: const Text('Adoptar'),
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
