import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:expense_tracker/models/database_provider.dart';
import 'package:expense_tracker/widgets/expense_form.dart';

import 'package:expense_tracker/widgets/scroll_view/list_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'category_list.dart';

class CategoryFetcher extends StatefulWidget {
  const CategoryFetcher({
    super.key,
    required NotchBottomBarController controller,
    required PageController pageController,
  })  : _controller = controller,
        _pageController = pageController;

  final NotchBottomBarController _controller;
  final PageController _pageController;

  @override
  State<CategoryFetcher> createState() => _CategoryFetcherState();
}

class _CategoryFetcherState extends State<CategoryFetcher> {
  final _controller = PageController();

  late Future _categoryList;

  Future _getCategoryList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchCategories();
  }

  @override
  void initState() {
    super.initState();
    _categoryList = _getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categoryList,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: 500,
                    child: ListViewer(_controller),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 2,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.deepPurple.shade700,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Colors.deepPurple.shade400,
                              Colors.blue.shade400,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Expenses:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: (Colors.white),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                PageChanger().changePage(widget._controller,
                                    widget._pageController, 2);
                              },
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 49, 0, 162),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Expanded(child: CategoryList()),
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
