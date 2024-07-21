import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/camp_model.dart';
import 'package:flutter_application_1/provider/camp_provider.dart';

import 'package:provider/provider.dart';

class OrganizerFormPage extends StatefulWidget {
  const OrganizerFormPage({Key? key}) : super(key: key);

  @override
  State<OrganizerFormPage> createState() => _OrganizerFormPageState();
}

class _OrganizerFormPageState extends State<OrganizerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController _controllerOne = ScrollController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedDate = '';

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please choose a date')),
        );
        return;
      }

      final campProvider = Provider.of<CampProvider>(context, listen: false);

      CampModel campModel = CampModel(
        title: _titleController.text.trim(),
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        date: _selectedDate,
      );

      String? result =
          await campProvider.saveCampDataToFirebase(campModel: campModel);

      if (result == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camp data saved successfully!')),
        );
        _titleController.clear();
        _locationController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedDate = '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  void _showDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 10),
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                Container(
                  width: 411,
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
                        'Organize Blood Camp',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: 'MontserratBold',
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 10,
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            size: 30,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _controllerOne,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: _controllerOne,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  hintText: 'Title',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                controller: _locationController,
                                decoration: InputDecoration(
                                  hintText: 'Location',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a location';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 16.0),
                              Container(
                                height: 200,
                                child: TextFormField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    hintText: 'Description',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),
                                        bottomRight: Radius.circular(50),
                                        bottomLeft: Radius.circular(50),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 100.0,
                                      horizontal: 20.0,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Container(
                                width: 230,
                                child: OutlinedButton(
                                  onPressed: _showDatePicker,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 235, 232, 232),
                                    padding: EdgeInsets.all(17.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 98, 94, 94),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Text(
                                    _selectedDate.isEmpty
                                        ? 'Choose Date'
                                        : _selectedDate,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 79, 76, 76),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: _saveForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 210, 36, 24),
                                  minimumSize: Size(300, 60),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(18),
                                      topRight: Radius.circular(18),
                                      bottomLeft: Radius.circular(18),
                                      bottomRight: Radius.circular(18),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Organize\nBlood Camp',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontFamily: 'MontserratBold',
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
