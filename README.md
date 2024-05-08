<table border=0>
    <tr>
        <td>
            <image src=https://github.com/Saydulayev/SwiftUIPosts/blob/main/SwiftUIPosts/Screenshot/Simulator%20Screenshot.png width=230 align=center>
        </td>
    </tr>
</table>
              
# SwiftUIPosts

SwiftUIPosts is a straightforward demonstration of using SwiftUI and Combine to fetch and display data from a remote JSON API. This project illustrates how to integrate Combine with SwiftUI for efficient network operations and UI updates, following the Model-View-ViewModel (MVVM) architecture.

## Features

- **Asynchronous Network Requests:** Utilizes `URLSession` with Combine's `dataTaskPublisher` to perform network requests asynchronously.
- **Data Decoding:** Decodes the incoming JSON data into a list of `Post` models, conforming to the `Codable` protocol.
- **Reactive UI Updates:** Uses SwiftUI along with Combine's `@Published` properties in the `PostsViewModel` to update the UI reactively as data changes.
- **Error and Loading State Management:** Implements error handling and displays a loading state during data fetching to enhance user interaction.

## Architecture

This demo is structured using the MVVM pattern:
- **Model (`Post`):** Represents the data structure for posts.
- **View (`PostsView` & `PostCell`):** Manages the UI, displaying posts in a list format.
- **ViewModel (`PostsViewModel`):** Handles the business logic, linking the model and the view through reactive updates.

## Running the Demo

To run the CombinePostsDemo, clone this repository and open the project in Xcode. Make sure you have an active internet connection to fetch posts from the provided JSON API.
