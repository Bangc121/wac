import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../constants/colors.dart';
import '../config/supabase_config.dart';

class ChurchSearchPage extends StatefulWidget {
  const ChurchSearchPage({super.key});

  @override
  State<ChurchSearchPage> createState() => _ChurchSearchPageState();
}

class _ChurchSearchPageState extends State<ChurchSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedTabIndex = 0; // 0: 교회 이름찾기, 1: 근처 교회찾기
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _nearbyChurches = [];
  bool _isLoading = false;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng _currentLocation = const LatLng(37.5665, 126.9780); // 서울 기본 위치
  String _selectedRegion = '전체'; // 선택된 지역 필터

  @override
  void initState() {
    super.initState();
    // 페이지 열리면 자동으로 키보드 표시
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedTabIndex == 0) {
        _focusNode.requestFocus();
      }
    });
    _loadNearbyChurches();
  }

  Future<void> _loadNearbyChurches() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 모든 교회 데이터 가져오기
      final results = await SupabaseConfig.client
          .from('churches')
          .select()
          .eq('status', '활성')
          .order('name');

      setState(() {
        _nearbyChurches = List<Map<String, dynamic>>.from(results);
        _isLoading = false;
      });

      // 마커 생성 (위도/경도가 있는 경우)
      _updateMarkers();
    } catch (error) {
      print('교회 로딩 에러: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateMarkers() {
    final markers = <Marker>{};

    for (var i = 0; i < _nearbyChurches.length; i++) {
      final church = _nearbyChurches[i];

      // TODO: 교회 테이블에 latitude, longitude 필드 추가 필요
      // 임시로 서울 주변에 랜덤 배치
      final lat = 37.5665 + (i * 0.01);
      final lng = 126.9780 + (i * 0.01);

      markers.add(
        Marker(
          markerId: MarkerId(church['id'].toString()),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: church['name'],
            snippet: church['address'],
          ),
          onTap: () {
            // 교회 선택 시 리스트로 스크롤
          },
        ),
      );
    }

    setState(() {
      _markers = markers;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _searchChurches(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('검색 쿼리: $query');
      final results = await SupabaseConfig.client
          .from('churches')
          .select()
          .ilike('name', '%$query%')
          .eq('status', '활성')
          .order('name');

      print('검색 결과 개수: ${results.length}');
      print('검색 결과: $results');

      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(results);
        _isLoading = false;
      });
    } catch (error) {
      print('검색 에러: $error');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('검색 중 오류가 발생했습니다: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _searchChurchesByRegion(String region) async {
    if (region.trim().isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await SupabaseConfig.client
          .from('churches')
          .select()
          .or('region.ilike.%$region%,sub_region.ilike.%$region%,address.ilike.%$region%')
          .eq('status', '활성')
          .order('name');

      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(results);
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('검색 중 오류가 발생했습니다: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // 헤더
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.black,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '교회검색',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 28), // 균형을 위한 공간
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 탭 버튼
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 0;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedTabIndex == 0
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '교회 이름찾기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: _selectedTabIndex == 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: _selectedTabIndex == 0
                                  ? Colors.black
                                  : Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 1;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: _selectedTabIndex == 1
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '근처 교회찾기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: _selectedTabIndex == 1
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: _selectedTabIndex == 1
                                  ? Colors.black
                                  : Colors.grey[500],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 검색 입력 필드 (교회 이름찾기 탭에서만 표시)
            if (_selectedTabIndex == 0) ...[
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: '교회를 찾아보세요',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 24,
                    ),
                  ),
                  onChanged: (value) {
                    _searchChurches(value);
                  },
                ),
              ),
            ],

            // 검색 결과 영역 또는 지도
            Expanded(
              child: _selectedTabIndex == 0
                  ? _buildSearchResults()
                  : _buildMapView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_searchController.text.isEmpty) {
      return Center(
        child: Text(
          '교회 이름을 검색해보세요',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Text(
          '검색 결과가 없습니다',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final church = _searchResults[index];
        return _buildChurchCard(church);
      },
    );
  }

  Widget _buildMapView() {
    final regions = ['전체', '서울', '경기', '인천', '부산', '대구', '광주', '대전', '울산', '세종'];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 지역 필터
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: regions.length,
              itemBuilder: (context, index) {
                final region = regions[index];
                final isSelected = _selectedRegion == region;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(region),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedRegion = region;
                        // TODO: 지역별 필터링 구현
                      });
                    },
                    backgroundColor: Colors.white,
                    selectedColor: const Color(0xFFFF8F00),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? const Color(0xFFFF8F00) : Colors.grey[300]!,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 지도 박스
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            clipBehavior: Clip.antiAlias,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 12,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),

          const SizedBox(height: 20),

          // 교회 리스트
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _nearbyChurches.isEmpty
                    ? Center(
                        child: Text(
                          '근처 교회가 없습니다',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: _nearbyChurches.length,
                        itemBuilder: (context, index) {
                          final church = _nearbyChurches[index];
                          return _buildChurchCard(church);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildChurchCard(Map<String, dynamic> church) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // 교회 상세 페이지로 이동 (추후 구현)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${church['name']} 선택됨'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 교회 이미지
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: church['profile_image_url'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            church['profile_image_url'],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.church,
                                size: 40,
                                color: Colors.grey[400],
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.church,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                ),
                const SizedBox(width: 12),

                // 교회 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 교회 이름
                      Text(
                        church['name'] ?? '교회 이름 없음',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 교단
                      if (church['denomination'] != null)
                        Text(
                          church['denomination'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),

                      const SizedBox(height: 4),

                      // 주소
                      if (church['address'] != null)
                        Text(
                          church['address'],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}