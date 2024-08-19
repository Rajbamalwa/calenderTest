import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class EventDetailWidget extends StatelessWidget {
  var eventData;
  EventDetailWidget({this.eventData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue.shade800,
        centerTitle: false,
        title: Text(
          "Event",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.blue.shade800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 5),
                  child: Container(
                    height: 10,
                    width: 20,
                    color: eventData['status'] == "Confirmed"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 20, bottom: 5, right: 10),
                  child: Text(
                    capitalizeFirstLetter(eventData['title'].toString()),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  formatDateTime2(
                          DateTime.parse(eventData['startAt'].toString()))
                      .toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                capitalizeFirstLetter(eventData['description'].toString()),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
