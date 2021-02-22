import 'dart:async';
import 'dart:convert';
import '../config/coap_config.dart';
import 'package:coap/coap.dart';
import 'package:flutter/material.dart';
import 'package:first_project/screens/login.dart';

TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

class SignUpPage extends StatefulWidget {
  final CoapClient client;

  SignUpPage({Key key, @required this.client}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _data;
  bool _isLoading = false;

  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;
  String _warning = "";
  bool _warningVisible = false;

  TextStyle warningStyle =
  TextStyle(fontFamily: 'Montserrat', fontSize: 14.0, color: Colors.red);

  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();

    super.dispose();
  }

  Future<void> _checkCredentials(String email, String password) async {
    _warning = "";

    if (email == "" || password == ""){
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
        _request.addUriPath('signup');
        _request.maxRetransmit = 3;

        //request.setPayload("{\"email\": \"gabrielbandeira@gmail.com\", \"password\": \"12345678\"}");
         widget.client.request = _request;

        setState(() => _isLoading = true);

        print("ANTES DO REQUEST s");
        var response = await  widget.client
            .put("{\"email\": \"$email\", \"password\": \"$password\"}");
        print("DEPOIS DO REQUEST s");

        //_client.cancelRequest();

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
            if (_status == "500") {
              _warning = "Usuário já cadastrado!";
            } else if (_status == "200") {
              _warning = "Usuário cadastrado com sucesso!";
              //_warningVisible = false;
              //Navigator.pop(context);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => LoginPage()),
              // );
            } else {
              _warning = "Credenciais inválidas!";
            }
          }
        });
      } catch(e) {
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
      controller: _controllerEmail,
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

    final signupButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.teal,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _isLoading ? null : () {
          _checkCredentials(_controllerEmail.text, _controllerPassword.text);
        },
        child: Text("Cadastrar-se",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    TextStyle defaultStyle = TextStyle(color: Colors.grey, fontSize: 20.0);
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
                    SizedBox(height: 170.0),
                    Text(
                      "Cadastro",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(height: 55.0),
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
                    signupButton,
                    SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
