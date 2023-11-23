# # ComicVault

ComicVault is an iOS app designed for comic book enthusiasts to manage their comic book collections. It allows users to add comics to their collection, fetch current pricing information from eBay, and store this data in a Firestore database.

## Features

- Add comic books to a personal collection.
- Automatically fetch comic book prices from eBay's API.
- Store comic book data in Firestore.
- View and edit details of comic books in the collection.

## Requirements

- iOS 13.0+
- Xcode 12.0+
- Swift 5.3+
- An eBay Developer account for API access.
- Firebase setup with Firestore.

## Installation

1. **Clone the repository**:
git clone https://github.com/AmenTauhid/ComicVault.git

2. **Install dependencies**:
Navigate to the project directory and install the required CocoaPods:
cd ComicVault
pod install

Open the `.xcworkspace` file in Xcode.

3. **Firebase Setup**:
- Set up a Firebase project and add your iOS app to it.
- Download the `GoogleService-Info.plist` file and add it to the project.

4. **eBay API Setup**:
- Register for an eBay developer account and obtain your API credentials.
- Insert your eBay API key in the `EbayAPIManager.swift` file.

## Usage

1. **Add a Comic Book**:
- Tap on the 'Add Comic' button.
- Enter the comic's name, issue number, and release year.
- Tap 'Submit' to fetch the price from eBay and save the comic in Firestore.

2. **View Comic Collection**:
- The home screen displays your comic collection sorted by name and issue number.
- Swipe to delete a comic or tap 'Edit' to modify its details.

## Contributing

Contributions to ComicVault are welcome! Please read our contributing guidelines before submitting pull requests.

## License

ComicVault is released under the [MIT License](LICENSE).
