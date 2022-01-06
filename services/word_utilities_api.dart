abstract class WordUtilitiesApi {
  ///This calculates the **number** of occurences of each element in the provided
  ///list
  Map<String, dynamic> calculateNumberOfWordOccurences({List<String>? words});

  ///This method extracts useful information from the given list.
  ///The said information includes what words are:
  ///
  /// > - numbers
  /// > - IP-addresses
  /// > - email-addresses
  /// > - postal codes
  /// > - URLs, etcetera
  /// 
  /// It accomplishes this using useful methods from the [validators](https://pub.dev/packages/validators) package
  Map<String, dynamic> extractUsefulInformationFromWords({List<String>? words});
}
