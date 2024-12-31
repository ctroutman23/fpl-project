-- Use sql queries to find the best fpl picks 
-- based on the data from the 24-25 season so far

-- Data points to consider:
-- cost (now_cost)

-- Most Expensive Picks 1-15
SELECT name, now_cost 
FROM players 
ORDER BY now_cost DESC
LIMIT 15;

-- Most Expensive Picks Each Position
-- First
SELECT name, position, now_cost, now_cost_rank_type
FROM players
WHERE now_cost_rank_type = 1;

-- Top 5
SELECT name, position, now_cost, now_cost_rank_type
FROM players
WHERE players.now_cost_rank_type BETWEEN 1 AND 5
ORDER BY now_cost_rank_type ASC;

-- position
-- team
-- total_points
-- assists
-- expected_assists_per_90
-- goals (goals_scored)
-- expected_goals_per_90
-- expected_goal_involvments_per_90
-- creativity
-- creativity_rank
-- influence_rank
-- threat
-- clean_sheets_per_90
-- clean_sheets
-- expected_goals_conceded_per_90
-- saves
-- saves_per_90
-- minutes
-- starts
-- starts_per_90
-- bonus (bps)
--status (a - available, u - unavailable)

