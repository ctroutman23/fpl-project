#put into requirements.txt later
import pandas as pd

players_df = pd.read_csv('data/players.csv')

# clean now_cost column to reflect accurate prices
players_df['now_cost'] = players_df['now_cost'].astype(float)

players_df['now_cost'] = players_df['now_cost'].apply(
  lambda x: x / 10
)


players_df.to_csv('data/cleaned_players.csv', index=False)
 