# Vehicles Sales PowerBI-Based Project

### Project Overview

The goal of this project is to create an overall trends analysis for as much data, to have an overall knowledge about the vehicles market and sales for the company. It is -in my opinion- an excellent project to enhance my skills in visualizations generally and in Power BI particularly.

### Data Source
Original data used is from this [Kaggle link.](https://www.kaggle.com/datasets/kyanyoga/sample-sales-data/data)

### Data Cleaning and Preparation with Excel

- Generally, this dataset did not need much of cleaning. I deleted useless rows, checked for duplicates and empty rows, searched for illogical values like negative quantities and percentages that are greater than 100%.
- I re-formated the date column to `yyyy-mm-dd` so it would be suitable for SQL for later use.
- There was a problem with the price column, where prices larger than a 100 seemed to be inserted as 100 no matter how much is it. I fixed it by deviding sales for each order for a specific item, by the number of that specific item ordered, to find the price of each piece.
- Another problem was that Territory column, "APAC" was mistakengly replaced with "Japan". With a simple usage of `Find & Select > Replace` in Excel's ribbon, the problem was solved.

### Data Extraction by MySQL

Using SQL, I extracted snippets of data to be used later for further exploration by visualizations and charts. The script is in the repository.

### Creating the dashboard by Power BI

Using the snippets of data extracted above by SQL, the dashboard was created, featuring trends and insights.

![p1](https://github.com/user-attachments/assets/39b9ba9c-7f23-4f92-96a8-5b36628948fe)
![p2](https://github.com/user-attachments/assets/5349e0ca-138a-4e22-a7ad-428aa2e60fce)
![p3](https://github.com/user-attachments/assets/68505579-95f1-4454-ac2f-033a66f5e76f)


### Insights and Trends

- The most sold Products in the whole world are Classic Cars and Motorcycles.
- Sales has 

