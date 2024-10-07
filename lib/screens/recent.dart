import 'package:flutter/material.dart';
import 'package:myapp/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({Key? key}) : super(key: key);

  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  List<dynamic> _recentItems = [];
  String? _errorMessage;
  String? _lastConnexionFormatted;

  @override
  void initState() {
    super.initState();
    _fetchRecentItems();
    _loadLastConnexionDate();
  }

  Future<void> _fetchRecentItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastConnexion = prefs.getString('lastConnexion');

    if (lastConnexion == null) {
      setState(() {
        _errorMessage = "Aucune connexion précédente trouvée.";
      });
      return;
    }

    final url = Uri.parse(
      'https://data.sncf.com/api/explore/v2.1/catalog/datasets/objets-trouves-restitution/records',
    );
    final params = {
      'where': 'date>="$lastConnexion"',
      'limit': '5',
    };
    final uri = url.replace(queryParameters: params);

    try {
      final response = await http.get(uri, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData.containsKey('results') && jsonData['results'] != null) {
          setState(() {
            _recentItems = jsonData['results'];
            _errorMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = "Aucun objet trouvé.";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Erreur lors de la requête API.";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadLastConnexionDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastConnexion = prefs.getString('lastConnexion');
    print(
        'Raw lastConnexion from SharedPreferences: $lastConnexion'); // Debugging

    if (lastConnexion != null) {
      try {
        DateTime lastConnexionDate = DateTime.parse(lastConnexion);
        setState(() {
          _lastConnexionFormatted = DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR')
              .format(lastConnexionDate);
          print(
              'Formatted last connection: $_lastConnexionFormatted'); // Debugging
        });
      } catch (e) {
        print('Error parsing date: $e'); // Debugging
      }
    } else {
      print('Pas d\'information sur la dernière connexion.'); // Debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: Container(), // Remove back button
        title: const Text(
          "Les plus récents",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            Expanded(
              child: _recentItems.isNotEmpty
                  ? ListView.builder(
                      itemCount: _recentItems.length,
                      itemBuilder: (context, index) {
                        final item = _recentItems[index];
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gare: ${item['gc_obo_gare_origine_r_name'] ?? 'N/A'}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Date : ${item['date'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(item['date'])) : 'N/A'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Objet : ${item['gc_obo_type_c'] ?? 'N/A'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'État : ${item['gc_obo_nom_recordtype_sc_c'] == 'Objet trouvé' ? 'Trouvé' : 'Non trouvé'}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: item['gc_obo_nom_recordtype_sc_c'] ==
                                            'Objet trouvé'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Date de restitution : ${item['gc_obo_date_heure_restitution_c'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(item['gc_obo_date_heure_restitution_c'])) : '-'}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        _errorMessage ?? 'Aucun objet récent trouvé.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Dernière connexion : ${_lastConnexionFormatted ?? 'Aucune donnée'}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
