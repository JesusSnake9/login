import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kobe_flutter/CreateUserPage.dart';
import 'package:kobe_flutter/MyHomePage.dart';

class LoginPage extends StatefulWidget{


  @override
  State createState(){
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage>{
  late String email, password;
  final _formkey = GlobalKey<FormState>();
  String error='';

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Login Page", style: TextStyle(color: Colors.black, fontSize: 24),),
          ),
          Offstage(
            offstage: error == '',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(error, style: TextStyle(color: Colors.red, fontSize: 16),),
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formulario(),
            ),
            butonLogin(),
            nuevoAqui(),
        ],
      ),
    );
  }

  Widget nuevoAqui(){
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Nuevo aqui"),
        TextButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateUserPage()));

        }, child: Text("Registrarse")),
      ],
    );
  }

  Widget formulario(){
    return Form(
      key: _formkey,
        child: Column(children: [
          buildEmail(),
          const Padding(padding: EdgeInsets.only(top: 12)),
          buildPassword()
    ],));
  }

  Widget buildEmail(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Email" ,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.black)
        )
      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value) {
      email = value!;
      },
      validator: (value){
        if(value!.isEmpty){
          return "Este campo es obligatorio";
        }
        return null;
      },
    );
  }

  Widget buildPassword(){
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: new BorderSide(color: Colors.black)
        )
      ),
      obscureText: true,
      validator: (value){
        if(value!.isEmpty){
          return "Este campo es obligatorio";
        }
        return null;
      },
      onSaved: (String? value) {
      password = value!;
      },
    );
  }

  Widget butonLogin(){
    return FractionallySizedBox(
      widthFactor: 0.6,
    child: ElevatedButton(
      onPressed: () async{

        if(_formkey.currentState!.validate()){
          _formkey.currentState!.save();
          UserCredential? credenciales = await login(email, password);
          if(credenciales !=null){
            if(credenciales.user != null){
              if(credenciales.user!.emailVerified){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyHomePage()),
                  (Route<dynamic> route) => false);
              }
              else{
                //todo mostrar que debe verificar su email
                setState(() {
                  error = "Debes verificar tu correo antes de acceder";
                });
              }
            }
          }
        }

        
      },
      child: Text("Login")
      ),
    );
  }


  Future<UserCredential?> login(String email, String passwd) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email,
        password: password);
      return userCredential;
    } on FirebaseException catch(e){
      if(e.code == 'User-not-found'){
        //todo usuario no encontrado
        setState(() {
          error = "Usuario no encontrado";
        });
      }
      if(e.code == 'wrong-password'){
        //Toda contraseña incorrecta
        setState(() {
          error = "contraseña incorrecta";
        });
      }
    }
  }
}