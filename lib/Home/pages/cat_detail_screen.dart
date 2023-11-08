import 'package:flutter/material.dart';

class CatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> catData; // Aquí se guardan los datos del gato

  const CatDetailScreen({Key? key, required this.catData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(catData['nombre'] ?? 'Detalle del Gato'),
        backgroundColor: Colors.purple, // Color personalizado para la AppBar
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen con bordes redondeados
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(25.0)),
              child: catData['image_url'] != null &&
                      catData['image_url'].isNotEmpty
                  ? Image.network(
                      catData['image_url'],
                      width: double.infinity,
                      height: 300.0,
                      fit: BoxFit.cover,
                    )
                  : const Placeholder(fallbackHeight: 200.0),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              transform: Matrix4.translationValues(0.0, -50.0,
                  0.0), // Eleva el contenedor para superponerlo a la imagen
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(25.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 0), // changes position of shadow
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
                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    catData['descripcion'] ?? 'No disponible',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
