import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateUserPage extends StatefulWidget{


  @override
  State createState(){
    return _CreateUserState();
  }
}

class _CreateUserState extends State<CreateUserPage>{
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
      appBar: AppBar(
        title: Text("Registro K.O.B.E"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Crear Usuario", style: TextStyle(color: Colors.black, fontSize: 24),),
          ),
          Offstage(
            offstage: error == '',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Usuario creado", style: TextStyle(color: Colors.red, fontSize: 16),),
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: formulario(),
            ),
            butonCrearUsuario(),
        ],
      ),
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

  Widget butonCrearUsuario(){
    return FractionallySizedBox(
      widthFactor: 0.6,
    child: ElevatedButton(
      onPressed: () async{

        if(_formkey.currentState!.validate()){
          _formkey.currentState!.save();
          UserCredential? credenciales = await crear(email, password);
          if(credenciales !=null){
            if(credenciales.user != null){
              await credenciales.user!.sendEmailVerification();
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: Text("Registrarse")
      ),
    );
  }


  Future<UserCredential?> crear(String email, String passwd) async{
    try{
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email,
        password: password);
      return userCredential;

    } on FirebaseException catch(e){
      if(e.code == 'email-already-in-use'){
        //todo crear contraseña
        setState(() {
          error = "El correo ya se encuentra en uso";
        });
      }
      if(e.code == 'wrong-password'){
        //Toda contraseña muy debil
        setState(() {
          error = "contraseña debil";
        });
      }
    }catch(e){
      print(e.toString());
    }
  }
}