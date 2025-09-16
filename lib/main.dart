import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(length: 1, child: _TabsNonScrollableDemo()),
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
    _tabController = TabController(initialIndex: 0, length: 1, vsync: this);
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
    final tabs = ['Main'];
    final tabColors = [Colors.blue[50]];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Weather App'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [Tab(text: tabs[0])],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Main Tab: Weather UI
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
