import 'package:flutter/material.dart';
import 'package:flutter_testapp/generated/i18n.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Tool.dart';


class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeLocalizationsStatus(
      child: OtherDetailPage(),
    );
  }
}

class OtherDetailPage extends StatefulWidget {
  @override
  _OtherDetailPageState createState() => _OtherDetailPageState();
}

class _OtherDetailPageState extends State<OtherDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).app_information),
        ),
        body: Center(
          child: Text(S.of(context).app_information),
        ),
      );
  }
}

//做国际化

class ChangeLocalizationsStatus extends StatefulWidget {
  final Widget child;
  ChangeLocalizationsStatus({Key key,this.child}):super(key : key);

  @override
  _ChangeLocalizationsStatusState createState() => _ChangeLocalizationsStatusState();
}

class _ChangeLocalizationsStatusState extends State<ChangeLocalizationsStatus> {
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
    print("----------------------"+_locale.toString());
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
