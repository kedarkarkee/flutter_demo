# Demo Project to showcase different flutter design patterns

- App is made with the stateful shell route including bottom nav bar
- The nested route can be tested on Products tab by clicking on product and going to detail page
- The dialog after an async task is implemented when adding/editing/deleting todo. Though snackbar is used but its similar approach
- The access_token is send to request through `AuthInterceptor`. The refresh_token happens in file `app_client.dart` whenever there is 401 response from API.
