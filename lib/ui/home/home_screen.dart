import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/ui/home/tabs/settings_tab.dart';
import 'package:to_do_app/ui/home/tabs/task_tab.dart';
import 'package:to_do_app/ui/home/widgets/add_task_bottom_sheet.dart';
import 'package:to_do_app/ui/login/login_screen.dart';

import '../../style/app_colors.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            context: context,
            builder: (context) => const AddTaskBottomSheet(),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10,
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.list,
                size: 33,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.settings,
                size: 33,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              AppBar(
                title: const Text(
                  'To Do List',
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, LoginScreen.routeName);
                      FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(
                      Icons.logout,
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: currentIndex == 0,
                child: Positioned(
                  bottom: -40,
                  left: 0,
                  right: 0,
                  child: EasyInfiniteDateTimeLine(
                    firstDate: DateTime.now(),
                    focusDate: selectedDate,
                    lastDate: DateTime.now().add(
                      const Duration(
                        days: 365,
                      ),
                    ),
                    showTimelineHeader: false,
                    dayProps: EasyDayProps(
                      width: 58,
                      height: 79,
                      dayStructure: DayStructure.dayStrDayNum,
                      todayStyle: DayStyle(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      inactiveDayStyle: DayStyle(
                        dayStrStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      activeDayStyle: DayStyle(
                        dayStrStyle: const TextStyle(
                          color: AppColors.lightPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        dayNumStyle: const TextStyle(
                          color: AppColors.lightPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDateChange: (newDate) {
                      setState(() {
                        selectedDate = newDate;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 44,
          ),
          Expanded(
            child: currentIndex == 0 ? TaskTab(selectedDate) : SettingsTab(),
          ),
        ],
      ),
    );
  }
}
