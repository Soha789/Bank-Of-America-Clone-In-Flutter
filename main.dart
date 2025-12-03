import 'package:flutter/material.dart';

void main() {
  runApp(const BankApp());
}

class BankApp extends StatelessWidget {
  const BankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Banking Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A4BA0),
        ),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}

/// Simple fake-auth gate to replace FirebaseAuth.
/// Login with:  email = demo@bankapp.com, password = password123
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoggedIn = false;
  String _error = '';

  final TextEditingController _emailController =
      TextEditingController(text: 'demo@bankapp.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'password123');

  void _tryLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Fake user check: replace this with real Firebase later
    if (email == 'demo@bankapp.com' && password == 'password123') {
      setState(() {
        _isLoggedIn = true;
        _error = '';
      });
    } else {
      setState(() {
        _error = 'Invalid email or password (try the demo credentials).';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn) {
      return const HomeScreen();
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Banking Demo Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (_error.isNotEmpty)
                  Text(
                    _error,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _tryLogin,
                    child: const Text('Log In'),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Demo credentials:\n'
                  'demo@bankapp.com / password123',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    AccountsPage(),
    TransfersPage(),
    BillsPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return 'Accounts';
      case 1:
        return 'Transfers';
      case 2:
        return 'Bill Payments';
      case 3:
        return 'Notifications';
      case 4:
        return 'Profile';
      default:
        return 'Banking Demo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForIndex(_selectedIndex)),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onNavTap,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet),
            label: 'Accounts',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Transfers',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Bills',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class AccountsPage extends StatelessWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = [
      {
        'name': 'Checking Account',
        'number': '**** 1234',
        'balance': 1520.75,
      },
      {
        'name': 'Savings Account',
        'number': '**** 9876',
        'balance': 8200.00,
      },
      {
        'name': 'Credit Card',
        'number': '**** 4567',
        'balance': -340.20,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: accounts.length,
      itemBuilder: (context, index) {
        final account = accounts[index];
        final balance = account['balance'] as double;
        final isNegative = balance < 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(account['name'] as String),
            subtitle: Text(account['number'] as String),
            trailing: Text(
              (isNegative ? '- \$' : '\$') +
                  balance.abs().toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isNegative ? Colors.red : Colors.green,
              ),
            ),
          ),
        );
      },
    );
  }
}

class TransfersPage extends StatelessWidget {
  const TransfersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fromController = TextEditingController();
    final toController = TextEditingController();
    final amountController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const Text(
            'Transfer Funds',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: fromController,
            decoration: const InputDecoration(
              labelText: 'From Account',
              hintText: 'e.g. Checking ****1234',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: toController,
            decoration: const InputDecoration(
              labelText: 'To Account',
              hintText: 'e.g. Savings ****9876',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Amount',
              hintText: 'e.g. 100.00',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Demo only: transfer simulated.'),
                ),
              );
            },
            icon: const Icon(Icons.send),
            label: const Text('Send Money'),
          ),
        ],
      ),
    );
  }
}

class BillsPage extends StatelessWidget {
  const BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bills = [
      {
        'name': 'Electricity',
        'due': 'Dec 10',
        'amount': 120.50,
      },
      {
        'name': 'Internet',
        'due': 'Dec 12',
        'amount': 60.00,
      },
      {
        'name': 'Water',
        'due': 'Dec 15',
        'amount': 45.30,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final bill = bills[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(bill['name'] as String),
            subtitle: Text('Due: ${bill['due']}'),
            trailing: FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Demo only: Paid ${bill['name']} bill.',
                    ),
                  ),
                );
              },
              child: Text(
                '\$${(bill['amount'] as double).toStringAsFixed(2)}',
              ),
            ),
          ),
        );
      },
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      'Payment of \$45.30 to Water Utility completed.',
      'Salary of \$2,500.00 credited to Checking Account.',
      'Credit Card payment of \$340.20 received.',
      'Electricity bill due on Dec 10.',
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(items[index]),
        );
      },
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Demo User',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: Text(
              'demo@bankapp.com',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Security'),
            subtitle: const Text('Change demo password (UI only)'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Demo only: no real backend.'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notification Preferences'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                      Text('Demo only: notification settings not saved.'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
