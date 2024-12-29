#put into requirements.txt later
import pandas as pd

players_df = pd.read_csv('data/players.csv')

# clean now_cost column to reflect accurate prices
players_df['now_cost'] = players_df['now_cost'].astype(float)

players_df['now_cost'] = players_df['now_cost'].apply(
  lambda x: x / 10
)


players_df.to_csv('data/cleaned_players.csv', index=False)
 

# -- Use sql queries to find the best fpl picks 
# -- based on the data from the 24-25 season so far

# -- Data points to consider:
# -- cost (now_cost)
# -- position
# -- team
# -- total_points
# -- assists
# -- expected_assists_per_90
# -- goals (goals_scored)
# -- expected_goals_per_90
# -- expected_goal_involvments_per_90
# -- creativity
# -- creativity_rank
# -- influence_rank
# -- threat
# -- clean_sheets_per_90
# -- clean_sheets
# -- expected_goals_conceded_per_90
# -- saves
# -- saves_per_90
# -- minutes
# -- starts
# -- starts_per_90
# -- bonus (bps)
# --status (a - available, u - unavailable)
