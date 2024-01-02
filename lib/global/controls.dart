import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ndy/global/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ndy/views/search_view.dart';

class TagComponent extends StatefulWidget {
  final String title;
  final IconData icon;

  TagComponent({required this.title, required this.icon});

  @override
  _TagComponentState createState() => _TagComponentState();
}

class _TagComponentState extends State<TagComponent> {
  List<String> strings = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.title, style: const TextStyle(color: Constant.activeColor, fontSize: Constant.smallMedText)),
              IconButton(
                icon:  Icon(
                  widget.icon,
                  color: Constant.activeColor,
                  size: Constant.smallMedText,
                ),
                splashColor: Colors.transparent, // Remove splash effect
                highlightColor: Colors.transparent, // Remove highlight effect
                onPressed: () async {
                  List<String> result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchTagView()),
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



class CustomSearchBar extends StatefulWidget {
  final Color rectangleColor;
  final String title;
  final Color titleColor;
  final double titleSize;
  final Function(List<String>) onTagsUpdated;

  CustomSearchBar({
    required this.rectangleColor,
    required this.title,
    required this.titleColor,
    required this.titleSize,
    required this.onTagsUpdated,
  });

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<String> searchResults = [];
  bool _hasSearched = false; 
  List<String> addedTags = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    searchTags(_searchController.text);
  }

  void addTag(String tag) {
    if (addedTags.length < 3 && !addedTags.contains(tag)) {
      setState(() {
        addedTags.add(tag);
      });
      widget.onTagsUpdated(addedTags);
    }
  }

  void removeTag(String tag) {
    setState(() {
      addedTags.remove(tag);
    });
    widget.onTagsUpdated(addedTags);
  }

  void searchTags(String query) async {
    if (query.isNotEmpty) {
      // Define the end range for the query
      String endRange = query.substring(0, query.length - 1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1);

      var snapshot = await FirebaseFirestore.instance
          .collection('tags')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: endRange)
          .get();
      var docs = snapshot.docs;

      setState(() {
        searchResults = docs.map((doc) => doc.id).toList();
        _hasSearched = true; 
        print(searchResults);
      });
    } else {
      setState(() {
        searchResults = [];
         _hasSearched = false; 
      });
    }
  }
@override
Widget build(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: 35,
        color: widget.rectangleColor,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(
                    color: Constant.activeColor,
                    fontSize: Constant.smallMedText,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  color: Constant.activeColor,
                  fontSize: Constant.smallMedText,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: Constant.mediumSpacing),
      if (_searchController.text.isNotEmpty)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _searchController.text,
              style: const TextStyle(fontSize: Constant.smallMedText, color: Constant.activeColor),
            ),
            InkWell(
              onTap: () => addTag(_searchController.text),
              child: const Text("create", style: TextStyle(fontSize: Constant.smallMedText, color: Constant.inactiveColor)),
            ),
          ],
        ),
        const SizedBox(height: Constant.smallSpacing),
      ...searchResults.map((result) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                result,
                style: const TextStyle(fontSize: Constant.smallMedText, color: Constant.activeColor),
              ),
              InkWell(
                onTap: () => addTag(result),
                child: const Text("add", style: TextStyle(fontSize: Constant.smallMedText, color: Constant.inactiveColor)),
              ),
            ],
          )).toList(),
      const SizedBox(height: Constant.largeSpacing),
      const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Added Tags",
            style: TextStyle(fontSize: Constant.smallMedText, color: Constant.activeColor),
          ),
        ],
      ),
      const SizedBox(height: Constant.smallSpacing),
    Column(
      children: addedTags.map<Widget>((tag) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tag,
                  style: const TextStyle(fontSize: Constant.smallMedText, color: Constant.activeColor),
                ),
                InkWell(
                  onTap: () => removeTag(tag),
                  child: const Text("remove", style: TextStyle(fontSize: Constant.smallMedText, color: Constant.inactiveColor)),
                ),
              ],
            ),
            SizedBox(height: Constant.smallSpacing),
          ],
        );
      }).toList(),
    ),
    ],
  );
}

}

class CustomAppBar extends StatelessWidget {
  final List<String> data;
  final String title;
  final Color titleColor;
  final double titleSize;
  final Color iconColor;
  final double iconSize;

  CustomAppBar({
    required this.data,
    required this.title,
    required this.titleColor,
    required this.titleSize,
    required this.iconColor,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      color: Colors.transparent,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              // Handle the back navigation
              Navigator.pop(context, data);
            },
            child: Icon(Icons.arrow_back, color: iconColor, size: iconSize),
          ),
          Spacer(), // Pushes everything to the start and end
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: titleSize,
            ),
          ),
          Spacer(), // Ensures the title is centered
        ],
      ),
    );
  }
}