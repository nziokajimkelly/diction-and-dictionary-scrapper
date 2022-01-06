## A Diction & Dictionary Scarapper Written In Dart

### Description

This is a basic diction and dictionary scrapper written in the Dart programming language. Given a web-page's URL, it is able to read text on the aforementioned page, extract some useful information from it, and output the information to the user in user-readable JSON format.

### Dependencies

To compile this code, you need to have the [Dart SDK](https://dart.dev/get-dart) installed somewhere on your system.


In addition, you need to make sure you've installed the following dependencies from [pub.dev](https://pub.dev/), described as the official package repository for [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/) apps.

> - [http](https://pub.dev/packages/http)
> - [retry](https://pub.dev/packages/retry)
> - [validators](https://pub.dev/packages/validators)

> Please make sure you have a strong Internet connection to be able to install these dependencies


### Getting Started

The above dependencies are declared in the pubspec.yaml file in the root folder of this project. Simply **cd** into where you've put your project and fetch the packages by typing the following command on your terminal like so:

    $ dart pub get

Then press **ENTER**

The above packages will be fetched from [pub.dev](https://pub.dev/), and if everyting goes well, you should get output that closely resembles this:

    Resolving dependencies... (4.4s)
    + async 2.8.2
    + charcode 1.3.1
    + collection 1.15.0
    + http 0.13.3 (0.13.4 available)
    + http_parser 4.0.0
    + meta 1.7.0
    + path 1.8.1
    + pedantic 1.11.1 (discontinued replaced by lints)
    + retry 3.1.0
    + source_span 1.8.1
    + string_scanner 1.1.0
    + term_glyph 1.2.0
    + typed_data 1.3.0
    + validators 3.0.0
    Changed 14 dependencies!

> Please note that the above output may be different (the version numbers, for instance), depending on when
> you run the command

You're now ready to compile the source code into an AOT executable.

For this project, the source code lives in the **src** directory.

Compile the code like so:

    $ dart compile exe src/main.dart --output bin/main.exe

This compiles the source code into an executable file named **main.exe**, storing it in the **bin** directory.

> At the time of this writing, Dart has no support for cross-platform 
> compilation. To compile for each different platform, such as Windows'
> Linux, or Mac, you need to issue the above compilation command on 
> each OS.

The compilation process proceeeds with the following output:

    Info: Compiling with sound null safety
    Generated: /path/to/project/bin/main.exe

### Usage

Running your compiled executable is easy:

    $ ./bin/main.exe [web-page-url]

Replace [web-page-url] with the actual URL of the web-page whose contents you wish to read.

After the program successfully exits, you should now be able to see the processed output in the **output** folder.


