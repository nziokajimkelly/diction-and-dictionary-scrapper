import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:validators/validators.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import '../constants/regexp_constants.dart';
import '../services/word_utilities_service.dart';

void main(List<String> args) async {
  
  //Check if the program has been run correctly. Data is fed into this program via
  //the command line
  if (args.isEmpty) {
    stderr.writeln(
        "[Error] - Usage should be as follows: [path/to/executable] [url]");
    //Here, we are making use of the exit() method from dart:io to terminate program execution.
    //A code of 2 usually indicates an error. In this case, it is one, since the program hasn't been
    //correctly executed
    exit(2);
  }

  //Get the desired web-page from the list of supplied arguments
  //We check if the said URL is valid. If not, we react accordingly
  String _url = args[0];
  if (_url.isEmpty) {
    stderr.writeln("The required URL cannot be empty. Terminating program");
    exit(2);
  }

  if (!isURL(_url)) {
    stderr.writeln("Please provide a valid URL. Exiting program");
    exit(2);
  }

  final RetryOptions _options = RetryOptions(maxAttempts: 20);

  //To make a HTTP request, we first need to create a Uri object from a url String
  Uri _uri = Uri.parse(_url);

  //We make use of the retry() method from the retry package to try and make a connection to the provided Web-page
  //If certain exceptions are thrown, such as a TimeOutException or SocketException, the method retrys making
  //the HTTP call, up until either:
  //1. A connection is successfuloy made, OR
  //2. The number of maxAttempts provided to the RetryOptions constructor is completed
  final http.Response _response = await _options.retry(
      () => http.get(_uri).timeout(Duration(seconds: 10)),
      retryIf: (error) => error is TimeoutException || error is SocketException,
      onRetry: (error) {
        if (error is SocketException) {
          stderr.writeln(
              "Program has been trying to connect to the Internet but hasn't been able to. Retrying...");
        } else if (error is TimeoutException) {
          stderr.writeln(
              "Oh, snap! Looks like the connection timed out. Retrying...");
        }
      });

  //Get the status code received after successfully making a connection to the target URL
  final int _statusCode = _response.statusCode;

  //If a status code other than 200 was received, we assume that an error most probably ocurred.
  //Ergo, we terminate the program with an exit code of 2
  if (_statusCode != 200) {
    stderr.writeln(
        "Something went wrong while attempting to make a connection to $_url");
    stderr.writeln("Web-page responded with status code $_statusCode");
    exit(2);
  }

  //Here, we get the body from the response. This will mark a major foray into us getting the desired text from
  //the web-page
  final String _responseBody = _response.body;
  final String _encodedBody = jsonEncode(_responseBody);
  final String _jsonDecodedBody = jsonDecode(_encodedBody);

  final String _pathToDirectoryWithBodyContents = "output/raw_body.txt";
  final File _rawBodyContentFile =
      await File(_pathToDirectoryWithBodyContents).create(recursive: true);

  await _rawBodyContentFile.writeAsString(_jsonDecodedBody);
  stdout.writeln(
      "Successfully written the raw response from $_url to $_pathToDirectoryWithBodyContents");

  final String _trimmedString = _jsonDecodedBody.trim();

  //Making use of a regular expression, we go through the text from the website, trying to see if a match is found
  final Iterable<RegExpMatch> _allMatches =
      wordRegExp.allMatches(_trimmedString);

  //Here, we extract the words from the matches made, removing any whitespace before and after each word
  final List<String> _matches =
      _allMatches.map((match) => match.group(0)!.trim()).toList();

  if (_matches.isNotEmpty) {
    _matches.sort((a, b) => a.compareTo(b));
    final Set<String> _setOfUniqueWords = {..._matches};
    stdout.writeln("Exctracted unique words from the Web-page's contents");
    final List<String> _listOfUniqueWords = [..._setOfUniqueWords];
    _listOfUniqueWords.sort((a, b) => a.compareTo(b));

    Map<String, dynamic> _wordsAndNumberOfOcurrences =
        WordUtilitiesService().calculateNumberOfWordOccurences(words: _matches);

    Map<String, dynamic> _extractedInformation = WordUtilitiesService()
        .extractUsefulInformationFromWords(words: _listOfUniqueWords);

    final String _pathToDirectoryWithUniqueWords = "output/unique_words.json";
    final File _uniqueWordsContentsFile =
        await File(_pathToDirectoryWithUniqueWords).create(recursive: true);

    final String _pathToDirectoryWithUsefulExtractedInformation =
        "output/useful_extracted_info.json";
    final File _usefulExtractedInformationFile =
        await File(_pathToDirectoryWithUsefulExtractedInformation)
            .create(recursive: true);

    final String _pathToDirectoryWithWordsAndNumberOfOccurrences =
        "output/words_and_number_of_occurences.json";
    final File _wordsAndNumberOfOcurrencesFile =
        await File(_pathToDirectoryWithWordsAndNumberOfOccurrences)
            .create(recursive: true);

    //Create an Iterable<Future> containing Futures we wish to await
    //The operations underway comprise populating the relevant files
    //with the appropriate information
    Iterable<Future> _listOfFutures = [
      _uniqueWordsContentsFile.writeAsString(jsonEncode(_listOfUniqueWords)),
      _usefulExtractedInformationFile
          .writeAsString(jsonEncode(_extractedInformation)),
      _wordsAndNumberOfOcurrencesFile
          .writeAsString(jsonEncode(_wordsAndNumberOfOcurrences)),
    ];

    //Await for all Futures to complete.
    await Future.wait(_listOfFutures);
    stdout.writeln("Operation was successful");
    exit(0);
  }
}
