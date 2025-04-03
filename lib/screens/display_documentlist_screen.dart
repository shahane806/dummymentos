import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanningapp/bloc/fetch_docs/fetch_docs_bloc.dart';
import 'package:scanningapp/bloc/fetch_docs/fetch_docs_event.dart';
import 'package:scanningapp/bloc/fetch_docs/fetch_docs_state.dart';
import 'package:scanningapp/constants/enums.dart';
import '../widgets/buiddocs_card.dart';
import '../widgets/buildempty_state.dart';

// ignore: must_be_immutable
class DocumentListScreen extends StatefulWidget {
  String? selectedSection;
  String? selectedDistrict;
  String? selectedTaluka;
  String? state;
  String? selectedDocumentFormat;
  String? selectedDocumentType;

  DocumentListScreen({
    super.key,
    required this.state,
    required this.selectedSection,
    required this.selectedDistrict,
    required this.selectedTaluka,
    required this.selectedDocumentFormat,
    required this.selectedDocumentType,
  });

  @override
  _DocumentListScreenState createState() => _DocumentListScreenState();
}

class _DocumentListScreenState extends State<DocumentListScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    context.read<FetchDocsBloc>().add(FetchDocsEvent(
        state: widget.state.toString(),
        section: widget.selectedSection.toString(),
        district: widget.selectedDistrict.toString(),
        taluka: widget.selectedTaluka.toString(),
        documentformat: widget.selectedDocumentFormat.toString(),
        docstype: widget.selectedDocumentType.toString(),
        isNewSearch: true));
  }

  void _onScroll() {
    final bloc = context.read<FetchDocsBloc>();

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      int totalPages = bloc.fetchdocdataRepo.totalPages;

      if (bloc.state.fetchDocStatus != FetchDocStatus.loading &&
          bloc.currentPage <= totalPages) {
        bloc.add(FetchDocsEvent(
            state: widget.state.toString(),
            section: widget.selectedSection.toString(),
            district: widget.selectedDistrict.toString(),
            taluka: widget.selectedTaluka.toString(),
            documentformat: widget.selectedDocumentFormat.toString(),
            docstype: widget.selectedDocumentType.toString(),
            isNewSearch: false));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
              'Documents',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(0XFF1998d5),
            elevation: 4,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<FetchDocsBloc, FetchDocsState>(
                  builder: (context, state) {
                    final bloc = context.read<FetchDocsBloc>();
                    int totalRecords = bloc.fetchdocdataRepo.totalRecords;
                    return Text(
                      totalRecords.toString() + " Found",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    );
                  },
                ),
              ),
            ]),
        body: Container(
          color: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<FetchDocsBloc, FetchDocsState>(
              builder: (context, state) {
                if (state.fetchDocStatus == FetchDocStatus.loading &&
                    state.documentList.isEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  );
                }
                if (state.fetchDocStatus == FetchDocStatus.failure) {
                  return Center(
                    child: Text("Failed to load document"),
                  );
                }

                if (state.documentList.isEmpty) {
                  return buildEmptyState();
                }

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: state.documentList.length +
                        (state.fetchDocStatus == FetchDocStatus.loading
                            ? 1
                            : 0),
                    itemBuilder: (context, index) {
                      if (index == state.documentList.length &&
                          state.fetchDocStatus == FetchDocStatus.loading) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      final document = state.documentList[index];
                      return buildDocumentCard(document, context);
                    },
                  ),
                );
              },
            ),
          ),
        ));
  }
}
