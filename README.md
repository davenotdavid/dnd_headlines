# DND Headlines [![Build Status](https://app.bitrise.io/app/fc857c06d9e15704/status.svg?token=V1rAoQ3inC0Sm_DlS-N3uQ&branch=flutter)](https://app.bitrise.io/app/fc857c06d9e15704)

**- For a step-by-step guide in how to replicate this project somewhat, tutorial videos can be found in this YouTube playlist here: https://www.youtube.com/playlist?list=PLeDXK3HCrf1Y5Bz-Js4PQU4o3EV7FxaBM**

A Flutter rewrite of the existing [DND Headlines Android app](https://play.google.com/store/apps/details?id=com.davenotdavid.dndheadlines).

DND Headlines is a news-feeder app that fetches top news stories from an open source, back-end service, News API, for a certain media outlet, and then displays the extracted news data onto a list UI (where each item is clickable to then display the respective news story within a web view).

A couple of design implementations to note (including, but not limited to):
- Integrates the News API Dart package within the client to allow getting JSON-decoded data
- Integrates the Firebase plug-in natively for both Android and iOS for storing/retrieving secure strings such as an API key
- Applies a native approach for handling JSON serialization
- Uses Dart’s native async/await for a `Future` object to allow multi-threading
- Implements Flutter widgets accordingly to output a functional news app

Here are some screenshots for both Android and iOS:

**Android (on a Pixel 2)**:
- Uses a third-party Flutter picker package to select a media outlet:
![phone_screenshot1](https://user-images.githubusercontent.com/25012364/80921365-f02c9400-8d43-11ea-9d87-4b86b2309e3a.png)

- Headlines screen which displays the top 10 headlines for the selected media outlet via a list view:
![phone_screenshot2](https://user-images.githubusercontent.com/25012364/80921426-51ecfe00-8d44-11ea-8929-71fa31b7c6d7.png)

- Renders the deserialized media URL data to populate onto a web view:
![phone_screenshot3](https://user-images.githubusercontent.com/25012364/80921433-67622800-8d44-11ea-944f-6b1b8f01d2cf.png)

**iOS (on an iPhone 11 Pro Max)**:
- Uses a third-party Flutter picker package to select a media outlet:
![image](https://user-images.githubusercontent.com/25012364/80921475-9f696b00-8d44-11ea-8d3e-e873a90a9280.png)

- Headlines screen which displays the top 10 headlines for the selected media outlet via a list view:
![image](https://user-images.githubusercontent.com/25012364/80921480-ad1ef080-8d44-11ea-8860-aaf4737e3cb2.png)

- Renders the deserialized media URL data to populate onto a web view:
![image](https://user-images.githubusercontent.com/25012364/80921487-b445fe80-8d44-11ea-8b28-0f05958eba7a.png)
