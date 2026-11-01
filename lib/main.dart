import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart' show LucideIcons;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Widgets'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _nav = 0;

  static const _items = [
    NavItem(label: 'home', icon: LucideIcons.house),
    NavItem(label: 'forecast', icon: LucideIcons.zap),
    NavItem(label: 'history', icon: LucideIcons.clock),
    NavItem(label: 'menu', icon: LucideIcons.menu),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: widget.title, showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const AppText.display('0.10 kW'),
          const AppText.h1('Login'),
          const AppText.h2('Sunny Day'),
          const AppText.h3("TODAY'S WEATHER"),
          const AppText.body('Body text'),
          const SizedBox(height: 16),
          AppButton(label: 'Login', onPressed: () {}),
          const SizedBox(height: 8),
          const AppButton(label: 'Continue with Google', variant: AppButtonVariant.outline),
          const SizedBox(height: 16),
          const AppForm(
            child: Column(
              children: [
                InputBox(id: 'email', placeholder: 'Enter email'),
                SizedBox(height: 12),
                InputBox(id: 'password', placeholder: 'Password', isPassword: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [AppText.h3('CARD'), AppText.h2('Card content')],
            ),
          ),
          const SizedBox(height: 8),
          const PlaceholderCard(),
          const SizedBox(height: 16),
          const Row(
            children: [
              AppIcon(LucideIcons.zap),
              SizedBox(width: 16),
              AppIcon(LucideIcons.sun, circled: true),
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        items: _items,
        currentIndex: _nav,
        onTap: (i) => setState(() => _nav = i),
      ),
    );
  }
}