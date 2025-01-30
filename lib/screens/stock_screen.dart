import 'package:flutter/material.dart';
import 'package:budget_tracker_application_2/service/stock_service.dart';

class StockScreenUI extends StatefulWidget {
  const StockScreenUI({Key? key}) : super(key: key);

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreenUI> {
  late Future<List<Map<String, dynamic>>> stockData;
  final StockService stockService = StockService();

  final List<String> stockSymbols = [
    'AAPL',
    'MSFT',
    'GOOGL',
    'TSLA',
    // 'AMZN',
    // 'NFLX',
    // 'NVDA',
    // 'BABA',
    // 'V'
  ];

  @override
  void initState() {
    super.initState();
    stockData = stockService.fetchMultipleStockData(stockSymbols);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ตลาดหุ้นแบบ Real-Time',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFBFB960),
      ),
      backgroundColor: Color(0xFFF4F4F9),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: stockData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Color(0xFFD9534F), fontSize: 18),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var stock = data[index];
                var symbol = stock.keys.first;
                var quote = stock[symbol];

                if (quote == null || quote.isEmpty) {
                  return _buildStockCard(
                    symbol: symbol,
                    content: 'ไม่มีข้อมูลสำหรับหุ้นนี้',
                    contentColor: Color(0xFFD9534F),
                  );
                }

                var price = quote['close'] ?? 'N/A';
                var changePercent = quote['percent_change'] ?? 'N/A';

                return _buildStockCard(
                  symbol: symbol,
                  content:
                      'ราคาล่าสุด: \$${price}\nเปลี่ยนแปลง: ${changePercent}%',
                  contentColor: (double.tryParse(changePercent) ?? 0) > 0
                      ? const Color(0xFF28A745) // สีเขียวสำหรับกำไร
                      : const Color(0xFFD9534F), // สีแดงสำหรับขาดทุน
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'ไม่มีข้อมูลหุ้น',
                style: TextStyle(color: Color(0xFF002244), fontSize: 18),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildStockCard({
    required String symbol,
    required String content,
    required Color contentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        color: Color(0xFFFFFFFF),
        child: ListTile(
          title: Text(
            'สัญลักษณ์: $symbol',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF002244),
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 18,
                color: contentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
