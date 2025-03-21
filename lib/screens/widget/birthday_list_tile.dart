import 'package:flutter/material.dart';
import 'package:geburtstags_app/models/birthday.model.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:confetti/confetti.dart';

class BirthdayListTile extends StatefulWidget {
  final Birthday birthday;
  final String subtitle;
  final VoidCallback onTap;
  final String extra;

  const BirthdayListTile({
    super.key,
    required this.birthday,
    required this.subtitle,
    required this.onTap,
    required this.extra,
  });

  @override
  State<BirthdayListTile> createState() => _BirthdayListTileState();
}

class _BirthdayListTileState extends State<BirthdayListTile> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!hasExtra) {
        _confettiController.play();
      }
    });
  }

  bool get hasExtra => widget.extra.trim().isNotEmpty;

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> teile = widget.extra.split(",");

    return Stack(
      alignment: Alignment.center,
      children: [
        Card(
          elevation: 4,
          color: const Color.fromARGB(255, 255, 255, 255),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.only(
                top: hasExtra ? 1.0 : 5, bottom: hasExtra ? 1.0 : 5),
            child: ListTile(
              onTap: widget.onTap,
              leading: widget.birthday.profileImage == null
                  ? AvatarPlus(widget.birthday.id, height: 50, width: 50)
                  : ClipOval(
                      child: Image.network(
                        widget.birthday.profileImage!,
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
              title: hasExtra
                  ? Text(widget.birthday.name,
                      style: const TextStyle(fontSize: 16))
                  : Text(widget.birthday.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: hasExtra
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.subtitle),
                        Text("In ${teile[1].trim()} Tagen",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 105, 147, 36),
                                fontStyle: FontStyle.italic)),
                      ],
                    )
                  : null,
              trailing: hasExtra
                  ? Text("wird ${teile[0].trim()} Jahre",
                      style: const TextStyle(fontSize: 17))
                  : SizedBox(
                      width: 50,
                      height: 50,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        colors: const [
                          Colors.red,
                          Colors.blue,
                          Colors.orange,
                          Colors.green
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
