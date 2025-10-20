import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mob_collect_tax_pos/Home/home_recette.dart';
import 'package:mob_collect_tax_pos/MyClasses/cls_colors.dart';
import 'package:mob_collect_tax_pos/MyClasses/pub_con.dart';

class Glossaire {
  static String baseUrl_mvt =
      '${PubCon.cheminApi}fetch_vente_by_serveur/${PubCon.id_agent}';

//login
  static Future<List?> mylogin(GlobalKey<ScaffoldState> _scaffoldKey,
      BuildContext context, String user, String pass) async {
    final queryParameters = {
      'mail': user,
      'codeSecret': pass,
    };
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*'
    };
    try {
      var url = Uri.http(
          '${PubCon.url_domaine}', 'api/fetch_login_agent', queryParameters);

      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var datauser =
            jsonDecode(response.body)['data']; // as Map<String, dynamic>;
        print(datauser);
        if (datauser.length == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('login incorrect!!!')),
          );
        } else {
          PubCon.id_agent = datauser[0]['id'];
          PubCon.noms_author = datauser[0]['noms_agent'];
          PubCon.telephone_profil = datauser[0]['contact_agent'];
          PubCon.mail = datauser[0]['mail_agent'];
          PubCon.adresse_profil = datauser[0]['nomQuartier'];
          print(PubCon.telephone_profil);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyHomePage(
                title: "Livraison Marchandises",
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Echec de connexion!')),
        );
      }
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifiez votre connexion!')),
      );
      return null;
    }
  }

//insert data into database
  static Future update_livraison(BuildContext ctx) async {
    try {
      if (PubCon.livraison == "Non encore Livrée") {
        String idVente = PubCon.refEnteteVente.toString();
        var url = Uri.https(PubCon.url_domaine, 'api/update_livraison_mobile');
        var response = await http.post(url, body: {
          'id': idVente.toString(),
          'livreur_author': PubCon.noms_author.toString()
        });
        print(
            "Client: ${PubCon.nomClient}, Date: ${PubCon.dateVente}, Montant: ${PubCon.montantVente}, Statu Livraison: ${PubCon.livraison}");
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          //print("Enregistrement reussi");
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(content: Text('Enregistrement reussi!')),
          );
          Navigator.of(ctx).pop();
        } else {
          ScaffoldMessenger.of(ctx).showSnackBar(
            const SnackBar(
                content: Text(
              'Echec d\'enregistrement!....',
              style: TextStyle(color: Colors.red),
            )),
          );
        }
      } else {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
              content: Text(
            'Cette facture est déja livrée svp',
            style: TextStyle(color: Colors.red),
          )),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
            content: Text(
          'Une erreur s\'est produite lors de l\'enregistrement....',
          style: TextStyle(color: Colors.red),
        )),
      );
    }
  }

//Get entreprise by code
//
  static Future<List?> getEseByCode(GlobalKey<ScaffoldState> _scaffoldKey,
      BuildContext context, String code) async {
    try {
      // ✅ Construction correcte de l’URL
      final queryParameters = {'id_vente': code};
      final url = Uri.http(
          PubCon.url_domaine, 'api/fetch_vente_by_idVente', queryParameters);

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final datauser = jsonDecode(response.body);

        // ✅ Vérifie si la réponse est bien une liste
        if (datauser is List && datauser.isNotEmpty) {
          final vente = datauser[0];

          // ✅ Mise à jour des variables globales
          PubCon.refEnteteVente = int.tryParse(vente['id'].toString()) ?? 0;
          PubCon.nomClient = vente['noms']?.toString() ?? '';
          PubCon.montantVente = vente['RestePaie']?.toString() ?? '0';
          PubCon.livraison = vente['livraison']?.toString() ?? '';
          PubCon.dateVente = vente['dateVente']?.toString() ?? '';

          return datauser; // ✅ retourne la liste
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Aucune vente trouvée')),
          );
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Échec de connexion au serveur')),
        );
        return null;
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération de la vente : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vérifiez votre connexion internet !')),
      );
      return null;
    }
  }
}
