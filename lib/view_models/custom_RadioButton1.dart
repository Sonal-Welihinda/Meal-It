import 'package:flutter/material.dart';

class CustomRadioButton1 extends StatefulWidget {
  final IconData icon;
  final String label;
  late bool isSelected =false;
  final Function onSelect;
  late var value;
  late var groupValue;
  Color iconColor = Colors.white;
  Color defaultIconColor = Colors.redAccent;
  Color backgroundColor = Colors.white;

  Color defaultBgColor = Colors.green;

  CustomRadioButton1({required this.icon, required this.label,isSelected, required this.onSelect,required this.groupValue,required this.value,iconColor,backgroundColor,defaultBgColor,defaultIconColor}){
    if(iconColor != null){
      this.iconColor = iconColor;
    }

    if(defaultIconColor != null){
      this.defaultIconColor = defaultIconColor;
    }

    if(defaultBgColor != null){
      this.defaultBgColor = defaultBgColor;
    }

    // if(iconColor != null){
    //   this.iconColor = iconColor;
    // }


  }




  @override
  _CustomRadioButton1State createState() => _CustomRadioButton1State();

}

class _CustomRadioButton1State extends State<CustomRadioButton1> {



  @override
  void didUpdateWidget(covariant CustomRadioButton1 oldWidget)  {

    // if(oldWidget!=this.widget){
    //   super.didUpdateWidget(this.widget);
    // }else{
    //   super.didUpdateWidget(oldWidget);
    // }

    if (widget.value == widget.groupValue){
      setState(() {
        widget.isSelected = true;
      });

    }else{
      setState(() {

        widget.isSelected = false;
      });


    }

    super.didUpdateWidget(widget);


  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,

      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: widget.isSelected ? widget.backgroundColor : widget.defaultBgColor,
      ),

      child: InkWell(

        onTap: () {
          // widget.onSelect(widget.value);


          widget.onSelect.call(widget.value);

        },

        child: Row(

          children: [
            Icon(
              widget.icon,
              color: widget.isSelected ? widget.iconColor : widget.defaultIconColor,
              size: 30.0,
            ),
            SizedBox(width: 10.0),
            Text(
              widget.label,
              style: TextStyle(fontSize: 18.0,color: widget.isSelected ? widget.iconColor : widget.defaultIconColor),
            ),
          ],
        ),
      ),
    );
  }
}
