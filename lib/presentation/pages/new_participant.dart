import 'package:equaly/logic/list/participant_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

class NewParticipant extends StatefulWidget {
  const NewParticipant({super.key, required this.addParticipant});

  final ValueChanged<ParticipantState> addParticipant;

  @override
  State<NewParticipant> createState() => _NewParticipantState();
}

class _NewParticipantState extends State<NewParticipant> {
  var participantName = TextEditingController();
  File? profileImage;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Center(
                  child: CircleAvatar(
                    radius: 72,
                    backgroundImage:
                        profileImage != null ? FileImage(profileImage!) : null,
                    backgroundColor: Colors.grey[300],
                    child: profileImage == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.grey[700],
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Teilnehmer Name",
                style: theme.textTheme.labelMedium,
              ),
              SizedBox(height: 4),
              TextField(
                controller: participantName,
                decoration: InputDecoration(
                  hintText: "Name",
                ),
              ),
            ],
          ),
          SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (participantName.text.isEmpty) return;
                  var uuid = Uuid();
                  setState(() {
                    var participant = ParticipantState(
                        avatarUrl: profileImage?.path ?? "",
                        name: participantName.text,
                        id: uuid.v4());
                    widget.addParticipant(participant);
                  });
                  Navigator.pop(context);
                },
                style: theme.filledButtonTheme.style,
                child: Text(
                  "Teilnehmer hinzufügen",
                  style: theme.textTheme.labelLarge,
                ),
              ))
        ],
      ),
    );
  }
}
