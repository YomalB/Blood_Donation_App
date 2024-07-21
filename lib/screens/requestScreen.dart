import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/camp_model.dart'; 

class RequestScreenPage extends StatefulWidget {
  const RequestScreenPage({Key? key}) : super(key: key);

  @override
  State<RequestScreenPage> createState() => _RequestScreenPageState();
}

class _RequestScreenPageState extends State<RequestScreenPage> {
  final ScrollController _controllerOne = ScrollController();
  late List<CampModel> _camps;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCampData();
  }

  Future<void> fetchCampData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot campDocs =
          await FirebaseFirestore.instance.collection('blood_camps').get();
      if (campDocs.docs.isNotEmpty) {
        _camps = campDocs.docs
            .map((doc) => CampModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching camps data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white],
            ),
          ),
          child: Column(
            children: [
              const HeaderSection(),
              Expanded(
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Scrollbar(
                        controller: _controllerOne,
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          controller: _controllerOne,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: _camps
                                  .map((camp) => InfoCardWidget(camp: camp))
                                  .toList(),
                            ),
                          ),
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

class InfoCardWidget extends StatelessWidget {
  final CampModel camp;

  const InfoCardWidget({
    Key? key,
    required this.camp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  camp.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Date : ${camp.date}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Location : ${camp.location}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  camp.description,
                ),
               const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Implement button functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 210, 36, 24),
                        minimumSize: const Size(20, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Join Camp',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Implement button functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        minimumSize: Size(20, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Decline',
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 128,
      decoration: const BoxDecoration(
        color: Color(0xFFFF1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Request',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontFamily: 'MontserratBold',
            ),
          ),
          Positioned(
            top: 8,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_sharp,
                size: 40,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context); // Use pop to navigate back
              },
            ),
          ),
        ],
      ),
    );
  }
}
