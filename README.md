# IMDBViewer

## Demo project
- this project uses cocoapods, for simplicity the pods are not added to the .gitignore
- use the .xcworkspace in order to import this project into Xcode

### Disclaimer
at the moment the `top_rated` has a   "original_title": "दिलवाले दुल्हनिया ले जायेंगे", non utf-8 characters so the change filter fails to encode this text, since this encoding problem is out of the scope, the parse fails and show an alert dialog
