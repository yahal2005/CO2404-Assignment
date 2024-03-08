import 'package:cinematic_insights/Widgets/back_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget
{
  const ProfileScreen({super.key});

  @override
  State <ProfileScreen> createState() => ProfileState();
  
}

class ProfileState extends State<ProfileScreen>
{
  Uint8List? imageBytes;
  String? imageUrl;


  Future<void> uploadImageToStorage() async {
    try 
    {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowCompression: true,
      );

      if (result != null) 
      {
        setState(() 
        {
          imageBytes = result.files.single.bytes;
        });

        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('profileImage/${1}.jpg');

        await ref.putData(imageBytes!);

        String downloadUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('userProfile').doc('profileImage').set(
        {
          'imageUrl': downloadUrl,
        });

        setState(() 
        {
          imageUrl = downloadUrl;
        });
      }
    } 
    catch (error) 
    {

      print('Error uploading image: $error');

    }
  }



  

  void RemoveImage()
  {
    setState(() {
      imageUrl = null;
    });
  }

   @override
  Widget build(BuildContext context)
  {
    final Size screenSize = MediaQuery.of(context).size;
    return  Scaffold(
      appBar: AppBar(
        leading: const BackBtn(), 
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                imageUrl != null ?
                   CircleAvatar(
                    radius: 128,
                    backgroundImage: NetworkImage(imageUrl!),
                   ):
                const CircleAvatar(
                  radius: 128,
                  backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzPb_pSj-ir-9eB6mi0lVJdQP1KKHiB8fRBS1CbmOXGd9Z1FEGMJHbEKhahwhWLGSaEXY&usqp=CAU"),
                ),

                

              ],
            ),

            SizedBox(height: screenSize.height*0.1),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: uploadImageToStorage, 
                  child: const Text('Add Image', style: TextStyle(color: Color.fromRGBO(253, 203, 74, 1.0)),)
                ),

                SizedBox(width: screenSize.width*0.1),

                ElevatedButton(
                  onPressed: RemoveImage, 
                  child: const Text('Remove Image', style: TextStyle(color: Color.fromRGBO(253, 203, 74, 1.0)),),
                ),

              ],
            )
          ],
        ),
      ),

    );
  }
}