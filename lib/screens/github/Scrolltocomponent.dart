import 'package:flutter/material.dart';

class ScrollToComponentExample extends StatefulWidget {
  const ScrollToComponentExample({Key? key}) : super(key: key);

  @override
  _ScrollToComponentExampleState createState() => _ScrollToComponentExampleState();
}

class _ScrollToComponentExampleState extends State<ScrollToComponentExample> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _componentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll To Component Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                final context = _componentKey.currentContext;
                if (context != null) {
                  _scrollController.animateTo(
                    context.size?.height ?? 0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: const Text('Scroll to Component'),
            ),
            Expanded(
              child: ListView(
                controller: _scrollController,
                children: [
                  Container(
                    height: 1000,
                    color: Colors.blue,
                    child: const Center(
                      child: Text('Top Component'),
                    ),
                  ),
                  Container(
                    key: _componentKey,
                    height: 1000,
                    color: Colors.green,
                    child: const Center(
                      child: Text('Scroll To Component'),
                    ),
                  ),
                  Container(
                    height: 1000,
                    color: Colors.red,
                    child: const Center(
                      child: Text('Bottom Component'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
