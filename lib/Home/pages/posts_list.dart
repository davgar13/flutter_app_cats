import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_cats/Home/pages/cat_detail_screen.dart';

class PostsList extends StatelessWidget {
  const PostsList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('gatos').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        var posts = snapshot.data?.docs;

        return ListView.builder(
          itemCount: posts?.length ?? 0,
          itemBuilder: (context, index) {
            var post = posts![index].data() as Map<String, dynamic>;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatDetailScreen(catData: post),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.all(16.0),
                shape: RoundedRectangleBorder(
                  // Bordes redondeados
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10, // Sombra en la parte inferior del Card
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text('Dueño: ${post['nombre_dueño']}'),
                    ),
                    if (post['image_url'] != null &&
                        post['image_url'].isNotEmpty)
                      ClipRRect(
                        // Clip the image with rounded corners
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0)),
                        child: Image.network(
                          post['image_url'],
                          width: double.infinity,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nombre del Gato: ${post['nombre']}'),
                          Text('Descripción: ${post['descripcion']}'),
                          Text('Sexo: ${post['sexo']}'),
                          Text('Edad: ${post['edad']}'),
                          Text('Teléfono del Dueño: ${post['telefono']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
