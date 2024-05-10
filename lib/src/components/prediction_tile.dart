import 'package:flutter/material.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:mapbox_place_picker/mapbox_place_picker.dart';

class PredictionTile extends StatelessWidget {
  final Features prediction;
  final String searchTerm;
  final ValueChanged<Features>? onTap;
  final Function(Features prediction, String value)? onPressed;
  const PredictionTile({
    required this.prediction,
    required this.searchTerm,
    this.onTap,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_on),
      title: RichText(
        text: TextSpan(
          children: _buildPredictionText(context),
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap!(prediction);
        }
      },
    );
  }

  List<TextSpan> _buildPredictionText(BuildContext context) {
    final List<TextSpan> result = <TextSpan>[];
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    result.add(
      TextSpan(
        text: prediction.placeName ?? '',
        style: TextStyle(
            color: textColor, fontSize: 16, fontWeight: FontWeight.w300),
      ),
    );
    // if (prediction.matchedSubstrings.length > 0) {
    //   MatchedSubstring matchedSubString = prediction.matchedSubstrings[0];
    //   // There is no matched string at the beginning.
    //   if (matchedSubString.offset > 0) {
    //     result.add(
    //       TextSpan(
    //         text: prediction.description
    //             ?.substring(0, matchedSubString.offset as int?),
    //         style: TextStyle(
    //             color: textColor, fontSize: 16, fontWeight: FontWeight.w300),
    //       ),
    //     );
    //   }

    //   // Matched strings.
    //   result.add(
    //     TextSpan(
    //       text: prediction.description?.substring(
    //           matchedSubString.offset as int,
    //           matchedSubString.offset + matchedSubString.length as int?),
    //       style: TextStyle(
    //           color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
    //     ),
    //   );

    //   // Other strings.
    //   if (matchedSubString.offset + matchedSubString.length <
    //       (prediction.description?.length ?? 0)) {
    //     result.add(
    //       TextSpan(
    //         text: prediction.description?.substring(
    //             matchedSubString.offset + matchedSubString.length as int),
    //         style: TextStyle(
    //             color: textColor, fontSize: 16, fontWeight: FontWeight.w300),
    //       ),
    //     );
    //   }
    //   // If there is no matched strings, but there are predicts. (Not sure if this happens though)
    // } else {
    //   result.add(
    //     TextSpan(
    //       text: prediction.description,
    //       style: TextStyle(
    //           color: textColor, fontSize: 16, fontWeight: FontWeight.w300),
    //     ),
    //   );
    // }

    return result;
  }
}
