import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:alarm_example/local/locationclass.dart';
import 'package:alarm_example/local/localUI.dart';
import "package:alarm_example/main.dart";


List<localLocation> _favorites = [];
List<localLocation> _localLocations = [];
 
class localPage extends StatefulWidget {
  @override
  _localPageState createState() => _localPageState();
}

class _localPageState extends State<localPage> {
  TextEditingController _searchController = TextEditingController();
  /*
  List<localLocation> _localLocations = [
    localLocation(city: '서울', district: '강남구', latitude: 37.5172, longitude: 127.0473),
    localLocation(city: '부산', district: '해운대구', latitude: 35.1586, longitude: 129.1639),
    localLocation(city: '인천', district: '연수구', latitude: 37.5034, longitude: 126.7661),
    // 미리 만들어둔 지역 리스트
  ];*/
  List<localLocation> _searchResults = [];
  
  

  void searchlocalLocations(String query) async {
  // Check if the search results already contain the searched word
    final existingResults = _localLocations.where((localLocation) =>
        localLocation.city.toLowerCase() == query.toLowerCase() ||
        localLocation.district.toLowerCase() == query.toLowerCase());

    if (existingResults.isNotEmpty) {
      setState(() {
        _searchResults = existingResults.toList();
      });
      return;
    }

    Uri apiUrl = Uri.parse('https://dapi.kakao.com/v2/local/search/address.json?query=');
    final String header = 'KakaoAK 8fd734a761a4af6f6122446840b6bf1e'; // kakao API key
    
    final response = await http.get(apiUrl.replace(queryParameters: {
    'query': query,}), headers: {"Authorization" : header});

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body); // json 데이터로 변환
      final documents = jsonData['documents'];

      List<localLocation> results = [];

      for (var document in documents) {
        final latitude = document['y'];
        final longitude = document['x'];
        final address = document['address'];

        final city = address['region_1depth_name'];
        final district = address['region_2depth_name'];

        localLocation newlocalLocation = localLocation(
          city: city,
          district: district,
          latitude: double.parse(latitude),
          longitude: double.parse(longitude),
        );

        _localLocations.add(newlocalLocation);

        results.add(newlocalLocation);

        print("${newlocalLocation.district}, ${newlocalLocation.latitude}, ${newlocalLocation.longitude}");
      }

      setState(() {
        _searchResults = results;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }


  void addToFavorites(localLocation localLocation) {
    setState(() {
      _favorites.add(localLocation);
    });
  }

  void removeFromFavorites(localLocation localLocation) {
    setState(() {
      _favorites.remove(localLocation);
    });
  }

  bool isFavorite(localLocation localLocation) {
    return _favorites.contains(localLocation);
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
        appBar: AppBar(
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: '시/군/구 를 입력하시오',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      searchlocalLocations(_searchController.text);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  final localLocation = _searchResults[index];
                  final isFavorited = isFavorite(localLocation);
                  return ListTile(
                    title: Text('${localLocation.city} ${localLocation.district}'),
                    trailing: IconButton(
                      icon: Icon(isFavorited ? Icons.favorite : Icons.favorite_border),
                      color: isFavorited ? Colors.red : null,
                      onPressed: () {
                        if (isFavorited) {
                          // 이미 즐겨찾기에 추가된 지역인 경우, 즐겨찾기에서 제거합니다.
                          removeFromFavorites(localLocation);
                          print(_favorites.length);
                        } else {
                          // 즐겨찾기에 추가되지 않은 지역인 경우, 즐겨찾기에 추가합니다.
                          addToFavorites(localLocation);
                          print(_favorites.length);
                        }
                      },
                    ),
                    onTap: () { // 클릭하면 localWeatherPage()로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => localWeatherPage(location: localLocation),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Favorites',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _favorites.length,
                itemBuilder: (BuildContext context, int index) {
                  final localLocation = _favorites[index];
                  return ListTile(
                    title: Text('${localLocation.city} ${localLocation.district}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        // 즐겨찾기에서 지역을 제거
                        removeFromFavorites(localLocation);
                      },
                    ),
                    onTap: () { // 클릭하면 localWeatherPage()로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => localWeatherPage(location: localLocation),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );

  }
}