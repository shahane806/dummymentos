import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ApiService {
  static const String baseUrl = 'http://192.168.1.79:8500';
  static const String logicUrl = '$baseUrl/logic.php';

  Future<List<FolderItem>> fetchFolderItems(String path) async {
    try {
      final cleanPath =
          Uri.encodeFull(path.trim().replaceAll(RegExp(r'^/+|/+$'), ''));
      final url = Uri.parse('$logicUrl?path=$cleanPath');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.map((item) => FolderItem.fromJson(item)).toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch items: $e');
    }
  }

  String getFileUrl(String fullPath) {
    return Uri.parse('$baseUrl/$fullPath').toString();
  }

  Future<File> downloadFile(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final file = File('${directory.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }
}

class FolderItem {
  final String name;
  final String type;
  final List<FolderItem>? children;
  final bool isDirectory;
  final String? dateModified;
  final int? size;

  FolderItem({
    required this.name,
    required this.type,
    this.children,
    required this.isDirectory,
    this.dateModified,
    this.size,
  });

  factory FolderItem.fromJson(Map<String, dynamic> json) {
    return FolderItem(
      name: json['name'] ?? '',
      type: json['type'] ?? 'unknown',
      isDirectory: json['isDirectory'] ?? false,
      children: json['children'] != null
          ? (json['children'] as List)
              .map((item) => FolderItem.fromJson(item))
              .toList()
          : null,
      dateModified: json['dateModified'],
      size: json['size'],
    );
  }
}

void main() {
  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarIconBrightness: Brightness.dark,
  //   ),
  // );
  runApp(FileExplorerApp());
}

class FileExplorerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Document Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF00796B),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF00796B),
          primary: Color(0xFF00796B),
          secondary: Color(0xFF26A69A),
          background: Colors.grey[50]!,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadowColor: Colors.black26,
        ),
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFF00796B),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FileExplorerScreen(),
    );
  }
}

class FileExplorerScreen extends StatefulWidget {
  @override
  _FileExplorerScreenState createState() => _FileExplorerScreenState();
}

