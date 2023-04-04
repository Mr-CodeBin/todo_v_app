import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  TextEditingController taskContorller = TextEditingController();

  bool isDone = false;

  List<String> TaskData = [];

  void addTask(BuildContext context, String task) async {
    setState(() {
      TaskData.add(task);
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList("TaskData", TaskData as List<String>);
  }

  void deleteTask(BuildContext context, int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List task = pref.getStringList("TaskData") ?? [];
    task.remove(task[index]);
    setState(() {
      TaskData = task as List<String>;
    });
    pref.setStringList("TaskData", TaskData as List<String>);
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    TaskData = pref.getStringList("TaskData") ?? [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  showAnimation() async {
    setState(() {
      isDone = true;
    });
    Future.delayed(
      Duration(seconds: 3),
    ).then((value) {
      setState(() {
        isDone = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(220, 255, 255, 255),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Stack(
              children: [
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 44,
                        ),
                        TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          "All ToDos",
                          style: GoogleFonts.roboto(
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: TaskData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  extentRatio: 0.48,
                                  motion: ScrollMotion(),
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 12, 0),
                                        child: GestureDetector(
                                          onTap: () {
                                            deleteTask(context, index);
                                            log(TaskData.toString());
                                          },
                                          child: Container(
                                            height: 72,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.delete_rounded,
                                              color: Colors.white,
                                              size: 28,
                                            )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 12, 0),
                                        child: GestureDetector(
                                          onTap: () {
                                            showAnimation();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                backgroundColor: Colors.blue,
                                                content: Text(
                                                  "Well Done!",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                showCloseIcon: true,
                                                // action: SnackBarAction(
                                                //   label: "ok",
                                                //   disabledTextColor: Colors.white,
                                                //   onPressed: () {},
                                                // ),
                                              ),
                                            );
                                            deleteTask(context, index);
                                          },
                                          child: Container(
                                            height: 72,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Done",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                child: Container(
                                  height: 72,
                                  width: _size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Text(
                                          TaskData[index].toString(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 64,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Container(
                        width: _size.width,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(239, 239, 239, 1),
                                spreadRadius: 10,
                                blurRadius: 8),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: TextField(
                                controller: taskContorller,
                                decoration: InputDecoration(
                                  hintText: 'Add Task',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (taskContorller.text.trim().isEmpty) {
                                  log("task field is empty");
                                  return;
                                }
                                addTask(context, taskContorller.text.trim());
                                taskContorller.clear();
                              },
                              child: Icon(
                                Icons.add_circle,
                                size: 52,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: isDone,
                  child: Center(
                    child: LottieBuilder.network(
                      "https://assets10.lottiefiles.com/packages/lf20_eRt4aHeLmL.json",
                    ),
                  ),
                )
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
