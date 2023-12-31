import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_cats/bloc/form_bloc.dart';
import 'package:flutter_app_cats/bloc/form_events.dart';
import 'package:flutter_app_cats/bloc/form_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

class DataEntryScreen extends StatelessWidget {
  const DataEntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormStates>(
      builder: (context, state) {
        //BlocProvider.of<FormBloc>(context).add(PendingEvent());
        if (state is UpdateState) {
          if (state.succes == "n") {
            return listView(context);
          } else if (state.succes == "y") {
            return success(context);
          }
        }
        return listView(context);
      },
    );
  }

  Widget success(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Guardado correctamente',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<FormBloc>(context).add(PendingEvent());
            },
            child: const Text('Añadir nuevo gato'),
          ),
        ],
      ),
    );
  }

  Widget listView(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons
                  .pets, // Puedes cambiar esto por el ícono específico que desees
              size: 24,
              color:
                  Colors.blue, // Puedes cambiar el color según tus preferencias
            ),
            const SizedBox(width: 8),
            Text(
              'Añadir Gato',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
        const SizedBox(height: 20),
        DataEntryForm(),
      ],
    );
  }
}

class DataEntryForm extends StatefulWidget {
  const DataEntryForm({Key? key}) : super(key: key);

  @override
  _DataEntryFormState createState() => _DataEntryFormState();
}

class _DataEntryFormState extends State<DataEntryForm> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImageAndGetDownloadUrl(File imageFile) async {
    String fileName = p.basename(_image!.path);
    Reference ref = FirebaseStorage.instance.ref().child('gatos/$fileName');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se ha iniciado sesión')),
        );
      }
      return;
    }

    if (_image == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, selecciona una imagen')),
        );
      }
      return;
    }

    final ownerId = currentUser.uid;
    final ownerEmail = currentUser.email;

    try {
      final imageUrl = await _uploadImageAndGetDownloadUrl(_image!);
      // Crear un nuevo documento en Firestore y obtener el ID del documento
      DocumentReference docRef =
          await FirebaseFirestore.instance.collection('gatos').add({
        'nombre': _nameController.text,
        'raza': _breedController.text,
        'edad': _ageController.text,
        'sexo': _sexController.text,
        'telefono': _phoneController.text,
        'nombre_dueño': _ownerNameController.text,
        'descripcion': _descriptionController.text,
        'owner_id': ownerId,
        'owner_Email': ownerEmail,
        'image_url': imageUrl,
        // No es necesario agregar el 'id' aquí ya que se genera automáticamente
      });

      // Opcionalmente, actualiza el documento con el ID si es necesario
      await docRef.update({'id': docRef.id});

      _clearForm();
      if (mounted) {
        BlocProvider.of<FormBloc>(context).add(SuccessEvent());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos guardados correctamente')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar datos: $e')),
        );
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _breedController.clear();
    _ageController.clear();
    _sexController.clear();
    _phoneController.clear();
    _ownerNameController.clear();
    _descriptionController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.blue, width: 2.0), // Blue border
      ),
      elevation: 5,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Nombre del gato (opcional)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un nombre.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Raza'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la raza del gato.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Edad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa la edad del gato.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sexController,
                decoration: const InputDecoration(labelText: 'Sexo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el sexo del gato.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration:
                    const InputDecoration(labelText: 'Número de Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa un número de teléfono.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ownerNameController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del Dueño'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del dueño.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa una descripción.';
                  }
                  return null;
                },
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.file(_image!),
                ),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Seleccionar Imagen'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Guardar Datos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
