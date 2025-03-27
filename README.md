# School Salary Database Project

This project was completed as part of the *Business Data Management* course at Rutgers University. It involves designing, cleaning, integrating, and analyzing salary and academic data for U.S. colleges and universities using MySQL.

## 🗂️ Project Overview

The goal of this project is to:
- Design normalized relational tables with integrity constraints.
- Load and clean raw CSV data sources (`school_src.csv` and `school_salary_src.csv`).
- Perform data integration and updates (e.g., conference reassignments).
- Write SQL queries to extract business insights, including salary trends, regional comparisons, and more.

## 🧩 Database Schema

Two main tables were created:

- `school(school_name, conference)`
- `school_salary(school, region, starting_median, mid_career_median, mid_career_90)`

> Salary fields are stored as numeric with preserved decimals for financial calculations.

## 🔧 Data Cleaning & Transformation

- Empty strings `''` converted to `NULL` values where appropriate.
- Salaries cleaned and cast from string to decimal.
- School names were standardized to match across both datasets.
- Updated outdated athletic conference memberships via SQL `UPDATE` statements.

## 📊 Key SQL Operations

The final script:
- Creates tables with constraints (e.g., primary keys, foreign keys).
- Loads and transforms data from CSVs.
- Performs analytical queries such as:
  - Formatting salaries with dollar signs and commas
  - Counting schools by conference
  - Filtering by region, salary, and school
  - Identifying top-earning schools by region

## 📁 Files Included

- `SchoolExercise.sql` – Full SQL script to run the project end-to-end
- `SchoolExercise.docx` - Full instructions for the project
- `school_src.csv` – Source data for school names and conferences
- `school_salary_src.csv` – Source data for salary information by school
- `README.md` – This file

## 🛠️ Technologies Used

- **MySQL**
- **CSV**
- **SQL Formatting Functions (FORMAT, CONCAT)**

## 📌 Notes

- This project was executed on a local MySQL server.
- All data cleaning and transformation were performed within SQL.
- Datasets were sourced from FiveThirtyEight and the Wall Street Journal, with some estimates added for consistency.

## 📬 Contact

Feel free to reach out with questions or suggestions!  
📧 mattcolao10@gmail.com  
🌐 [LinkedIn](#)
