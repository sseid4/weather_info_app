import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(length: 4, child: _TabsNonScrollableDemo()),
    );
  }
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() => __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;

  final RestorableInt tabIndex = RestorableInt(0);

  // Weather UI state
  final TextEditingController _cityController = TextEditingController();
  String _city = '--';
  String _temperature = '--';
  String _condition = '--';
  List<Map<String, String>> _forecast = [];

  void _fetchWeather() {
    final cityName = _cityController.text.trim();
    if (cityName.isEmpty) return;
    final temp = 15 + (DateTime.now().millisecondsSinceEpoch % 16); // 15-30
    final conditions = ['Sunny', 'Cloudy', 'Rainy'];
    final cond = (conditions..shuffle()).first;
    setState(() {
      _city = cityName;
      _temperature = '$temp°C';
      _condition = cond;
    });
  }

  void _fetchForecast() {
    final cityName = _cityController.text.trim();
    if (cityName.isEmpty) return;
    final conditions = ['Sunny', 'Cloudy', 'Rainy'];
    final List<Map<String, String>> forecast = [];
    for (int i = 0; i < 7; i++) {
      final temp = 15 + (DateTime.now().millisecondsSinceEpoch % 16) + i;
      conditions.shuffle();
      forecast.add({
        'day': 'Day ${i + 1}',
        'city': cityName,
        'temp': '$temp°C',
        'cond': conditions.first,
      });
    }
    setState(() {
      _forecast = forecast;
    });
  }

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For the To do task hint: consider defining the widget and name of the tabs here
    final tabs = ['Monday', 'Tuesday', 'Wednesday', 'Thursday'];
    final tabColors = [
      Colors.blue[50],
      Colors.pink[50],
      Colors.green[50],
      Colors.yellow[50],
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tabs Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [for (final tab in tabs) Tab(text: tab)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // hint for the to do task:Considering creating the different for different tabs
          // Tab 1: Weather UI
          Container(
            color: tabColors[0],
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          labelText: 'Enter city name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchWeather,
                        child: Text('Fetch Weather'),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _fetchForecast,
                        child: Text('7-Day Forecast'),
                      ),
                      SizedBox(height: 32),
                      Text('City: $_city', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text(
                        'Temperature: $_temperature',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Condition: $_condition',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 32),
                      if (_forecast.isNotEmpty) ...[
                        Text(
                          '7-Day Forecast:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Column(
                          children: _forecast
                              .map(
                                (day) => Card(
                                  child: ListTile(
                                    title: Text(
                                      '${day['day']} - ${day['city']}',
                                    ),
                                    subtitle: Text(
                                      'Temp: ${day['temp']} | Condition: ${day['cond']}',
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Tab 2: text and image
          Container(
            color: tabColors[1],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Enter something',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tab 3: Button widget
          Container(
            color: tabColors[2],
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Button pressed in ${tabs[2]} tab!'),
                    ),
                  );
                },
                child: Text('Click me'),
              ),
            ),
          ),
          // Tab 4: ListView Widgets
          Container(
            color: tabColors[3],
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text('Item 1'),
                    subtitle: Text('Details about Item 1'),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text('Item 2'),
                    subtitle: Text('Details about Item 2'),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: ListTile(
                    title: Text('Item 3'),
                    subtitle: Text('Details about Item 3'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueGrey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Bottom App Bar',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
