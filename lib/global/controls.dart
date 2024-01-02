import 'package:flutter/material.dart';
import 'package:ndy/global/constants.dart';

class CustomComponent extends StatefulWidget {
  final String title;
  final IconData icon;

  CustomComponent({required this.title, required this.icon});

  @override
  _CustomComponentState createState() => _CustomComponentState();
}

class _CustomComponentState extends State<CustomComponent> {
  List<String> strings = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.title),
              IconButton(
                icon: Icon(widget.icon),
                onPressed: () async {
                  List<String> result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondView()),
                  );
                  setState(() {
                    strings = result;
                  });
                },
              ),
            ],
          ),
          // Using collection if inside the children list
          if (strings.isNotEmpty) 
            TagBubbleComponent(
              tags: strings, 
              textColor: Constant.activeColor, 
              textSize: Constant.smallMedText, 
              bubbleColor: Constant.inactiveColor,
            ),
        ],
      ),
    );
  }

}

class SecondView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy array of strings, replace with your logic
    List<String> arrayOfStrings = ["String 1", "String 2", "String 3"];

    return Scaffold(
      appBar: AppBar(
        title: Text("Second View"),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Return to Previous Screen"),
          onPressed: () {
            Navigator.pop(context, arrayOfStrings);
          },
        ),
      ),
    );
  }
}

class TagBubbleComponent extends StatelessWidget {
  final List<String> tags;
  final Color textColor;
  final double textSize;
  final Color bubbleColor;
  final double bubbleSize;

  const TagBubbleComponent({
    Key? key,
    required this.tags,
    required this.textColor,
    required this.textSize,
    required this.bubbleColor,
    this.bubbleSize = 50.0, // Default size if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: tags.map((tag) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(bubbleSize / 2), // This creates the rounded corners
          ),
          alignment: Alignment.center,
          child: Text(
            tag,
            style: TextStyle(
              color: textColor,
              fontSize: textSize,
            ),
          ),
        );
      }).toList(),
    );
  }
}
