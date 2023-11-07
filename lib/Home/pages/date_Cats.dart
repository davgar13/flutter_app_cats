// ignore_for_file: prefer_const_constructors

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

class DataEntryScreen extends StatelessWidget {
  const DataEntryScreen({super.key});

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
        } else {
          return listView(context);
        }
        return Container();
      },
    );
  }

  // Esta función representa la interfaz de usuario mostrada después de un éxito en la actualización.
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
      children: const [
        SizedBox(height: 20),
        Text(
          'Añadir Gato',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 20),
        DataEntryForm(),
      ],
    );
  }
}

class DataEntryForm extends StatefulWidget {
  const DataEntryForm({super.key});

  @override
  _DataEntryFormState createState() => _DataEntryFormState();
}

File? _image;
final storageRef = FirebaseStorage.instance.ref();

class _DataEntryFormState extends State<DataEntryForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  Future<void> _submitForm() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final ownerId = currentUser!.uid;
    try {
      //final imageURL = await storageRef.child('gatos/${_image!.path}').getDownloadURL();

      await FirebaseFirestore.instance.collection('gatos').add({
        'nombre': _nameController.text,
        'raza': _breedController.text,
        'edad': _ageController.text,
        'sexo': _sexController.text,
        'telefono': _phoneController.text,
        'nombre_dueño': _ownerNameController.text,
        'descripcion': _descriptionController.text,
        'owner_id': ownerId,
        'image_url': _image!.path,
      });

      await storageRef.child('gatos/${_image!.path}').putFile(_image!);

      // Limpia los controladores después de guardar los datos
      _nameController.clear();
      _breedController.clear();
      _ageController.clear();
      _sexController.clear();
      _phoneController.clear();
      _ownerNameController.clear();
      _descriptionController.clear();
      _image = null;
    } catch (e) {
      print('Error al guardar datos: $e');
      // Maneja cualquier error que pueda ocurrir durante el guardado de datos
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                  labelText: 'Nombre del gato (opcional)'),
            ),
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(labelText: 'Raza'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la raza del gato.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Edad'),
            ),
            TextFormField(
              controller: _sexController,
              decoration: const InputDecoration(labelText: 'Sexo'),
            ),
            TextFormField(
              controller: _phoneController,
              decoration:
                  const InputDecoration(labelText: 'Número de Teléfono'),
            ),
            TextFormField(
              controller: _ownerNameController,
              decoration: const InputDecoration(labelText: 'Nombre del Dueño'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar Imagen'),
            ),
            if (_image != null) Image.file(_image!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitForm();
                  BlocProvider.of<FormBloc>(context).add(SuccessEvent());
                }
              },
              child: const Text('Guardar Datos'),
            ),
          ],
        ),
      ),
    );
  }
}
