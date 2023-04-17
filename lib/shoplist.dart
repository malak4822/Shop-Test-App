import 'package:databaseapp/itempage.dart';
import 'package:databaseapp/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyShop extends StatefulWidget {
  const MyShop({super.key});

  @override
  State<MyShop> createState() => _MyShopState();
}

List<int> karta = [];
List<List> _rows = [];

class _MyShopState extends State<MyShop> {
  late Future func;
  @override
  void initState() {
    func = showRecords();
    super.initState();
  }

  bool essa = false;
  bool isLiked = false;

  Future showRecords() async {
    wynik = await connection.query('SELECT * FROM thumbnailContent');
    for (var row in wynik) {
      final map = [row[1], row[2]];
      setState(() {
        _rows.add(map);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: List.generate(_rows.length, (index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemPage(
                              id: index,
                              myRows: _rows,
                            )));
              },
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(blurRadius: 4),
                    ],
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(_rows[index][0].toString()),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: const Color.fromARGB(255, 164, 164, 164)),
                child: Column(children: [
                  FutureBuilder(
                      initialData: '',
                      future: func,
                      builder: ((context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Refresh App'),
                            );
                          } else {
                            return Text(
                              _rows[index][1].toString(),
                              style: GoogleFonts.overpass(
                                  color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            )
                                // loadingBuilder:
                                //     (BuildContext context,
                                //         Widget child,
                                //         ImageChunkEvent?
                                //             loadingProgress) {
                                //   if (loadingProgress == null) {
                                //     return child;
                                //   }
                                //   return const Center(
                                //       child:
                                //           CircularProgressIndicator());
                                // },
                                ;
                          }
                        } else {
                          return Text(snapshot.connectionState.toString());
                        }
                      }))
                ]),
              ));
        }),
      ),
    );
  }
}