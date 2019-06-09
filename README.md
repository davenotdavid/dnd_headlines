# DND Headlines

A Flutter rewrite of the DND Headlines Android app.

DND Headlines is a news-feeder app that fetches top news stories from an open source back-end/API, News API, for a certain news source, and then displays the extracted news data onto a list UI (where each item is clickable to then display the respective news story within a web view widget).

A couple of design implementations to note (including, but not limited to):
- Integrates the News API Dart package within the client to allow getting JSON-decoded data
- Integrates the Firebase plug-in natively for both Android and iOS for storing/retrieving secure strings such as an API key
- Applies a native approach for handling JSON serialization
- Uses Dart’s native async/await for a Future to allow multi-threading
- Implements Flutter widgets accordingly to output a functional news app

Here are some screenshots of my debugging progress so far:

- Landing screen which displays the top 10 headlines for the selected news source via the list view widget:
![Screenshot_20190609-081546](https://user-images.githubusercontent.com/25012364/59159084-8a338000-8a92-11e9-8508-1bacd2d2d91a.png)

- Uses a third-party Flutter picker package to select a news source (where the list of options are deserialized from a static JSON file):
![Screenshot_20190609-081553](https://user-images.githubusercontent.com/25012364/59159085-8a338000-8a92-11e9-8491-1399fe693d3b.png)

- Renders the deserialized news source URL data to populate onto a web view widget:
![Screenshot_20190609-082005](https://user-images.githubusercontent.com/25012364/59159086-8a338000-8a92-11e9-8078-e6f235ed680f.png)
