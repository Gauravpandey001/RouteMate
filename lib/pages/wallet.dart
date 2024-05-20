import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class WalletScreen extends StatefulWidget {
  final String userId;

  WalletScreen({required this.userId});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late DatabaseReference _userRef;
  String _userName = '';
  String _userEmail = '';
  String? _imageUrl;
  double _walletBalance = 1500.0; // Initial mock balance
  List<Map<String, dynamic>> _transactionHistory = [];

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.reference().child('users').child(widget.userId);
    _getUserData();
    _loadMockTransactionHistory();
  }

  Future<void> _getUserData() async {
    try {
      DataSnapshot snapshot = await _userRef.get();
      if (snapshot.exists) {
        dynamic userData = snapshot.value;
        if (userData != null && userData is Map<dynamic, dynamic>) {
          setState(() {
            _userName = '${userData['firstName']} ${userData['lastName']}' ?? 'No Name';
            _userEmail = userData['email'] ?? 'No Email';
            _imageUrl = userData['profileImageUrl'];
          });
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void _loadMockTransactionHistory() {
    _transactionHistory = [
      {'type': 'Credit', 'amount': 500.0, 'date': '2024-05-14'},
      {'type': 'Debit', 'amount': 200.0, 'date': '2024-05-13'},
      {'type': 'Credit', 'amount': 300.0, 'date': '2024-05-12'},
      {'type': 'Debit', 'amount': 150.0, 'date': '2024-05-11'},
      {'type': 'Credit', 'amount': 700.0, 'date': '2024-05-10'},
    ];
  }

  void _addMoney(double amount) {
    setState(() {
      _walletBalance += amount;
      _transactionHistory.add({
        'type': 'Credit',
        'amount': amount,
        'date': DateTime.now().toIso8601String(),
      });
    });
  }

  void _withdrawMoney(double amount) {
    if (amount <= _walletBalance) {
      setState(() {
        _walletBalance -= amount;
        _transactionHistory.add({
          'type': 'Debit',
          'amount': amount,
          'date': DateTime.now().toIso8601String(),
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Insufficient balance'),
        ),
      );
    }
  }

  void _showAddMoneyOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Add Money with Google Pay'),
                onTap: () {
                  Navigator.pop(context);
                  _addMoneyDialog();
                },
              ),
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Add Money with Paytm'),
                onTap: () {
                  Navigator.pop(context);
                  _addMoneyDialog();
                },
              ),
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Add Money with Debit/Credit Card'),
                onTap: () {
                  Navigator.pop(context);
                  _addMoneyDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _addMoneyDialog() {
    TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Money'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter amount'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  _addMoney(amount);
                  Navigator.pop(context);
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _withdrawMoneyDialog() {
    TextEditingController amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Withdraw Money'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter amount'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  _withdrawMoney(amount);
                  Navigator.pop(context);
                }
              },
              child: Text('Withdraw'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Wallet'),
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _imageUrl != null ? NetworkImage(_imageUrl!) : null,
                        child: _imageUrl == null ? Icon(Icons.person, size: 40, color: Colors.white) : null,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _userEmail,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Wallet Balance',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '₹${_walletBalance.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: _showAddMoneyOptions,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Add Money'),
                          ),
                          ElevatedButton(
                            onPressed: _withdrawMoneyDialog,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text('Withdraw Money'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction History',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                      Divider(),
                      _transactionHistory.isEmpty
                          ? Center(child: Text('No transactions yet'))
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _transactionHistory.length,
                        itemBuilder: (context, index) {
                          var transaction = _transactionHistory[index];
                          return ListTile(
                            leading: Icon(
                              transaction['type'] == 'Credit' ? Icons.arrow_downward : Icons.arrow_upward,
                              color: transaction['type'] == 'Credit' ? Colors.green : Colors.red,
                            ),
                            title: Text('${transaction['type']} of ₹${transaction['amount']}'),
                            subtitle: Text('${transaction['date']}'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WalletScreen(userId: '123'), // Example user ID
  ));
}
