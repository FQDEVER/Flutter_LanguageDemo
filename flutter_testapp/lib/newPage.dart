import 'package:flutter/material.dart';
import 'package:flutter_testapp/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Tool.dart';

class newDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FreeLocalizations(
      child: newppDetailPage(),
    );
  }
}

class newppDetailPage extends StatefulWidget {
  @override
  _newppDetailPageState createState() => _newppDetailPageState();
}

class _newppDetailPageState extends State<newppDetailPage> {
  _setCurrentDeviceLocale(Locale deviceLocale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', deviceLocale.languageCode);
    prefs.setString('countryCode', deviceLocale.countryCode);

    eventBus.fire(deviceLocale);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).app_information),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: () {
                _setCurrentDeviceLocale(Locale("en", ""));
              },
              child: Text(S.of(context).app_en)),
          FlatButton(
              onPressed: () {
                _setCurrentDeviceLocale(Locale("zh", "CN"));

              },
              child: Text(S.of(context).app_cn)),
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(S.of(context).app_auto)),
        ],
      )),
    );
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
  Locale _locale = Locale("en", "");

  Future<Locale> getDeviceLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageStr = prefs.getString('languageCode');
    String country = prefs.getString('countryCode');
    return Locale(languageStr, country);
  }

  //监听bus
  void listen() {
    eventBus.on<Locale>().listen((locale) {
      changeLocale(locale);
    });
  }

  changeLocale(Locale locale) {
    if (!mounted) {
      return;
    }

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
//    listen(); 是否需要全部更新
    return new Localizations.override(
      context: context,
      locale: _locale, // widget.locale,
      child: widget.child,
    );
  }
}
