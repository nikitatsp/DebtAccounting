# DebtAccounting

**DebtAccounting** is an iOS application designed to help users keep track of their debts efficiently. The app consists of three main screens and leverages Core Data for data storage. Table cells are sorted into sections based on the date, ensuring an organized and user-friendly experience. The app's screens are built using the VIPER architecture, while the table cells follow the MVVM architecture pattern. If you change theme on your phone, app also change colortheme.

## Screenshots

<p align="center">
    <img src="https://github.com/user-attachments/assets/ad985092-55b5-4b3e-989d-270a29348bf6" alt="Main Screen" width="150"/>
    &nbsp;
    <img src="https://github.com/user-attachments/assets/a910ea38-595c-4ca2-9ed8-208fac019e7e" alt="Active Debts" width="150"/>
    &nbsp;
    <img src="https://github.com/user-attachments/assets/32741f24-207d-4f9b-bd5d-1c98d228c191" alt="History Debts Screen" width="150"/>
</p>

<p align="center">
    <img src="https://github.com/user-attachments/assets/b07d8a2f-bc89-4bd3-ba61-ccc39945ea97" alt="Main Screen" width="150"/>
    &nbsp;
    <img src="https://github.com/user-attachments/assets/1e222381-2e89-4180-93d7-3232ef0250b1" alt="Active Debts" width="150"/>
    &nbsp;
    <img src="https://github.com/user-attachments/assets/308c0daf-71af-451b-a69b-36e6352d9f89" alt="History Debts Screen" width="150"/>
</p>

## Features

- **Core Data Integration**: The app uses Core Data for robust and efficient data storage.
- **Date-Based Sorting**: Debts are organized into sections based on their dates.
- **VIPER Architecture**: Ensures modularity and separation of concerns in the app's design.
- **MVVM Architecture for Table Cells**: Promotes clean code and maintainability for table views.
- **Currency Conversion**: Switch between Rubles and US Dollars. Exchange rates are fetched using URLSession.
