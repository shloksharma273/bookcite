import 'dart:io';

import 'package:bookcite/widgets/custom_button.dart';
import 'package:bookcite/widgets/upload_book_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:dotted_border/dotted_border.dart';


class UploadBook extends StatefulWidget {
  const UploadBook({super.key});

  @override
  State<UploadBook> createState() => _UploadBookState();
}

class _UploadBookState extends State<UploadBook> {

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * -0.6,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Container(
              width: 800, // Adjust size as needed
              height: 800,
              decoration: BoxDecoration(
                color:
                    AppColors.colorSurfaceSecondary, // Adjust color as needed
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * -0.6,
            left: 0,
            child: Container(
              width: 800, // Adjust size as needed
              height: 800,
              decoration: BoxDecoration(
                color:
                    AppColors.colorSurfaceSecondary, // Adjust color as needed
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.06,
            right: 0,
            left: 0,
            bottom: -0.15,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.03),
                      child: RichText(
                        text:
                            TextSpan(style: textTheme.headlineMedium, children: [
                          TextSpan(
                              text: 'Upload ',
                              style: TextStyle(
                                color: AppColors.colorButtonPrimary,
                              )),
                          TextSpan(text: 'a Book')
                        ]),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03
                    ),
                    DottedBorder(
                      borderType: BorderType.RRect ,
                      radius: Radius.circular(16.0),
                      color: Colors.grey,
                      child: GestureDetector(
                        onTap: () async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: ['pdf']
                          );
                          if (result != null) {
                            File file = File(result.files.single.path!);
                          } else {
                            // User canceled the picker
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.colorSurfacePrimary,
                            borderRadius: BorderRadius.circular(16.0)
                          ),
                          height: 200,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.cloud_upload_outlined),
                              Text(
                                "Upload the book"
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03
                    ),
              
                    Text(
                      "Name of the Book"
                    ),
              
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01
                    ),

                    UploadBookTextField(labelText: "Name"),
              
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03
                    ),
                    Text(
                        "Author"
                    ),
              
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01
                    ),
              
                    UploadBookTextField(labelText: "Author"),
              
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05
                    ),
              
                    CustomButton(onTap: (){
                      //TODO: upload to api
                    }, title: "Upload"),

                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1
                    ),
              
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
