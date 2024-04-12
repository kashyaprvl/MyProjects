import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust duration as needed
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn, // Scale up to 80%,
    );
    _controller?.forward();
    _controller?.addListener(() {
      if (_controller!.isCompleted) {
        Navigator.pushReplacementNamed(context, '/home'); // Replace with your desired route
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Adjust background color as needed
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
              padding:const EdgeInsets.all(15),
              child: ScaleTransition(
                scale: _scaleAnimation!,
                child: Image.asset('assets/splashLogo.png',fit:  BoxFit.fill,height: 170,width: 170,), // Replace with your logo path
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 15),
            padding: const EdgeInsets.all(15),
            child: ScaleTransition(
              scale: _scaleAnimation!,
              child:   Text("Video Compress",style: GoogleFonts.mulish(fontSize: 28,fontWeight: FontWeight.w600,),), // Replace with your logo path
            ),
          ),
        ],
      ),
    );
  }
}
