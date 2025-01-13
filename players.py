# Import packages
import pandas as pd
import sqlite3


# Read in the csv to a pandas df
players_df = pd.read_csv('data/players.csv')

# clean now_cost column to reflect accurate prices
players_df['now_cost'] = players_df['now_cost'].astype(float)

players_df['now_cost'] = players_df['now_cost'].apply(
  lambda x: x / 10
)

#change column types
try:
  players_df = players_df.astype({
    'id': 'int', 
    'name': 'string',  
    'position': 'string', 
    'team': 'string', 
    'total_points': 'int', 
    'goals_scored': 'int', 
    'assists': 'int', 
    'penalties_saved': 'int', 
    'expected_goal_involvements': 'float',
    'goals_conceded': 'int', 
    'creativity_rank': 'int', 
    'influence_rank': 'int',
    'threat': 'float', 
    'selected_rank': 'int', 
    'expected_assists': 'float', 
    'clean_sheets_per_90': 'float', 
    'clean_sheets': 'int', 
    'ict_index_rank_type': 'int',
    'points_per_game_rank_type': 'int', 
    'goals_conceded_per_90': 'float',
    'expected_goals_conceded': 'float', 
    'saves': 'int',
    'creativity': 'float', 
    'expected_goal_involvements_per_90': 'float',
    'expected_assists_per_90': 'float', 
    'expected_goals_per_90': 'float',
    'points_per_game': 'float', 
    'minutes': 'int',
    'status': 'string', 
    'expected_goals': 'float', 
    'threat_rank': 'int',
    'yellow_cards': 'int', 
    'red_cards': 'int', 
    'bps': 'int',
    'creativity_rank_type': 'int', 
    'points_per_game_rank': 'int',
    'influence_rank_type': 'int', 
    'saves_per_90': 'float',
    'influence': 'float', 
    'bonus': 'int', 
    'threat_rank_type': 'int',
    'own_goals': 'int', 
    'starts': 'int'})
except Exception as e:
    print(f"Error during type conversion: {e}")


# Write cleaned db to a new csv for visualizations and analyzation
players_df.to_csv('data/cleaned_players.csv', index=False)

# Set up sqlite connection and create/update a players table in players.db
conn = sqlite3.connect('data/fpl_picks.db')

players_df.to_sql("players", conn, if_exists="replace", index=False)

print("database updated")

