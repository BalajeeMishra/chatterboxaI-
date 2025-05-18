import 'package:balajiicode/Utils/app_colors.dart';
import 'package:balajiicode/Utils/app_images.dart';
import 'package:balajiicode/extensions/extension_util/int_extensions.dart';
import 'package:balajiicode/extensions/extension_util/widget_extensions.dart';
import 'package:flutter/material.dart';

import '../Utils/proficiency_consts.dart';
import '../Widget/text_widget.dart';

class ProfileDetailsScreen extends StatefulWidget {
  final country;
  final mobileNumber;
  final name;
  const ProfileDetailsScreen({Key? key, this.country,  this.mobileNumber,this.name}) : super(key: key);

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  TextEditingController _nameController = TextEditingController();
  String selectedLanguage = 'Hindi';
  int englishLevel = 1; // 0: Beginner, 1: Intermediate, 2: Advanced


  @override
  void initState() {
    _nameController = TextEditingController(text: widget.name??"Enter Your Name");
  }


  void showLanguagePicker() async {
    // Placeholder for language picker modal
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          FractionallySizedBox(
            heightFactor: 0.9,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MyText(text:'Select Your Native Language', fontWeight: FontWeight.bold, fontSize: 18,color: Colors.black54),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const MyText(text:'Close', color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search For Language',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      // onChanged: ...
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        final language = languages[index];
                        return Column(
                          children: [
                            ListTile(
                              title: Text(language.englishName),
                              trailing: Text(language.nativeName),
                              selected: selectedLanguage == language.englishName,
                              selectedTileColor: Colors.blue.withOpacity(0.1),
                              contentPadding: EdgeInsets.zero,
                              onTap: () =>
                                  Navigator.of(context).pop(language.englishName),
                            ),
                            Divider(color: Colors.black54,)
                          ],
                        ).paddingSymmetric(horizontal: 12);
                      },

                    ),
                  ),
                ],
              ),
            ),
          ),
    );
    if (result != null) {
      setState(() {
        selectedLanguage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: primaryColor,
        appBar: AppBar(
          backgroundColor: primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                reverse: true,
                padding: EdgeInsets.only(
                  bottom: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const MyText(
                              text: 'Hello 👋\nTell Me About\nYourself',
                              textAlign: TextAlign.center,
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: Image.asset(
                                zapai2,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Your Name', style: TextStyle(
                                  fontWeight: FontWeight.bold,color: Colors.black54)),
                              10.height,
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    onPressed: () {},
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              20.height,
                              const MyText(text: "Select Your Native Language",
                                  fontWeight: FontWeight.bold,color: Colors.black54,),
                              8.height,
                              GestureDetector(
                                onTap: showLanguagePicker,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(selectedLanguage,
                                          style: const TextStyle(fontSize: 16)),
                                      const Icon(Icons.arrow_drop_down),
                                    ],
                                  ),
                                ),
                              ),
                              20.height,
                              const MyText(text: 'Your English Proficiency',
                                  fontWeight: FontWeight.bold,color: Colors.black54),
                              8.height,
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: const [
                                  MyText(text: 'Beginner'),
                                  MyText(text: 'Intermediate'),
                                  MyText(text: 'Advanced'),
                                ],
                              ),
                              Slider(
                                value: englishLevel.toDouble(),
                                min: 0,
                                max: 2,
                                divisions: 2,
                                activeColor: primaryColor,
                                onChanged: (value) {
                                  setState(() {
                                    englishLevel = value.toInt();
                                  });
                                },
                              ),
                              8.height,
                              const Text(
                                'Can handle daily conversations and write or speak with some confidence on familiar topics.',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                              20.height,
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Continue',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class Language {
  final String englishName;
  final String nativeName;

  Language({required this.englishName, required this.nativeName});
}
