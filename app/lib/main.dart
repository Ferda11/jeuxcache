import 'dart:math';
import'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MotCache(),
      ),
    );
  }
}

class MotCache extends StatefulWidget {
  @override
  _MotCacheState createState() => _MotCacheState();
}

class _MotCacheState extends State<MotCache> {
  List<String> mots = ['FLUTTER', 'DART', 'MOBILE', 'DEVELOPPEMENT', 'APPLICATION'];
  List<String> indices = [
    'Framework de développement d\'applications multiplateforme',
    'Langage de programmation',
    'Plateforme mobile',
    'Création d\'applications logicielles',
    'Logiciel destiné à accomplir une tâche particulière',
  ];

  String motCache = '';
  String indiceMot = '';
  List<String> lettresDevinees = [];
  final List<String> qwerty = [
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
    'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L',
    'Z', 'X', 'C', 'V', 'B', 'N', 'M',
  ];
  int chancesRestantes = 5;

  @override
  void initState() {
    super.initState();
    MotCacheAleatoire();
  }

  void MotCacheAleatoire() {
    Random random = Random();
    int motAleatoire = random.nextInt(mots.length);

    setState(() {
      motCache = mots[motAleatoire];
      indiceMot = indices[motAleatoire];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBar(
          title: Text('Jeu de Mot Cache  - Chances restantes : $chancesRestantes'),
          backgroundColor: Colors.blue,
        ),

        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Indice : $indiceMot",
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.red,
            ),
          ),
        ),

        Expanded(
          child: Center(
            child: Text(
              "Mot cache : ${afficherMotCache(motCache, lettresDevinees)}",
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),

        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
            ),
            itemCount: qwerty.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  traiterlettre_devine(qwerty[index]);
                },
                child: Container(
                  margin: EdgeInsets.all(4.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      qwerty[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        ElevatedButton(
          onPressed: () {
            effacerDerniereLettre();
          },
          child: Text("Effacer"),
        ),
      ],
    );
  }

  void traiterlettre_devine(String lettre_devine) {
    if (!motCache.contains(lettre_devine)) {
      setState(() {
        chancesRestantes--;
      });
    }

    setState(() {
      lettresDevinees.add(lettre_devine);
    });

    if (afficherMotCache(motCache, lettresDevinees) == motCache) {
      print('le joueur a gagné');
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Screen_gagne_perdu(gagne: true),
      ));
    }

    if (chancesRestantes == 0) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Screen_gagne_perdu(gagne: false),
      ));
    }
  }

  void effacerDerniereLettre() {
    setState(() {
      if (lettresDevinees.isNotEmpty) {
        lettresDevinees.removeLast();
      }
    });
  }

  String afficherMotCache(String mot, List<String> lettresDevinees) {
    String motAffiche = '';
    for (int i = 0; i < mot.length; i++) {
      if (lettresDevinees.contains(mot[i])) {
        motAffiche += mot[i];
      } else {
        motAffiche += '*';
      }
    }
    return motAffiche;
  }
}

class Screen_gagne_perdu extends StatelessWidget {
  final bool gagne;

  Screen_gagne_perdu({required this.gagne});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              gagne ? 'Félicitations ! Vous avez gagné !' : 'Dommage ! Vous avez perdu.',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
              ),
              onPressed: () {
                // Rejouer
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => MotCache(),
                ));
              },
              child: Text('Rejouer'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text('Quitter'),
            ),
          ],
        ),
      ),
    );
  }
}
