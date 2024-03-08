import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  }) ;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool visibility = false;

  void initState()
  {
    super.initState();
    visibility = widget.obscureText;
  }



  @override

  Widget build(BuildContext context) 
  {
  
    return SizedBox(
      width: 450,
      height: 35 ,
      child: TextField(
        controller: widget.controller,
        obscureText: visibility,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black),
          suffixIcon : widget.obscureText
               ? IconButton(
                onPressed: ()
                {
                  setState(()
                  {
                    visibility = !visibility;
                  });
                }, 
                icon: Icon(
                  visibility ? Icons.visibility_off: Icons.visibility,
                  color: Colors.black,
                )) 
                : null,
          //suffix icon will be only displayed if the text field is used to enter a password
          
        ),
      ),
    );

  }
}