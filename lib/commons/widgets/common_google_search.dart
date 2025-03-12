import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class GoogleSearch extends StatefulWidget {
  const GoogleSearch({super.key});

  @override
  State<GoogleSearch> createState() => _GoogleSearchState();
}

class _GoogleSearchState extends State<GoogleSearch> {
  static final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
      googleAPIKey: dotenv.env["GOOGLE_API_KEY"] ?? '',
      inputDecoration: const InputDecoration(),
      debounceTime: 200, // default 600 ms,
      countries: const [], // optional by default null is set

      getPlaceDetailWithLatLng: (Prediction prediction) {
        // this method will return latlng with place detail
        Navigator.pop(context, prediction);
      }, // this callback is called when isLatLngRequired is true
      itemClick: (Prediction prediction) {},
      // if we want to make custom list item builder
      itemBuilder: (context, index, Prediction prediction) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(
                width: 7,
              ),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          ),
        );
      },
      // if you want to add seperator between list items
      seperatedBuilder: const Divider(),
      // want to show close icon
      isCrossBtnShown: true,
      // optional container padding
      containerHorizontalPadding: 10,
      textEditingController: TextEditingController(),
    );
  }

  @override
  void dispose() {
    controller.clear();

    super.dispose();
  }
}
