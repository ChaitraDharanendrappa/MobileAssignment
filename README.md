MobileAssignment
================

This is a simple one-screen iOS app that grabs the device’s location from the operating system and submits it to a REST API.

The app has following functionalities:

1. The latitude/longitude on the screen gets updated continuously based on the device’s location when the app is in the foreground.

2. The name field defaults t “John Doe”, but it can be edited and stored so that it persists between app restarts.

3. The last submitted line shows a relative time (e.g. 5 seconds ago, 20 minutes ago, etc) of when the information was last submitted to the server.

4. HTTP request is being made with name, latitude and longitude whenever user taps submit button or the app first starts or the app goes to the background .

5. Successful SUBMIT will return a 201 response. 


AFNetworking is used for converting CURL command to HTTP request with basic HTTP auth done.
