import 'package:flutter/material.dart';
import 'package:whatsapp_clone/resources/colors.dart';

class WebSearch extends StatelessWidget {
  const WebSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.width * 0.25,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: dividerColor))),
        child: TextField(
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10),
              filled: true,
              fillColor: searchBarColor,
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.search, size: 20),
              ),
              hintText: "Search for the chat",
              hintStyle: const TextStyle(fontSize: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      const BorderSide(style: BorderStyle.none, width: 0))),
        ));
  }
}
