import 'package:dairy_app/widgets/new_dairy_card.dart';
import 'package:flutter/material.dart';
// import './widgets/search_and_menu.dart';
import './widgets/front_view.dart';
import './widgets/back_view.dart';
import './add_diary_screen.dart';
import 'diary_entry.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController controller;
  List<DiaryEntry> diaryEntries = [];
  int selectedCardIndex = -1;
  bool showFront = true;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void toggleView(int index) {
    setState(() {
      if (selectedCardIndex == index) {
        // Toggle between front and back views
        showFront = !showFront;
        if (showFront) {
          controller.reverse();
        } else {
          controller.forward();
        }
      } else {
        selectedCardIndex = index;
        showFront =
            true; // Show the front view when a different card is clicked
        controller.forward(from: 0.5);
      }
    });
  }

  void addDiaryEntry(DiaryEntry entry) {
    setState(() {
      diaryEntries.add(entry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search and menu
            // const SearchAndMenu(),
            const SizedBox(height: 30.0),

            // Year selector
            DropdownButton<String>(
              value: '2022',
              items: const [
                DropdownMenuItem<String>(value: '2022', child: Text('2022'))
              ],
              onChanged: (String? value) {},
            ),
            const SizedBox(height: 30.0),

            // New diary card
            const SizedBox(height: 20.0),

            // Diary cards
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: PageView.builder(
                  controller: PageController(
                    initialPage: 0,
                    viewportFraction: 0.78,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: diaryEntries.length + 1,
                  itemBuilder: (_, i) {
                    if (i == 0) {
                      return NewDiaryCard(
                        onTap: () {
                          _navigateToAddDiary(context);
                        },
                      );
                    } else {
                      final reversedIndex = diaryEntries.length - i;
                      final diaryEntry = diaryEntries[reversedIndex];
                      return GestureDetector(
                        onTap: () {
                          toggleView(reversedIndex + 1); // Increment index by 1
                        },
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            final rotationValue =
                                reversedIndex == selectedCardIndex - 1
                                    ? controller.value
                                    : 0.0;
                            final rotationAngle = rotationValue * 3.141592;
                            final isFront = rotationValue <= 0.5;
                            final angle = isFront
                                ? rotationAngle
                                : rotationAngle + 3.141592;
                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(angle),
                              alignment: Alignment.center,
                              child: isFront
                                  ? FrontView(
                                      diaryEntry: diaryEntry,
                                    )
                                  : BackView(
                                      diaryEntry: diaryEntry,
                                    ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }

  void _navigateToAddDiary(BuildContext context) async {
    final newEntry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddDiaryScreen(),
      ),
    );
    if (newEntry != null && newEntry is DiaryEntry) {
      addDiaryEntry(newEntry);
    }
  }
}
