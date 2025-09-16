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

  // 7-day forecast data
  List<Map<String, String>> _forecast = [];

  void _fetchWeather() {
    final cityName = _cityController.text.trim();
    if (cityName.isEmpty) {
      // Added basic validation feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a city name')),
      );
      return;
    }
    final temp = 15 + (DateTime.now().millisecondsSinceEpoch % 16); // 15-30
    final conditions = ['Sunny', 'Cloudy', 'Rainy'];
    final cond = (conditions..shuffle()).first;
    setState(() {
      _city = cityName;
      _temperature = '$temp°C';
      _condition = cond;
    });
    // Added success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Weather updated for $cityName')),
    );
  }

  void _fetch7DayForecast() {
    final cityName = _cityController.text.trim();
    if (cityName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a city name')),
      );
      return;
    }

    // Generate 7-day forecast data
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final conditions = ['Sunny', 'Cloudy', 'Rainy'];
    List<Map<String, String>> newForecast = [];
    
    for (int i = 0; i < 7; i++) {
      final temp = 15 + ((DateTime.now().millisecondsSinceEpoch + i * 1000) % 16);
      final condition = (conditions..shuffle()).first;
      
      newForecast.add({
        'day': days[i],
        'temperature': '$temp°C',
        'condition': condition,
      });
    }
    
    setState(() {
      _forecast = newForecast;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('7-day forecast loaded for $cityName')),
    );
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
    _cityController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For the To do task hint: consider defining the widget and name of the tabs here
    final tabs = ['Monday', 'Tuesday', 'Wednesday', 'Thursday'];
    final tabColors = [
      Colors.blue[50],
      Colors.orange[50],
      Colors.green[50],
      Colors.yellow[50],
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Weather Info App'), 
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
          // Tab 1: Weather UI with 7-day forecast button (Monday tab)
          Container(
            color: tabColors[0],
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Weather image
                    Image.network(
                      'https://cdn-icons-png.flaticon.com/512/1163/1163661.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Enter city name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    // Two buttons: current weather and 7-day forecast
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _fetchWeather,
                          child: Text('Fetch Weather'),
                        ),
                        ElevatedButton(
                          onPressed: _fetch7DayForecast,
                          child: Text('7-Day Forecast'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
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
                  ],
                ),
              ),
            ),
          ),
          // Tab 2: 7-Day Forecast Display (Tuesday tab - was text and image)
          Container(
            color: tabColors[1],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    '7-Day Weather Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                  SizedBox(height: 16),
                  if (_forecast.isEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.calendar_view_week,
                              size: 80,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No forecast data available',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Go to Weather tab and tap "7-Day Forecast"',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: _forecast.length,
                        itemBuilder: (context, index) {
                          final dayForecast = _forecast[index];
                          return Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.orange[200],
                                child: Text(
                                  dayForecast['day']![0],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ),
                              title: Text(
                                dayForecast['day']!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(dayForecast['condition']!),
                              trailing: Text(
                                dayForecast['temperature']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Tab 3: Button widget (Wednesday tab - unchanged)
          Container(
            color: tabColors[2],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://cdn-icons-png.flaticon.com/512/1077/1077114.png',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Button pressed in ${tabs[2]} tab!'),
                        ),
                      );
                    },
                    child: Text('Click me'),
                  ),
                ],
              ),
            ),
          ),
          // Tab 4: ListView Widgets (Thursday tab - unchanged)
          Container(
            color: tabColors[3],
            child: Column(
              children: [
                // List/Menu image at top
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/1164/1164954.png',
                    width: 80,
                    height: 80,
                  ),
                ),
                Expanded(
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