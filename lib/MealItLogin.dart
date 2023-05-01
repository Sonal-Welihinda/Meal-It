import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_it/MealItRegister.dart';
import 'package:meal_it/Models/BusinessLayer.dart';
import 'package:meal_it/PageLayers/HomePage.dart';

class MealItLogin  extends StatelessWidget{
  const MealItLogin({super.key});



  @override
  Widget build(BuildContext context) {
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    final BusinessLayer _businessL = BusinessLayer();

    Future loginUser(context) async{
      String result = await _businessL.loginUser(email.text, password.text);
      if (result =="Success") {
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
              // AspectRatio(
              //   child: Image.asset("assets/Images/MealItLogo.png"),
              //   aspectRatio: 1/1
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset("assets/Images/MealItLogo.png",
                  width: double.infinity,
                ),
              ),

              Text("Welcome to Meal It",
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 30
                ),
              ),

              const SizedBox(height: 40),
              // Email address
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email address",
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(225, 77, 42, 1)
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 1)
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white,width: 2)
                    ),
                  ),
                )
              ),

              // Pass word field
              Container(
                  padding: EdgeInsets.only(left: 20,right: 20,top: 20),
                  child: TextField(
                    controller: password,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                          color: Color.fromRGBO(225, 77, 42, 1)
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white,width: 1)
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white,width: 2)
                      ),
                    ),
                  )
              ),

              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                padding: EdgeInsets.only(right: 20,left: 20),
                child: TextButton.icon(

                  style: TextButton.styleFrom(
                    backgroundColor: Color.fromRGBO(225, 77, 42, 1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                  ),

                  onPressed: (){
                    loginUser(context);
                  },
                  label: Text("Login",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
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