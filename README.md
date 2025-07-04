# Feedback App

An iOS app to list and manage submitted feedbacks with status indicators and persistent storage i.e. Core Data.

## Features

- **Feedback List:**  
  Displays feedback with a status indicator in green (success) if saved to  `Azure` or red (failure) if saved to `FeedbackCache`, title, and message.

- **CRUD Operations:**  
  - Successful feedbacks saved to `Azure` directory.  
  - Failed feedbacks cached in `FeedbackCache` directory.  
  - All feedback saved as `.txt` files in Documents directory.  
  - UI updates driven solely by Core Data.

- **Failure Handling:**   
  - On app background/foreground, retries failed feedbacks and updates UI.

## Data Storage

- Core Data for metadata and UI updates.  
- File system for feedback files, Azure directory (success), and FeedbackCache (failures).

