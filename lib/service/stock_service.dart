import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService {
  final String apiKey = 'cca593ecd10d42cb9e5a789597b80e86';
  final String baseUrl = 'https://api.twelvedata.com';

  // ดึงข้อมูลหุ้นเดี่ยว
  Future<Map<String, dynamic>> fetchStockData(String symbol) async {
    final url = Uri.parse('$baseUrl/quote?symbol=$symbol&apikey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('symbol')) {
        return data; // คืนค่าข้อมูลหุ้นแบบเต็ม
      } else {
        throw Exception('Invalid response: ${data['message']}');
      }
    } else {
      throw Exception('Failed to load stock data');
    }
  }

  // ดึงข้อมูลหลายหุ้นพร้อมกัน
  Future<List<Map<String, dynamic>>> fetchMultipleStockData(
      List<String> symbols) async {
    return await Future.wait(
      symbols.map((symbol) async {
        try {
          final data = await fetchStockData(symbol);
          return {symbol: data};
        } catch (e) {
          print('Error fetching stock $symbol: $e');
          return {symbol: {}};
        }
      }),
    );
  }
}
