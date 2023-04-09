import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_it/MealItRegister.dart';
import 'package:meal_it/PageLayers/HomePage.dart';

class MealItLogin  extends StatelessWidget{
  const MealItLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    Future loginUser(context) async{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      if (userCredential != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Success fully login'),

          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('failed login'),
          ),
        );
      }

    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(

            children: [
              const SizedBox(height: 60),

              //logo and title
              const Icon(Icons.login,
                size: 100,
              ),
              Text("Meal It Login page",
                style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 30
                ),
              ),

              const SizedBox(height: 40),
              // Email address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(

                    hintText: "Email address",
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600,width: 1)
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black87,width: 2)
                    )
                  ),
                )
              ),

              // Pass word field
              Container(
                  padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                  child: TextField(
                    controller: password,
                    decoration: InputDecoration(
                      hintText: "Password",
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade600,width: 1)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87,width: 2)
                      )
                    ),
                  )
              ),

              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                padding: EdgeInsets.only(right: 20,left: 20),
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade400,

                  ),

                  onPressed: (){
                    loginUser(context);
                  },
                  label: Text("Login",
                    style: TextStyle(fontSize: 28),
                  ),
                  icon: Icon(Icons.login_sharp,
                    size: 28,
                  ),

                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 20,left: 20,right: 20),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      "Already have account? ",
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(167, 167, 167, 1)
                      ),

                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              settings: RouteSettings(name: "/LoginPage"),
                              builder: (context) => MealItRegister()),
                        );
                      },
                      child: Text("Signup",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.red
                        ),
                      ),
                    ),
                  ],
                ),
              )




            ],

          )

        )
      )
    );
  }

}