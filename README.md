# Feedback App

An iOS app to list and manage submitted feedbacks with status indicators and persistent storage i.e. Core Data and file directory.

## Features

- **Feedback List:**  
  Displays feedback with a status indicator in green (success) if saved to  `Azure` or red (failure) if saved to `FeedbackCache`, title, and message.

- **List Operations:**
  - Add Feedback on click of '+' icon on nav bar
  - Tap open existing feedback will allow to update message
  - Swipe left any row will allow to delete the row from core data and file directory
  - List contains items based on unique titles i.e. does not allows duplicate titles and throws alert if tried.

- **Files Operations:**  
  - Successful feedbacks saved to `Azure` directory.  
  - Failed feedbacks cached in `FeedbackCache` directory.  
  - All feedback saved as `.txt` files in Documents directory.
  - To open feedbacks you need to run this command with appropriate values in terminal `open /Users/<Username>/Library/Developer/CoreSimulator/Devices/<Device_ID>/data/Containers/Data/Application/<AppContainer_ID>/Documents`

 
- **CRUD Operations:**
  - **C**reate Feedbacks.
  - **R**ead Feedbacks, fetch on list load.
  - **U**pdate Feedbacks.
  - **D**eletes Feedback on row swipe.
  - UI updates driven solely by Core Data.

- **Failure Handling:**   
  - On app background/foreground, retries all failed feedbacks and move to azure directory and updates UI.

## Data Storage

- Core Data for metadata and UI updates.  
- File system for feedback files, Azure directory (success), and FeedbackCache (failures).

## Design Pattern Used
This project follows a clean **MVVM architecture** with a Repository pattern, offering a modular, testable, and scalable approach.
**Repository Pattern**
All data operations are centralized in FeedbackRepository, which acts as a bridge between:
- Storage Layer (FeedbackStorageServiceProtocol) – handles Core Data operations.
- File Layer (FeedbackFileServiceProtocol) – handles saving/moving/deleting feedback files in the app’s document directory.
