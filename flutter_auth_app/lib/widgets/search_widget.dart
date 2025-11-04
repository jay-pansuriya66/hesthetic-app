import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/search/search_controller.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final Function(String)? onItemSelected;
  final SearchControllerX controller = Get.put(SearchControllerX());
  var lastValue ="";

  SearchWidget({
    super.key,
    this.hintText = 'Search...',
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 84,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
            children: [
              Column(
                children: [
                  // Search Box

                  const SizedBox(height: 16, width: double.infinity),

                  // Container(
                  //   height: 100,
                  //   width: double.infinity,
                  //   color: Colors.blue,
                  //   alignment: Alignment.center,
                  //   child: const Text(
                  //     'Blue Box',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  // ),
                ],
              ),

              // Results
              Positioned(
                top:
                    20, // Adjust this value based on your layout (height of search bar + padding)
                left: 0,
                right: 100,
                bottom: 0,
                child: Column(
                  children: [
                    // Example: Optional title or search bar
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        fillColor: const Color.fromARGB(0, 0, 0, 0),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                      onChanged: (value) async {
                        controller.query.value = value;
                        lastValue = value;

                        if (value.isNotEmpty) {
                          await Future.delayed(const Duration(seconds: 2));
                          if (lastValue == value) {
                            controller.searchItems();
                          }
                        } else {
                          controller.results.clear();
                        }
                      },
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => controller.searchItems(),
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        // If no results
                        if (controller.results.isEmpty) {
                          return const Center(
                            child: Text('No results found'),
                          );
                        }

                        // ListView for displaying items
                        return ListView.builder(
                          itemCount: controller.results.length,
                          itemBuilder: (context, index) {
                            final item = controller.results[index];
                            return GestureDetector(
                              onTap: () => controller.getAddress(item),
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  title: Text(item),
                                  leading: const Icon(Icons.search),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }
}
