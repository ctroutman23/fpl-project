import sqlite3
import os
import csv

# This script is meant to be an automation for exporting the views created in this 
# program to CSV files.


# Path to SQLite database
db_file = "data/fpl_picks.db"


output_dir = 'viz_data'
os.makedirs(output_dir, exist_ok=True) 


# Connect to SQLite database
conn = sqlite3.connect('data/fpl_picks.db')
cursor = conn.cursor()


# Get all the view names
cursor.execute("SELECT name, type FROM sqlite_master WHERE type IN ('view');")
views = cursor.fetchall()


# Export each view to a csv file
for view_name, _ in views:
    print(f"Exporting view: {view_name}")

    # Query all rows from the views
    cursor.execute(f"SELECT * FROM '{view_name}'")
    rows = cursor.fetchall()

    # Get the column names from the the rows in the above query
    column_names = [description[0] for description in cursor.description]


    # Create the csv files for the views
    csv_file = os.path.join(output_dir, f"{view_name}.csv")
    with open(csv_file, mode="w", newline="", encoding="utf-8") as file:
      writer = csv.writer(file)

      # make the header the column names
      writer.writerow(column_names)

      # write the rows
      writer.writerows(rows)

    print(f"Exported {view_name} to {csv_file}")

# Close database connection
conn.close()

print(f"All tables and views have been exported to the folder: {os.path.abspath(output_dir)}")