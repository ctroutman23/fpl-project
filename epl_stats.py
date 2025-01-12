# Import packages
import pandas as pd
import sqlite3


# Read in the csv to a pandas df
epl_stats_df = pd.read_csv('data/epl-stats-24-25.csv')





# Write cleaned db to a new csv for visualizations and analyzation
epl_stats_df.to_csv('data/cleaned_players.csv', index=False)


# Set up sqlite connection and create a players table in players.db
conn = sqlite3.connect('data/fpl_picks.db')

epl_stats_df.to_sql("epl_stats", conn, if_exists="replace", index=False)
