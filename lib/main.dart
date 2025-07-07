import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test_1/model/currency_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_test_1/utils/get_current_time.dart';
import 'package:flutter_test_1/utils/show_snack_bar.dart';
import '../widgets/item_container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('fa')],

      theme: ThemeData(
        fontFamily: 'iranSans',
        textTheme: TextTheme(
          headlineMedium: TextStyle(fontFamily: 'iranSans', fontSize: 16),
          bodySmall: TextStyle(
            fontSize: 13,
            color: Color.fromARGB(255, 30, 30, 30),
          ),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
          labelSmall: TextStyle(fontSize: 13, color: Colors.red),
          labelMedium: TextStyle(fontSize: 13, color: Colors.green),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future responseFuture;
  bool isLoading = false;
  String? lastUpdateTime;
  @override
  void initState() {
    super.initState();
    responseFuture = getResponse();
    lastUpdateTime = getCurrentTime();
  }

  List<Currency> currency = [];

  Future getResponse() async {
    var url =
        'https://sasansafari.com/flutter/api.php?access_key=flutter123456';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      List jsonList = convert.jsonDecode(response.body);
      if (jsonList.isNotEmpty) {
        setState(() {
          for (var item in jsonList) {
            currency.add(
              Currency(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                changes: item['changes'],
                status: item['status'],
              ),
            );
          }
        });
      }
      return response;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          const SizedBox(width: 18),
          Image.asset("assets/images/money.png"),
          const SizedBox(width: 12),
          Text(
            'قیمت به روز ارز',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Image.asset("assets/images/menu.png"),
            ),
          ),
          const SizedBox(width: 18),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Image.asset("assets/images/q.png"),
                const SizedBox(width: 8),
                Text(
                  'نرخ ارز آزاد چیست؟',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ' نرخ ارزها در معاملات نقدی و رایج روزانه است معاملات نقدی معاملاتی هستند که خریدار و فروشنده به محض انجام معامله، ارز و ریال را با هم تبادل می نمایند.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(1000)),
                color: Color.fromARGB(255, 130, 130, 130),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'نام آزاد ارز',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text('قیمت', style: Theme.of(context).textTheme.bodyMedium),
                  Text('تغییر', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : listFutureBuilder(context),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 232, 232),
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    child: TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color.fromARGB(255, 202, 193, 255),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1000),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        currency.clear();
                        await getResponse();
                        showSnackBar(context, 'بروزرسانی با موفقیت انجام شد');

                        setState(() {
                          lastUpdateTime = getCurrentTime();
                          isLoading = false;
                        });
                      },
                      icon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                        child: Icon(
                          CupertinoIcons.refresh,
                          color: Colors.black,
                        ),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Text(
                          'بروزرسانی',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'آخرین بروزرسانی: ${lastUpdateTime ?? '---'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  FutureBuilder<dynamic> listFutureBuilder(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: currency.length,
                itemBuilder: (BuildContext context, int position) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ItemContainer(currency: currency[position]),
                  );
                },
              )
            : Center(child: CircularProgressIndicator());
      },

      future: responseFuture,
    );
  }
}
