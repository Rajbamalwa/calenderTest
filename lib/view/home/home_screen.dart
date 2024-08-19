import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/event.dart';
import '../../service/api_services/api_service.dart';
import '../../utils/utils.dart';
import '../event_detail/event_detail_widget.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  late DateTime focusedDay;
  late DateTime firstDay;
  late DateTime lastDay;

  late Box<Event> eventBox;
  Map<DateTime, List> eventsMap = {};
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    focusedDay = DateTime.now();
    firstDay = DateTime(1900);
    lastDay = DateTime(2100);
    calendarFormat = CalendarFormat.month;

    loadEvents();
    _loadData();
  }

  List<dynamic> events = [];
  List<dynamic> selectedEvents = [];

  void _loadData() async {
    final apiService = ApiService();
    await apiService.fetch();
    events = await getStoredData();
    log("data -- ${events.toString()}");
    _prepareEventMap();
    setState(() {});
  }

  void _prepareEventMap() {
    for (var event in events) {
      DateTime startAt = DateTime.parse(event['startAt']);
      DateTime eventDate = DateTime(startAt.year, startAt.month, startAt.day);

      if (eventsMap[eventDate] == null) {
        eventsMap[eventDate] = [];
      }
      eventsMap[eventDate]!.add(event);
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focus) {
    setState(() {
      selectedDate = selectedDay;
      focusedDay = focus;

      selectedEvents = events.where((event) {
        DateTime startAt = DateTime.parse(event['startAt']);
        return selectedDay.day == startAt.day &&
            selectedDay.month == startAt.month &&
            selectedDay.year == startAt.year;
      }).toList();
      log("events --------- ${events.toString()}");
    });
  }

  Future<List<dynamic>> getStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('eventData');
    if (jsonString != null) {
      return json.decode(jsonString);
    } else {
      return [];
    }
  }

  Future<void> loadEvents() async {
    eventBox = Hive.box<Event>('eventsBox');
    setState(() {
      eventsMap = {};
      for (var event in eventBox.values) {
        DateTime date = DateTime(
            event.startAt.year, event.startAt.month, event.startAt.day);
        if (eventsMap[date] == null) {
          eventsMap[date] = [];
        }
        eventsMap[date]!.add(event);
      }
    });
  }

  List<dynamic> _eventLoader(DateTime day) {
    DateTime eventDate = DateTime(day.year, day.month, day.day);
    return eventsMap[eventDate] ?? [];
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue.shade800,
        centerTitle: true,
        title: Text(
          "The Calender",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.blue.shade800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                child: TableCalendar(
                    pageJumpingEnabled: true,
                    availableGestures: AvailableGestures.all,
                    // calendarFormat: calendarFormat,
                    calendarFormat: calendarFormat,
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,
                    firstDay: firstDay,
                    lastDay: lastDay,
                    focusedDay: focusedDay,
                    currentDay: selectedDate,
                    pageAnimationCurve: Curves.slowMiddle,
                    formatAnimationCurve: Curves.easeOutCirc,
                    pageAnimationDuration: const Duration(milliseconds: 100),
                    dayHitTestBehavior: HitTestBehavior.deferToChild,
                    daysOfWeekHeight: 30,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                      CalendarFormat.twoWeeks: '2 Weeks',
                      CalendarFormat.week: 'Week'
                    },
                    daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: const TextStyle(),
                        weekendStyle: const TextStyle(),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7))),
                    eventLoader:
                        _eventLoader, // Load events for the selected day
                    selectedDayPredicate: (day) =>
                        isSameDay(day, DateTime.now()),
                    onDaySelected: _onDaySelected,
                    onDayLongPressed: (date, time) {},
                    onHeaderTapped: (DateTime datetime) {
                      setState(() {
                        datetime = focusedDay;
                      });
                    },
                    onPageChanged: (focus) {
                      setState(() {
                        focusedDay = focus;
                      });
                    },
                    holidayPredicate: (d) {
                      return true;
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        calendarFormat = format;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      outsideDaysVisible: false,
                      weekendTextStyle: TextStyle(color: Colors.black),
                      holidayTextStyle: TextStyle(color: Colors.blue.shade900),
                      holidayDecoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      selectedDecoration: const BoxDecoration(
                          color: Colors.black, shape: BoxShape.circle),
                      selectedTextStyle: TextStyle(color: Colors.black),
                      defaultTextStyle: TextStyle(color: Colors.black),
                      canMarkersOverflow: false,
                      markerDecoration: BoxDecoration(color: Colors.black),
                      tablePadding: const EdgeInsets.all(10),
                      todayDecoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(5)),
                      defaultDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.grey.shade300),
                      weekendDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade400),
                    ),
                    headerVisible: true,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      headerPadding: const EdgeInsets.only(bottom: 20),
                      formatButtonDecoration: BoxDecoration(
                        border: Border.all(color: Colors.blue.shade900),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      titleTextStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      selectedBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(3.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            date.day.toString(),
                            style: const TextStyle(color: Colors.white),
                          )),
                      todayBuilder: (context, date, events) => Container(
                          margin: const EdgeInsets.all(3.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(color: Colors.white),
                          )),
                      markerBuilder: (context, day, events) {
                        if (events.isNotEmpty) {
                          return Container(
                            width: 15,
                            height: 15,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              '${events.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                            ),
                          );
                        }
                        return SizedBox();
                      },
                    ))),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 6),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  formatDateTime(selectedDate).toString(),
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              controller: scrollController,
              itemCount: selectedEvents.length,
              itemBuilder: (context, index) {
                final event = selectedEvents[index];
                print("date date date ==== ${event['startAt']}");
                return Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EventDetailWidget(
                                    eventData: event,
                                  )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 5,
                              width: 10,
                              color: event['status'] == "Confirmed"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              capitalizeFirstLetter(event['title'].toString()),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          capitalizeFirstLetter(
                              event['description'].toString()),
                          maxLines: 2,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
