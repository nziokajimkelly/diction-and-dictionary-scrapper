import 'package:validators/validators.dart';

import 'word_utilities_api.dart';

class WordUtilitiesService implements WordUtilitiesApi {
  @override
  Map<String, dynamic> calculateNumberOfWordOccurences({List<String>? words}) {
    Map<String, dynamic> _wordsAndNumberOfOcurrences = {};
    words!.forEach((word) {
      _wordsAndNumberOfOcurrences[word] =
          (_wordsAndNumberOfOcurrences[word] ?? 0) + 1;
    });
    return _wordsAndNumberOfOcurrences;
  }

  @override
  Map<String, dynamic> extractUsefulInformationFromWords({List<String>? words}) {
    List<String> _numbers = [];
    List<String> _emails = [];
    List<String> _ipAddresses = [];
    List<String> _urls = [];
    List<String> _dates = [];
    List<String> _postalCodes = [];
    List<String> _words = [];

    words!.forEach((word) {
      if (isNumeric(word)) {
        _numbers.add(word);
      } else if (isEmail(word)) {
        _emails.add(word);
      } else if (isURL(word)) {
        _urls.add(word);
      } else if (isDate(word)) {
        _dates.add(word);
      } else if (isIP(word)) {
        _ipAddresses.add(word);
      } else if (isPostalCode(word, "US")) {
        _postalCodes.add(word);
      } else {
        _words.add(word);
      }
    });

    Map<String, dynamic> _extractedInformation = {
      "numbers": _numbers,
      "emails": _emails,
      "urls": _urls,
      "dates": _dates,
      "ipAddresses": _ipAddresses,
      "postalCodes": _postalCodes,
      "words": _words,
    };

    return _extractedInformation;
  }
}
