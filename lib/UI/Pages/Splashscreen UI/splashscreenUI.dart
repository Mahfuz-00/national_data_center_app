import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../Access Form (Guest)/accessFormGuestUI.dart';
import '../Login UI/loginUI.dart';
import '../Sign Up UI/signupUI.dart';

/// [SplashScreenUI] is a StatefulWidget that represents the splash screen
/// of the application. It displays a logo, a title, and buttons for
/// navigating to different screens: login, signup, and guest access form.
///
/// The splash screen features animations for transitioning the UI elements.
///
/// Variables:
/// - [animationController]: Controller for managing animation effects.
/// - [FadeAnimation]: Animation for fading elements in and out.
/// - [SlideAnimation]: Animation for sliding elements vertically.
/// - [animatedpadding]: Animation for applying padding transitions.
///
/// Actions:
/// - [initState()]: Initializes the animation controller and animations.
/// - [dispose()]: Disposes of the animation controller.
class SplashScreenUI extends StatefulWidget {
  const SplashScreenUI({super.key});

  @override
  State<SplashScreenUI> createState() => _SplashScreenUIState();
}

class _SplashScreenUIState extends State<SplashScreenUI>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> FadeAnimation;
  late Animation<Offset> SlideAnimation;
  late Animation<Offset> animatedpadding;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    SlideAnimation = Tween(begin: const Offset(0, 3), end: const Offset(0, 0))
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeInOutCirc));
    FadeAnimation = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    animatedpadding = Tween(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.easeIn));

    Future.delayed(const Duration(seconds: 5), () {
      animationController.forward();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(246, 246, 246, 255),
            Color.fromRGBO(246, 246, 246, 255)
          ],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage(
                'Assets/Images/BCC-Logo.png',
              ),
              width: 200,
              height: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            SlideTransition(
              position: animatedpadding,
              child: const Padding(
                padding: EdgeInsets.all(30),
                child: Text(
                  'NDC Access',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'default',
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                FadeTransition(
                  opacity: FadeAnimation,
                  child: const Image(
                    image: AssetImage('Assets/Images/Powered by TNS.png'),
                    height: 100,
                    width: 150,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                SlideTransition(
                  position: SlideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginUI()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(13, 70, 127, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            //elevation: 3,
                            fixedSize: Size(screenWidth * 0.9, 70),
                          ),
                          child: const Text('Login',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'default',
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupUI()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            //elevation: 3,
                            fixedSize: Size(screenWidth * 0.9, 70),
                          ),
                          child: const Text('Register',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'default',
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AccessFormGuestUI()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: const Color.fromRGBO(13, 70, 127, 1),
                                  width: 2),
                            ),
                            fixedSize: Size(screenWidth * 0.9, 70),
                          ),
                          child: const Text('Access Form (Only Guest)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(13, 70, 127, 1),
                                fontFamily: 'default',
                              )))
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
