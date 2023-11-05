

import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class ListadoGatos extends StatefulWidget {
  const ListadoGatos({super.key});

  @override
  State<ListadoGatos> createState() => _ListadoGatosState();
}

class _ListadoGatosState extends State<ListadoGatos> {
  List breeds = [];
  Map selectedBreed = {};
  List images = [];
  String countryFlagUrl = '';

  @override
  void initState() {
    super.initState();
    getBreeds();
  }

  Future<void> getBreeds() async {
    const apiKey = 'live_uHsjzjp2sZMBNibLMeC6KLQ8fjqFAaHaoeLMZEwCz7vT9pwDPpKHXgAiDK2YgsFL'; 
    final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/breeds'),
        headers: {'x-api-key': apiKey});

    if (response.statusCode == 200) {
      setState(() {
        breeds = jsonDecode(response.body);
        selectedBreed = breeds[0];
        getImages();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getImages() async {
  const apiKey = 'live_uHsjzjp2sZMBNibLMeC6KLQ8fjqFAaHaoeLMZEwCz7vT9pwDPpKHXgAiDK2YgsFL'; 
  final baseUrl = Uri.parse('https://api.thecatapi.com/v1/images/search');
  
  final queryParameters = {
    'breed_ids': selectedBreed['id'],
    'limit': '8',
  };

  final url = baseUrl.replace(queryParameters: queryParameters);

  final response = await http.get(url, headers: {'x-api-key': apiKey});

  if (response.statusCode == 200) {
    setState(() {
      images = jsonDecode(response.body);
      countryFlagUrl = 'https://cdnjs.cloudflare.com/ajax/libs/flag-icon-css/3.2.1/flags/1x1/${selectedBreed['country_code'].toLowerCase()}.svg';
    });
  } else {
    throw Exception('Failed to load images');
  }
}


  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          DropdownButton(
            value: selectedBreed,
            items: breeds.map<DropdownMenuItem>((breed) {
              return DropdownMenuItem(
                value: breed,
                child: Text(breed['name']),
              );
            }).toList(),
            onChanged: (breed) {
              setState(() {
                selectedBreed = breed;
                getImages();
              });
            },
          ),
          Expanded(
            child: ListView(
              children: [
                Column(
                  children: <Widget>[
                    CarouselSlider(
                      items: images.map<Widget>((image) {
                        return Image.network(image['url']);
                      }).toList(),
                      options: CarouselOptions(
                        height: 300,
                      ),
                    ),

                    Card(
                      color: Colors.cyan[100],
                      shadowColor: const Color.fromARGB(255, 51, 59, 66),
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Color.fromARGB(213, 209, 209, 209),
                            ),
                            child: ListTile(
                              leading: SvgPicture.network(countryFlagUrl,
                                  width: 40, 
                                  placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
                              ),
                              title: Text(toString(selectedBreed['origin'])),
                            ),
                          ),
                          if (selectedBreed['experimental'] == 1) const Chip(label: Text('Experimental')),
                          if (selectedBreed['rex'] == 1) const Chip(label: Text('Rex')),
                          if (selectedBreed['natural'] == 1) const Chip(label: Text('Natural')),
                          if (selectedBreed['rare'] == 1) const Chip(label: Text('Rare')),
                          if (selectedBreed['hairless'] == 1) const Chip(label: Text('Hairless')),
                          if (selectedBreed['suppressed_tail'] == 1) const Chip(label: Text('Suppressed Tail')),
                          if (selectedBreed['short_legs'] == 1) const Chip(label: Text('Short Legs')),
                          if (selectedBreed['hypoallergenic'] == 1) const Chip(label: Text('Hypoallergenic')),
                          ListTile(
                            title: Text(
                              toString(selectedBreed['name']),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('---'),
                                Text(toString(selectedBreed['description'])),
                                const Text('---'),
                                Text(
                                  'Temperament: ' + toString(selectedBreed['temperament']), 
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                                const Text('---'),
                                Text('Life span: ' + toString(selectedBreed['life_span'])),
                                const Text('---'),
                                Text(toString(selectedBreed['weight'])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )
          ),
        ],
      );
  }
}


String toString(Object? object) {
  if (object == null) {
    return '';
  } else {
    return object.toString();
  }
}