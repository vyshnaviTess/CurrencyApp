import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final Function onClear;

  const SearchWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onSearch,
    required this.onClear,
  }) : super(key: key);

  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    final styleActive = TextStyle(color: Colors.black);
    final styleHint = TextStyle(color: Colors.black54);
    final style = widget.controller.text.isEmpty ? styleHint : styleActive;
    return Container(
      height: 42,
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.black26),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        key: const Key('search_bar_text_field'),
        controller: widget.controller,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: style.color),
          suffixIcon: suffixIcon(context, style),
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: style,
        onChanged: (term) {
          setState(() {
            widget.onSearch(term);
          });
        },
      ),
    );
  }

  IconButton? suffixIcon(BuildContext context, TextStyle style) {
    return widget.controller.text.isNotEmpty
        ? IconButton(
            key: const Key('search_bar_close_button'),
            onPressed: () {
              widget.controller.clear();
              FocusScope.of(context).requestFocus(FocusNode());
              widget.onClear();
            },
            icon: Icon(Icons.close, color: style.color),
          )
        : null;
  }
}
