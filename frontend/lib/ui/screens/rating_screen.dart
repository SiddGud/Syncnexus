import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worker_app/provider/user_endpoints.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key, required this.rateUser});

  final String rateUser;

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final TextEditingController feedbackController = TextEditingController();
  int rating = 0;

  bool get inputIsValid {
    if (rating <= 0) {
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    feedbackController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void onSubmit() async {
    await addRating(widget.rateUser, rating, feedbackController.text).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(
            children: [
              SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    "SHARE YOUR\nEXPERIENCE!!",
                    style: GoogleFonts.roboto(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 200,
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 32,
                        color: Colors.black,
                      )),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Center(
                  child: RatingBar.builder(
                      itemSize: 64,
                      initialRating: 0,
                      itemBuilder: (context, index) {
                        return const Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 234, 196, 72),
                        );
                      },
                      onRatingUpdate: (value) {
                        rating = value.toInt();
                        setState(() {
                          inputIsValid;
                        });
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                            backgroundColor:
                                const Color(0xffff0000).withOpacity(0.6),
                            child: const FaIcon(FontAwesomeIcons.one)),
                        Text(
                          "Bad",
                          style: GoogleFonts.urbanist(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    CircleAvatar(
                        backgroundColor:
                            const Color(0xffFFA500).withOpacity(0.6),
                        child: const FaIcon(FontAwesomeIcons.two)),
                    Column(
                      children: [
                        CircleAvatar(
                            backgroundColor:
                                const Color(0xffFFF500).withOpacity(0.6),
                            child: const FaIcon(FontAwesomeIcons.three)),
                        Text(
                          "Mid",
                          style: GoogleFonts.urbanist(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    CircleAvatar(
                        backgroundColor:
                            const Color(0xffBDFF00).withOpacity(0.6),
                        child: const FaIcon(FontAwesomeIcons.four)),
                    Column(
                      children: [
                        CircleAvatar(
                            backgroundColor:
                                const Color(0xff00FF75).withOpacity(0.6),
                            child: const FaIcon(FontAwesomeIcons.five)),
                        Text(
                          "Good",
                          style: GoogleFonts.urbanist(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "FEEDBACK",
                      style: GoogleFonts.urbanist(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: feedbackController,
                    decoration: const InputDecoration(),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                  onPressed: inputIsValid ? () => onSubmit() : null,
                  style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color.fromARGB(255, 234, 196, 72)),
                  child: Text(
                    "Submit",
                    style: GoogleFonts.urbanist(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
