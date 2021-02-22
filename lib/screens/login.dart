import 'dart:async';
import 'dart:convert';
import '../config/coap_config.dart';
import 'package:coap/coap.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:first_project/screens/patient_login.dart';
import 'package:first_project/screens/signup.dart';
import 'package:first_project/screens/patient_menu.dart';


TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

class PreLoginPage extends StatefulWidget {
  PreLoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PreLoginPageState createState() => _PreLoginPageState();
}

class _PreLoginPageState extends State<PreLoginPage> {

  final _config = CoapConfig();
  final _host =  '192.168.0.22'; //'192.168.1.110';//'192.168.0.182';//
  // Client
  CoapClient _client;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _client = CoapClient(
        Uri(scheme: 'coap', host: _host, port: _config.defaultPort), _config);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 1),
            () =>
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginPage(client: _client))));



    return MaterialApp(
      home: Scaffold(
        /* appBar: AppBar(
          title: Text("MyApp"),
          backgroundColor:
              Colors.blue, //<- background color to combine with the picture :-)
        ),*/
        body: Container(
          decoration: new BoxDecoration(color: Colors.white),
          child: new Center(
            child:                     SizedBox(
              height: 155.0,
              child: Image.asset(
                "assets/logoblack.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ), //<- place where the image appears
      ),
    );
  }
}


class LoginPage extends StatefulWidget {
  final CoapClient client;

  LoginPage({Key key, @required this.client}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _data;
  bool _isLoading = false;


  TextEditingController _controllerLogin;
  TextEditingController _controllerPassword;
  String _warning = "";
  bool _warningVisible = false;

  TextStyle warningStyle =
      TextStyle(fontFamily: 'Montserrat', fontSize: 14.0, color: Colors.red);

  void initState() {
    super.initState();
    _controllerLogin = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  void dispose() {
    _controllerLogin.dispose();
    _controllerPassword.dispose();

    super.dispose();
  }



  Future<void> _checkLogin(String email, String password) async {
    _warning = "";
    if (email == "" || password == "") {
      setState(() {
        _warningVisible = true;
        if (email == "") {
          _warning = "Informe o e-mail!";
        } else if (password == "") {
          _warning = "Informe a senha!";
        }
      });
    } else {
      try {
        // Create the request for the get request
        var _request = CoapRequest.newPut();
        _request.addUriPath('signin');
        _request.maxRetransmit = 3;
        //request.setPayload("{\"email\": \"gabrielbandeira@gmail.com\", \"password\": \"12345678\"}");
         widget.client.request = _request;

        setState(() => _isLoading = true);
        print("ANTES DO REQUEST");
        var response = await  widget.client
            .put("{\"email\": \"$email\", \"password\": \"$password\"}");

        print("DEPOIS DO REQUEST");

        // widget.client.cancelRequest();

        setState(() {
          _isLoading = false;
          _warningVisible = true;
          if (response == null) {
            _warning = "Erro de conexão!";
          } else {
            _data = response.payloadString ?? 'No Data';
            print(_data);
            Map _dataJson = jsonDecode(_data);
            String _status = _dataJson["status"];
            if (_status == "200") {
              _warningVisible = false;
              var _token = _dataJson["token"];
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientMenuPage(token: _token, client: widget.client,)),
              );
            } else {
              _warning = "E-mail ou senha incorretos!";
            }
          }
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _node = FocusScope.of(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    final emailField = TextField(
      controller: _controllerLogin,
      onEditingComplete: () => _node.nextFocus(),
      // Move focus to next
      obscureText: false,
      style: style,
      //keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "E-mail",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: _controllerPassword,
      onSubmitted: (_) => _node.unfocus(),
      // Submit and hide keyboard
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Senha",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.teal,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _isLoading
            ? null
            : () {
                _checkLogin(_controllerLogin.text, _controllerPassword.text);
              },
        child: Text("Entrar",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 16.0);
    TextStyle linkStyle = TextStyle(color: Colors.blue);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    SizedBox(
                      height: 155.0,
                      child: Image.asset(
                        "assets/logoblack.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      "BodyMeasure",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(height: 30.0),
                    emailField,
                    SizedBox(height: 15.0),
                    passwordField,
                    SizedBox(
                      height: 15.0,
                    ),
                    if (_warningVisible)
                      Text(
                        _warning,
                        style: warningStyle,
                      ),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (_isLoading) CircularProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.teal,
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: _isLoading
                            ? null
                            : () {
                                _checkLogin(_controllerLogin.text,
                                    _controllerPassword.text);
                              },
                        child: Text("Entrar",
                            textAlign: TextAlign.center,
                            style: style.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    RichText(
                      text: TextSpan(
                        style: defaultStyle,
                        children: <TextSpan>[
                          TextSpan(text: 'Não tem uma conta? '),
                          TextSpan(
                              text: 'Registre-se aqui!',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage(client: widget.client)),
                                  );
                                }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
