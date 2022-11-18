import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class loginPage extends StatefulWidget {

  const  loginPage({Key? key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  //final _formkey=GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final  TextEditingController _passwordController = TextEditingController();
  String email= " ";
  String password=" ";
  bool isHidden = false;

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _register() async{
    final User? user = (await _auth.createUserWithEmailAndPassword(email: _emailController.text,
        password: _passwordController.text)).user;
    if(user != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => loginPage())
      );
    }
  }

  void signIn() async{
    final User? user = (await _auth.signInWithEmailAndPassword(email: _emailController.text,
        password: _passwordController.text)).user;
    if(user != null){
      Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen())
      );
    }
  }

  void resetPass() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.deepPurple,
          content: Text('Reset Link has been sent to entered email.'),
        ),
      );
    } on FirebaseAuthException catch (e){
      if (e.code=='user-not-found'){
        print('No user found for that email');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepPurple,
            content: Text('No user found for that email'),
          ),
        );
      }
    }
  }

  Widget _renderLogin(){
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/timeb2.jpg'), fit: BoxFit.fill),),
          padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Image.asset('assets/timesmall.png', width: 200),
          ),
          const SizedBox(height: 60),
          TextField(
            controller: _emailController,
            autofocus: false,
            autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellow,
                hintText: 'Email',
                icon: const Icon(Icons.email_outlined, color: Colors.yellow),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
          ),
          Container(
            height: 0.1,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 20,),
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofocus: false,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.yellow,
              hintText: 'Password',
              icon: const Icon(Icons.lock_outline_rounded, color: Colors.yellow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                side: const BorderSide(width: 2.0, color: Colors.deepPurple),
                shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text("Login",
              style: TextStyle(
                  color: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 22,),
              ),
              onPressed: () async{
                final email = _emailController.text;
                final password = _passwordController.text;
                if (email.isEmpty || password.isEmpty){
                  showDialog(context: context, builder: (_) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Enter your email and password'),
                      actions:[
                        TextButton(child:const Text("OK"),
                          onPressed: () =>  Navigator.of(context, rootNavigator: true).pop('dialog'),
                        )
                      ],
                  ));
                  return;
                }
                signIn();
              },
            ),
          ),
          const SizedBox(height: 40.0),
          MaterialButton(
              child: const Text(
                "Create Account",
                style: TextStyle(color: Colors.yellow),
              ),
            onPressed: () {
                setState(() {
                  _selectedIndex=1;
                });
            },
          ),
          const SizedBox(height: 10.0),
          MaterialButton(
              child: const Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.yellow),
              ),
            onPressed: (){
                setState(() {
                  _selectedIndex=2;
                });
            },
          )
        ],
      ),
    );
  }

  Widget _createAccount(){
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/timeb2.jpg'), fit: BoxFit.fill),),
      padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/timesmall.png', width: 200),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            autofocus: false,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.yellow,
              hintText: 'Your Name',
              icon: const Icon(Icons.person_outline, color: Colors.yellow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Container(
            height: 0.1,
            color: Colors.deepPurple,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _emailController,
            autofocus: false,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.yellow,
              hintText: 'Email',
              icon: const Icon(Icons.email_outlined, color: Colors.yellow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          Container(
            height: 0.1,
            color: Colors.deepPurple,
          ),
          SizedBox(height: 20,),
          TextField(
            controller: _passwordController,
            obscureText: true,
            autofocus: false,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.yellow,
              hintText: 'Password',
              icon: const Icon(Icons.lock_outline_rounded, color: Colors.yellow),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                side: const BorderSide(width: 2.0, color: Colors.deepPurple),
                shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text("Register",
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,),
              ),
              onPressed: () async{
                final email = _emailController.text;
                final password = _passwordController.text;
                if (email.isEmpty || password.isEmpty){
                  showDialog(context: context, builder: (_) => AlertDialog(
                    title: const Text('Error'),
                    content: const Text('Please enter your name, email and password'),
                    actions:[
                      TextButton(child:const Text("OK"),
                        onPressed: () =>  Navigator.of(context, rootNavigator: true).pop('dialog'),
                      )
                    ],
                  ));
                  return;
                }
                _register();
              },
            ),
          ),
          const SizedBox(height: 40.0),
          MaterialButton(
            child: const Text(
              "Already have an account? Login",
              style: TextStyle(color: Colors.yellow),
            ),
            onPressed: () {
              setState(() {
                _selectedIndex=0;
              });
            },
          ),
          const SizedBox(height: 10.0),
          MaterialButton(
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.yellow),
            ),
            onPressed: (){
              setState(() {
                _selectedIndex=2;
              });
            },
          )
        ],
      ),
    );
  }
  Widget _forgotPass(){
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/timeb2.jpg'),fit: BoxFit.fill),),
      padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/timesmall.png', width: 200),
          ),
          const SizedBox(height: 50),
          Container(
            height: 0.1,
            color: Colors.deepPurple,
          ),
          TextField(
            controller: _emailController,
            autofocus: false,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.yellow,
              hintText: 'Your Email',
              icon: const Icon(Icons.email_outlined, color: Colors.yellow),
              floatingLabelStyle: TextStyle(color: Colors.black),
              //focusedBorder: InputBorder.none,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 40.0),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                side: const BorderSide(width: 2.0, color: Colors.deepPurple),
                shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),),
              child: const Text(
                "Reset Password",
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onPressed: () {
                resetPass();
              },
            ),
          ),
          const SizedBox(height: 40.0),
          MaterialButton(
            child: const Text(
              "Back to Login",
              style: TextStyle(color: Colors.yellow),
            ),
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
        ],
      ),
    );
  }
  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);
  @override
  Widget build(BuildContext context) {
    final Size screenSize=MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset : false,
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _renderLogin(),
          _createAccount(),
          _forgotPass(),
        ],
      ),
    );
  }
}