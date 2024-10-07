import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'search.dart';
import 'package:myapp/colors.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<SearchResult> _historyResults = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('history') ?? [];

    setState(() {
      _historyResults = history.map((resultJson) {
        Map<String, dynamic> resultMap = jsonDecode(resultJson);
        return SearchResult(
          gare: resultMap['gare'],
          date: DateTime.parse(resultMap['date']),
          objet: resultMap['objet'],
          etat: resultMap['etat'],
          dateRestitution: resultMap['dateRestitution'],
        );
      }).toList();
    });
  }

  void _resetHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('history'); // Supprime l'historique enregistré
    setState(() {
      _historyResults.clear(); // Vide la liste locale
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: Container(), // Remove back button
        title: const Text(
          "Historique",
          style: TextStyle(
              fontSize: 20, color: Colors.white), // Center and white text
        ),
        centerTitle: true, // Center the title
      ),
      body: Container(
        color: AppColors.backgroundColor, // Couleur de fond du body
        child: _historyResults.isNotEmpty
            ? ListView.builder(
                itemCount: _historyResults.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gare: ${_historyResults[index].gare}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Date : ${DateFormat('yyyy-MM-dd').format(_historyResults[index].date)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Objet : ${_historyResults[index].objet}',
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
                                _historyResults[index].etat,
                                style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        _historyResults[index].etat == 'Trouvé'
                                            ? Colors.green
                                            : Colors.red),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Date de restitution : ${_historyResults[index].dateRestitution}',
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
                  'Aucun historique disponible',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetHistory,
        backgroundColor: Colors.red,
        child: Icon(Icons.delete),
        tooltip: 'Réinitialiser l\'historique',
      ),
    );
  }
}
