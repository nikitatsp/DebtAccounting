
# DebtAccounting

**DebtAccounting** is an iOS application designed to help users keep track of their debts efficiently. The app consists of three main screens and leverages Core Data for data storage. Table cells are sorted into sections based on the date, ensuring an organized and user-friendly experience. The app's screens are built using the VIPER architecture, while the table cells follow the MVVM architecture pattern.

## Screenshots

<p align="center">
    <img src="https://github.com/user-attachments/assets/4716fe58-64da-4bfa-b92d-3951812892fb" alt="Main Screen" width="250"/>
    <img src="https://github.com/user-attachments/assets/6e3dd44d-1ff2-4140-ac0b-f63518a189b7" alt="Active Debts" width="250"/>
    <img src="https://github.com/user-attachments/assets/f32ffca2-3d14-4ace-ae99-75630e5ad92d" alt="History Debts Screen" width="250"/>
</p>

## Features

- **Core Data Integration**: The app uses Core Data for robust and efficient data storage.
- **Date-Based Sorting**: Debts are organized into sections based on their dates.
- **VIPER Architecture**: Ensures modularity and separation of concerns in the app's design.
- **MVVM Architecture for Table Cells**: Promotes clean code and maintainability for table views.
- **Currency Conversion**: Switch between Rubles and US Dollars. Exchange rates are fetched using URLSession.
