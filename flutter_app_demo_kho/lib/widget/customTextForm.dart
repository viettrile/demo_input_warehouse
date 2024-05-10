import 'package:flutter/material.dart';
import 'package:flutter_app_demo_kho/configs/colors.dart';
import 'package:flutter_app_demo_kho/configs/const.dart';

class CustomTextFormField extends StatefulWidget {
  final String name;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  // final String placeHolder;
  final FocusNode focusNode;
  final String? errorText;
  // final String iconSuffix;
  final String labelText;
  final String initialValue;
  final String iconAssetPath;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();

  const CustomTextFormField({
    required this.name,
    required this.keyboardType,
    this.onChanged,
    // required this.iconSuffix,
    // required this.placeHolder,
    required this.focusNode,
    required this.errorText,
    required this.initialValue,
    required this.labelText,
    required this.iconAssetPath,
    Key? key,
  }) : super(key: key);
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isInvisible = false;
  @override
  void initState() {
    // isInvisible = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cornerLarge),
          boxShadow: widget.focusNode.hasFocus
              ? [
                  BoxShadow(
                    color: lightColorScheme.surfaceTint,
                    blurRadius: 12,
                    offset: Offset(0, 0),
                  ),
                ]
              : null),
      child: TextFormField(
        // controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: (value) {
          if (widget.onChanged != null) widget.onChanged!(value);
          print(value);
        },
        keyboardType: widget.keyboardType,
        obscureText: isInvisible,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          fillColor: lightColorScheme.onSecondary,
          filled: true,
          // labelText: '${widget.name}',
          labelStyle: TextStyle(color: lightColorScheme.scrim),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(cornerNormal),
            borderSide: BorderSide(
              color: Colors.transparent,
              // inputBackgroundColor,
              width: 1.6,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(cornerNormal),
            borderSide: BorderSide(
              // color: Theme.of(context).primaryColor,
              color: lightColorScheme.surfaceTint,
              width: 1.6,
            ),
          ),
          contentPadding: EdgeInsets.only(top: 14),
          // ignore: unnecessary_null_comparison
          prefixIcon: widget.iconAssetPath != null
              ? Padding(
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    widget.iconAssetPath,
                    fit: BoxFit.contain,
                  ),
                )
              : null,
          // suffixIcon: widget.iconSuffix != null
          //     ? Padding(
          //         padding: EdgeInsets.all(12.0),
          //         child: Image.asset(widget.iconSuffix, fit: BoxFit.contain),
          //       )
          //     : null,
          // hintText: widget.placeHolder,
          hintStyle: TextStyle(
            color: lightColorScheme.tertiary,
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "${widget.labelText} Please enter";
          }
          return null;
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class CustomTextFormField extends StatelessWidget {
//   final String labelText;
//   final String initialValue;
//   final TextInputType keyboardType;

//   final FormFieldSetter<String> onSaved;
//   final FormFieldValidator<String>? validator;
//   final TextInputType keyboardType;
//   final bool isPassword;

//   CustomTextFormField({
//     Key? key,
//     this.labelText="",
    
//     this.initialValue="",
//     required this.onSaved,
//     this.validator,
//     this.keyboardType = TextInputType.text,
//     this.isPassword = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       initialValue: initialValue,
//       // onSaved: onSaved,
//       // validator: validator,
//       // keyboardType: keyboardType,
//       // obscureText: isPassword,
//       // decoration: InputDecoration(
//       //   labelText: labelText,
//       //   border: OutlineInputBorder(
//       //     borderRadius: BorderRadius.circular(10.0),
//       //   ),
//       //   filled: true,
//       //   fillColor: Colors.white,
//       //   contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//       // ),
//       focusNode: widget.focusNode,
//         onChanged: (value) {
//           if (widget.onChanged != null) widget.onChanged!(value);
//         },
//         keyboardType: widget.keyboardType,
//         obscureText: isInvisible,
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.normal,
//         ),
//         decoration: InputDecoration(
//           fillColor: inputBackgroundColor,
//           filled: true,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(cornerLarge),
//             borderSide: BorderSide(
//               color: Colors.transparent,
//               // inputBackgroundColor,
//               width: 1.6,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(cornerLarge),
//             borderSide: BorderSide(
//               // color: Theme.of(context).primaryColor,
//               color: Colors.transparent,
//               width: 1.6,
//             ),
//           ),
//       // style: TextStyle(fontSize: 16.0),
//         ),
//     );
//   }
// }