class _FileExplorerScreenState extends State<FileExplorerScreen>
    with SingleTickerProviderStateMixin {
  List<String> currentPath = ['Scanned Document Folder'];
  List<FolderItem> currentItems = [];
  List<FolderItem> filteredItems = [];
  final ApiService apiService = ApiService();
  bool isLoading = false;
  bool isGridView = false;
  late TextEditingController searchController;
  bool isSearching = false;
  String sortBy = 'name';
  bool sortAscending = true;
  late AnimationController _animationController;
  ViewType currentViewType = ViewType.list;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    searchController = TextEditingController();
    _loadInitialItems();
  }

  @override
  void dispose() {
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialItems() async {
    await _fetchItems('Scanned Document Folder');
  }

  Future<void> _fetchItems(String path) async {
    setState(() => isLoading = true);
    try {
      final items = await apiService.fetchFolderItems(path);
      _sortItems(items);
      setState(() {
        currentItems = items;
        filteredItems = List.from(items);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackBar('$e');
    }
  }

  void _sortItems(List<FolderItem> items) {
    items.sort((a, b) {
      if (a.isDirectory && !b.isDirectory) return -1;
      if (!a.isDirectory && b.isDirectory) return 1;

      int result;
      switch (sortBy) {
        case 'name':
          result = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case 'type':
          result = a.type.toLowerCase().compareTo(b.type.toLowerCase());
          break;
        case 'date':
          if (a.dateModified == null || b.dateModified == null) {
            result = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          } else {
            result = a.dateModified!.compareTo(b.dateModified!);
          }
          break;
        case 'size':
          if (a.size == null || b.size == null) {
            result = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          } else {
            result = a.size!.compareTo(b.size!);
          }
          break;
        default:
          result = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return sortAscending ? result : -result;
    });
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(currentItems);
      } else {
        filteredItems = currentItems
            .where(
                (item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void navigateForward(FolderItem item) {
    if (item.isDirectory) {
      setState(() {
        currentPath.add(item.name);
        searchController.clear();
        isSearching = false;
      });
      _fetchItems(_buildFullPath());
    }
  }

  void navigateBack() {
    if (currentPath.length > 1) {
      setState(() {
        currentPath.removeLast();
        searchController.clear();
        isSearching = false;
      });
      _fetchItems(_buildFullPath());
    }
  }

  void navigateToRoot() {
    setState(() {
      currentPath = ['Scanned Document Folder'];
      searchController.clear();
      isSearching = false;
    });
    _fetchItems(_buildFullPath());
  }

  String _buildFullPath({String? fileName}) {
    String path = currentPath.join('/');
    if (fileName != null) {
      path = '$path/$fileName';
    }
    return path;
  }

  Future<void> _refresh() async {
    await _fetchItems(_buildFullPath());
  }

  void _toggleViewType() {
    setState(() {
      if (currentViewType == ViewType.list) {
        currentViewType = ViewType.grid;
        _animationController.forward();
      } else {
        currentViewType = ViewType.list;
        _animationController.reverse();
      }
    });
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Sort by',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            _buildSortOption('Name', 'name'),
            _buildSortOption('Type', 'type'),
            _buildSortOption('Date', 'date'),
            _buildSortOption('Size', 'size'),
            Divider(),
            ListTile(
              leading: Icon(
                sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                sortAscending ? 'Ascending' : 'Descending',
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                setState(() {
                  sortAscending = !sortAscending;
                  _sortItems(currentItems);
                  filteredItems = List.from(currentItems);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String value) {
    return ListTile(
      leading: Icon(
        value == 'name'
            ? Icons.sort_by_alpha
            : value == 'type'
                ? Icons.category
                : value == 'date'
                    ? Icons.calendar_today
                    : Icons.data_usage,
        color: sortBy == value ? Theme.of(context).primaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: sortBy == value ? FontWeight.bold : FontWeight.normal,
          color: sortBy == value ? Theme.of(context).primaryColor : null,
        ),
      ),
      onTap: () {
        setState(() {
          sortBy = value;
          _sortItems(currentItems);
          filteredItems = List.from(currentItems);
        });
        Navigator.pop(context);
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'RETRY',
          textColor: Colors.white,
          onPressed: _refresh,
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (currentPath.length > 1) {
      navigateBack();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                forceElevated: innerBoxIsScrolled,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Document Explorer',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF00796B),
                          Color(0xFF00897B),
                        ],
                      ),
                    ),
                  ),
                ),
                leading: currentPath.length > 1
                    ? IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: navigateBack,
                      )
                    : null,
                actions: [
                  IconButton(
                    icon: Icon(isSearching ? Icons.close : Icons.search,
                        color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                        if (!isSearching) {
                          searchController.clear();
                          filteredItems = List.from(currentItems);
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.list_view,
                      progress: _animationController,
                      color: Colors.white,
                    ),
                    onPressed: _toggleViewType,
                  ),
                  IconButton(
                    icon: Icon(Icons.sort, color: Colors.white),
                    onPressed: _showSortOptions,
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.white),
                    onPressed: _refresh,
                  ),
                ],
                bottom: isSearching
                    ? PreferredSize(
                        preferredSize: Size.fromHeight(60),
                        child: Container(
                          height: 60,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: Colors.white,
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Search documents...',
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                            onChanged: _filterItems,
                          ),
                        ),
                      )
                    : null,
              ),
            ];
          },
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12.0),
                color: Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildBreadcrumbItem('Home', 0),
                      ...List.generate(
                        currentPath.length - 1,
                        (index) => _buildBreadcrumbItem(
                            currentPath[index + 1], index + 1),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1),
              Expanded(
                child: isLoading
                    ? _buildLoadingWidget()
                    : filteredItems.isEmpty
                        ? _buildEmptyStateWidget()
                        : currentViewType == ViewType.list
                            ? _buildListView()
                            : _buildGridView(),
              ),
            ],
          ),
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: currentPath.length > 1 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 200),
          child: FloatingActionButton(
            onPressed: currentPath.length > 1 ? navigateToRoot : null,
            child: Icon(Icons.home, color: Colors.white),
            backgroundColor: Theme.of(context).primaryColor,
            tooltip: 'Go to root',
            mini: true,
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbItem(String name, int index) {
    final isLast = index == currentPath.length - 1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: !isLast
              ? () {
                  setState(() {
                    while (currentPath.length > index + 1) {
                      currentPath.removeLast();
                    }
                  });
                  _fetchItems(_buildFullPath());
                }
              : null,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isLast
                  ? Theme.of(context).primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              name,
              style: TextStyle(
                color:
                    isLast ? Theme.of(context).primaryColor : Colors.grey[700],
                fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
        if (!isLast)
          Icon(Icons.chevron_right, size: 18, color: Colors.grey[400]),
      ],
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            'Loading documents...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No documents found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          if (searchController.text.isNotEmpty)
            Text(
              'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            icon: Icon(Icons.refresh),
            label: Text('Refresh'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: _refresh,
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: RefreshIndicator(
        onRefresh: _refresh,
        color: Theme.of(context).primaryColor,
        child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.isDirectory
                        ? Colors.teal[50]
                        : _getFileColorByType(item.type),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      item.isDirectory
                          ? Icons.folder
                          : _getIconByFileType(item.type),
                      color: item.isDirectory
                          ? Colors.teal[400]
                          : Colors.grey[700],
                      size: 24,
                    ),
                  ),
                ),
                title: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: item.dateModified != null
                    ? Text(
                        'Modified: ${item.dateModified}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      )
                    : null,
                trailing: item.isDirectory
                    ? Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      )
                    : IconButton(
                        icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                        onPressed: () => _showFileOptions(item),
                      ),
                onTap: () => item.isDirectory
                    ? navigateForward(item)
                    : _handleFileTap(item),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: RefreshIndicator(
        onRefresh: _refresh,
        color: Theme.of(context).primaryColor,
        child: GridView.builder(
          padding: EdgeInsets.all(12.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return InkWell(
              onTap: () => item.isDirectory
                  ? navigateForward(item)
                  : _handleFileTap(item),
              borderRadius: BorderRadius.circular(12),
              child: Card(
                elevation: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: item.isDirectory
                              ? Colors.teal[50]
                              : _getFileColorByType(item.type),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            item.isDirectory
                                ? Icons.folder
                                : _getIconByFileType(item.type),
                            color: item.isDirectory
                                ? Colors.teal[400]
                                : Colors.grey[700],
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (item.dateModified != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                item.dateModified!,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showFileOptions(FolderItem item) {
    final fullPath = _buildFullPath(fileName: item.name);
    final fileUrl = apiService.getFileUrl(fullPath);

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.grey[300],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.visibility,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('View Document'),
              onTap: () {
                Navigator.pop(context);
                _handleFileTap(item);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.share,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Sharing from: $fileUrl');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.download,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Download'),
              onTap: () {
                Navigator.pop(context);
                _showSuccessSnackBar('Downloading from: $fileUrl');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Theme.of(context).primaryColor,
              ),
              title: Text('Properties'),
              onTap: () {
                Navigator.pop(context);
                _showDocumentProperties(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDocumentProperties(FolderItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Document Properties'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPropertyRow('Name', item.name),
            _buildPropertyRow('Type', item.type),
            if (item.dateModified != null)
              _buildPropertyRow('Modified', item.dateModified!),
            if (item.size != null)
              _buildPropertyRow('Size', _formatFileSize(item.size!)),
            _buildPropertyRow('Path', _buildFullPath()),
            if (!item.isDirectory)
              _buildPropertyRow('URL',
                  apiService.getFileUrl(_buildFullPath(fileName: item.name))),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int sizeInBytes) {
    if (sizeInBytes < 1024) {
      return '$sizeInBytes B';
    } else if (sizeInBytes < 1024 * 1024) {
      final kb = sizeInBytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else {
      final mb = sizeInBytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    }
  }

  void _handleFileTap(FolderItem item) async {
    if (!item.isDirectory) {
      setState(() => isLoading = true);
      try {
        final fullPath = _buildFullPath(fileName: item.name);
        final fileUrl = apiService.getFileUrl(fullPath);
        _showSuccessSnackBar('Downloading document: ${item.name}');

        final file = await apiService.downloadFile(fileUrl, item.name);

        final result = await OpenFilex.open(file.path);
        if (result.type != ResultType.done) {
          _showErrorSnackBar('Could not open file: ${result.message}');
        } else {
          _showSuccessSnackBar('Opened document: ${item.name}');
        }
      } catch (e) {
        _showErrorSnackBar('Error handling file: $e');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  IconData _getIconByFileType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getFileColorByType(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red[50]!;
      case 'doc':
      case 'docx':
        return Colors.blue[50]!;
      case 'xls':
      case 'xlsx':
        return Colors.green[50]!;
      case 'ppt':
      case 'pptx':
        return Colors.orange[50]!;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Colors.purple[50]!;
      case 'txt':
        return Colors.grey[100]!;
      default:
        return Colors.grey[50]!;
    }
  }
}

enum ViewType { list, grid }
