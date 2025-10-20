import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:mob_collect_tax_pos/Home/add_recette.dart';
import 'package:mob_collect_tax_pos/Login/login.dart';
import 'package:mob_collect_tax_pos/MyClasses/cls_colors.dart';
import 'package:mob_collect_tax_pos/MyClasses/cls_glossaire.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:senraise_printer/senraise_printer.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('my_java_linker');

  String result = 'no result';
  Uint8List? bytes;
// Function for mobiPrint
  Future<void> printONmobiPrint(String contenu) async {
    try {
      final ByteData imageData = await NetworkAssetBundle(Uri.parse(
              "https://fecoppeme.org/fichier/logo.png?compress=1&resize=400x300"))
          .load("");
      bytes = imageData.buffer.asUint8List();
      setState(() {});

      String backVal = await platform.invokeMethod(
          'myJavaFunc', {'data': bytes, 'title': "RECU DE PAIEMENT\n$contenu"});
      result = 'the result back :$backVal';
    } on PlatformException catch (e) {
      result = 'something wrong: $e';
    }
    setState(() {});
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 300,
      minWidth: 400,
      quality: 96,
      //rotate: 135,
    );
    print(list.length);
    print(result.length);
    return result;
  }

//Functioin for SenRaiser H1O
  final _senraisePrinterPlugin = SenraisePrinter();
  Future<void> printONsenraiser(String contenu) async {
    try {
      // final ByteData imageData = await NetworkAssetBundle(Uri.parse(
      //         "https://fecoppeme.org/fichier/logo.png?compress=1&resize=400x300"))
      //     .load("");
      // bytes = imageData.buffer.asUint8List();
      // setState(() {});

      Uint8List data =
          (await rootBundle.load('assets/mairie.png')).buffer.asUint8List();
      print(data.lengthInBytes);
      data = await testComporessList(data);
      //await _senraisePrinterPlugin.setTextBold(true);
      //await _senraisePrinterPlugin.setTextSize(25);
      await _senraisePrinterPlugin.printText(
          "MAIRIE DE GOMA\n================\nASSAINISSEMENT CONTRIBUABLE\n================\n$contenu\n");
      await _senraisePrinterPlugin.printPic(data);

      await _senraisePrinterPlugin.printText("==========================\n");
      await _senraisePrinterPlugin.nextLine(2);
    } catch (e) {
      print("EXCEPTION================\n$e");
    }
  }

  bool isExpandedo = false;
  bool isExpandedo1 = true;
  // We will fetch data from this Rest api
  final _baseUrl = '${Glossaire.baseUrl_mvt}';

  // At the beginning, we fetch the first 20 posts
  int _page = 1;
  // you can change this value to fetch more or less posts per page (10, 15, 5, etc)
  final int _limit = 4;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  // This holds the posts fetched from the server
  List _posts = [];

  // This function will be called when the app launches (see the initState function)
  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    try {
      final res = await http.get(Uri.parse("$_baseUrl?page=$_page"));

      setState(() {
        _posts = json.decode(res.body); //['data']['data']
        //print("==================+++++++++$_posts");
      });
    } catch (err) {
      print("/////////////////////$err");
      if (kDebugMode) {
        print('Something went wrong...');
      }
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  // This function will be triggered whenver the user scroll
  // to near the bottom of the list view
  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        final res = await http.get(Uri.parse("$_baseUrl?page=$_page"));

        final List fetchedPosts = json.decode(res.body); //['data']['data'];
        if (fetchedPosts.isNotEmpty) {
          setState(() {
            _posts.addAll(fetchedPosts);
          });
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  // The controller for the ListView
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);

    isExpandedo = false;
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Paiements'),
        actions: [
          InkWell(
            child: Icon(Icons.refresh),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
          InkWell(
            child: Icon(Icons.exit_to_app),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ),
              );

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => super.widget));
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
        ],
      ),
      body: _isFirstLoadRunning
          ? const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 70, 129, 196),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: _posts.length,
                    itemBuilder: (_, index) => Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: ListTile(
                        title: Text(_posts[index]['colProprietaire_Ese']),
                        subtitle: Text(
                            '${_posts[index]['categorietaxe']}\nMontant : ${_posts[index]['montant_total']}\nQuotité: ${_posts[index]['montant_quotite']}\nà Récouvrer: ${_posts[index]['recouvrement']}\nMois: ${_posts[index]['name_mois']}\nAnnée:${_posts[index]['name_annee']}\nDate:${_posts[index]['dateOperation']}\n'),
                        trailing: IconButton(
                          icon: Icon(Icons.print),
                          color: MyColors.primaryColor,
                          iconSize: 40,
                          onPressed: () {
                            printONsenraiser(
                                'No.${_posts[index]['id']}\n${_posts[index]['colProprietaire_Ese']}\n${_posts[index]['colQuartier_Ese']}\n${_posts[index]['colAdresseEntreprise_Ese']}\n${_posts[index]['entreprisePhone1']}\n${_posts[index]['motif']}\nMontant : ${_posts[index]['montant_total']}\nQuotité: ${_posts[index]['montant_quotite']}\nà Récouvrer: ${_posts[index]['recouvrement']}\nMois: ${_posts[index]['name_mois']}\nAnnée:${_posts[index]['name_annee']} \nAgent:${_posts[index]['author']}\nDate : ${_posts[index]['dateOperation']}');
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                // when the _loadMore function is running
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 70, 129, 196)),
                    ),
                  ),

                // When nothing else to load
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: Color.fromARGB(255, 217, 210, 189),
                    child: const Center(
                      child: Text('You have fetched all of the content...'),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        tooltip: 'Add',
        onPressed: () async {
          try {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddRecette(),
              ),
            );
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
          } catch (e) {}
        },
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 70, 129, 196),
        ),
      ),
    );
  }
}
