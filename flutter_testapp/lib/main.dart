import 'package:flutter/material.dart';
import 'generated/i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_testapp/newPage.dart';
import 'package:flutter_testapp/otherPage.dart';
import 'Tool.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() => runApp(MyApp());

GlobalKey<_FreeLocalizations> freeLocalizationStateKey1 =
new GlobalKey<_FreeLocalizations>(); //

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(

      onGenerateTitle: (BuildContext context) => S.of(context).app_name,
      localizationsDelegates: const [
        S.delegate,
        //如果你在使用 material library，需要添加下面两个delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: "app",
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Builder(builder: (context) {
        return new FreeLocalizations(
          key: freeLocalizationStateKey1,
          child: new MyHomePage(),
        );
      }),
    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  bool flag = true;

  void changeLocale() {
  Navigator.of(context).push(MaterialPageRoute(builder: (context){
    return newDetailPage();
  }));
  }

  @override
  Widget build(BuildContext context) {
    freeLocalizationStateKey1.currentState.listen();
    return new Scaffold(
        appBar: AppBar(
          title: new Text(S.of(context).app_test), // 此处
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                S.of(context).app_test,
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.display1,
              ),
              FlatButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                  return OtherPage();
                }));
              }, child: Icon(Icons.add_a_photo,size: 30,))
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: changeLocale,
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )); // Th
  }
}



class FreeLocalizations extends StatefulWidget {
  final Widget child;

  FreeLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<FreeLocalizations> createState() {
    return new _FreeLocalizations();
  }
}

class _FreeLocalizations extends State<FreeLocalizations> {
  Locale _locale = const Locale('en', '');

  Future<Locale> getDeviceLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageStr = prefs.getString('languageCode');
    String country = prefs.getString('countryCode');
    return Locale(languageStr, country);
  }

  //监听bus
  void listen(){
    eventBus.on<Locale>().listen((locale){
      changeLocale(locale);
    });
  }

  changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future<Locale> locale = getDeviceLocale();
    locale.then((locales) {
      changeLocale(locales);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Localizations.override(
      context: context,
      locale: _locale,
      child: widget.child,
    );
  }
}