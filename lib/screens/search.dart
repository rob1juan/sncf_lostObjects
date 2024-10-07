import 'package:myapp/colors.dart';
import 'package:flutter/material.dart';
import 'package:myapp/objects.dart';
import 'package:myapp/gares.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class SearchResult {
  final String gare;
  final DateTime date;
  final String objet;
  final String etat;
  final String dateRestitution;

  SearchResult({
    required this.gare,
    required this.date,
    required this.objet,
    required this.etat,
    required this.dateRestitution,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    String etat = json['gc_obo_nom_recordtype_sc_c'] == 'Objet trouvé'
        ? 'Trouvé'
        : 'Non trouvé';
    String dateRestitution = json['gc_obo_date_heure_restitution_c'] != null
        ? DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(json['gc_obo_date_heure_restitution_c']))
        : '-';

    return SearchResult(
      gare: json['gc_obo_gare_origine_r_name'],
      date: DateTime.parse(json['date']),
      objet: json['gc_obo_type_c'],
      etat: etat,
      dateRestitution: dateRestitution,
    );
  }
}

Future<List<SearchResult>> searchApi(
    String gare, DateTime date, String objet) async {
  final formattedDate = DateFormat('yyyy-MM-dd').format(date);
  final nextDate = DateFormat('yyyy-MM-dd')
      .format(DateTime(date.year, date.month, date.day + 1));

  final url = Uri.parse(
    'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records',
  );
  final params = {
    'where':
        'date>="$formattedDate" AND date<"$nextDate" AND gc_obo_gare_origine_r_name="$gare" AND gc_obo_nature_c="$objet"',
    'limit': '5',
  };
  final uri = url.replace(queryParameters: params);

  try {
    print("Tentative API");
    print(uri);
    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData.containsKey('results') && jsonData['results'] != null) {
        final resultList = jsonData['results'] as List<dynamic>;
        final searchResults =
            resultList.map((json) => SearchResult.fromJson(json)).toList();
        return searchResults;
      } else {
        return [];
      }
    } else {
      throw Exception('Erreur lors de la requête API');
    }
  } catch (e) {
    throw Exception(e.toString());
  }
}

void _showObjectDetailsDialog(BuildContext context, SearchResult result) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Détails de l\'objet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Gare: ${result.gare}'),
            Text('Date: ${DateFormat('yyyy-MM-dd').format(result.date)}'),
            Text('Objet: ${result.objet}'),
            Text('État: ${result.etat}'),
            Text('Date de restitution: ${result.dateRestitution}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Fermer'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _saveToHistory(SearchResult result) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList('history') ?? [];

  // Convert SearchResult to JSON string
  String resultJson = jsonEncode({
    'gare': result.gare,
    'date': result.date.toIso8601String(),
    'objet': result.objet,
    'etat': result.etat,
    'dateRestitution': result.dateRestitution,
  });

  history.add(resultJson);
  prefs.setStringList('history', history);
}

class _SearchPageState extends State<SearchPage> {
  final _gareController = TextEditingController();
  final _dateController = TextEditingController();
  final _objetController = TextEditingController();

  final List<String> _listeGares = Gares.listeGares;

  final List<String> _listeObjets = Objets.listeObjets;

  List<SearchResult>? _searchResults;

  String? _erreur;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: Container(), // Remove back button
        title: const Text(
          "Rechercher",
          style: TextStyle(
              fontSize: 20, color: Colors.white), // Center and white text
        ),
        centerTitle: true, // Center the title
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return [];
                  }
                  return _listeGares.where((gare) {
                    return gare
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  }).toList();
                },
                onSelected: (String selection) {
                  setState(() {
                    _gareController.text = selection;
                  });
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                    decoration: InputDecoration(
                      labelText: "Où avez-vous perdu ?",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Add border radius
                      ),
                      filled: true,
                      fillColor: AppColors.searchBarColor,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: "Quand avez-vous perdu ?",
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(30), // Add border radius
                  ),
                  filled: true,
                  fillColor: AppColors.searchBarColor,
                ),
                readOnly: true,
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() {
                      _dateController.text =
                          DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
              ),
              const SizedBox(height: 10),
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text == '') {
                    return [];
                  }
                  return _listeObjets.where((objet) {
                    return objet
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase());
                  }).toList();
                },
                onSelected: (String selection) {
                  setState(() {
                    _objetController.text = selection;
                  });
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                    decoration: InputDecoration(
                      labelText: "Qu'avez-vous perdu ?",
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Add border radius
                      ),
                      filled: true,
                      fillColor: AppColors.searchBarColor,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final gare = _gareController.text;
                  final date = DateTime.parse(_dateController.text);
                  final objet = _objetController.text;

                  try {
                    final searchResults = await searchApi(gare, date, objet);

                    setState(() {
                      _searchResults = searchResults;
                      _erreur = null;
                    });
                  } catch (e) {
                    setState(() {
                      _erreur = e.toString();
                    });
                  }
                },
                child: const Text('Rechercher'),
              ),
              const SizedBox(height: 20),
              _searchResults != null && _searchResults!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _searchResults!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _saveToHistory(_searchResults![index]);
                            _showObjectDetailsDialog(
                                context, _searchResults![index]);
                          },
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.all(10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_searchResults![index].gare}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Date : ${DateFormat(' yyyy-MM-dd').format(_searchResults![index].date)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Objet : ${_searchResults![index].objet}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        'État :',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        _searchResults![index].etat,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                _searchResults![index].etat ==
                                                        'Trouvé'
                                                    ? Colors.green
                                                    : Colors.red),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Date de restitution : ${_searchResults![index].dateRestitution}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : _searchResults != null && _searchResults!.isEmpty
                      ? Text(
                          'Aucun résultat',
                          style: const TextStyle(color: Colors.grey),
                        )
                      : Container(),
              _erreur != null
                  ? Text(
                      'Erreur : $_erreur',
                      style: TextStyle(color: Colors.red),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
