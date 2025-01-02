-- Use sql queries to find the best fpl picks 
-- based on the data from the 24-25 season so far (15 games)

-- Data points to consider:

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

-- Window function to refine the above query
CREATE VIEW most_expensive_players_by_position AS
WITH RankedPlayers AS (
    SELECT
        name,
        position,
        now_cost,
        now_cost_rank_type,
        ROW_NUMBER() OVER (PARTITION BY position ORDER BY now_cost_rank_type ASC ) AS rank 
    FROM players
)
SELECT 
    name,
    position,
    now_cost,
    now_cost_rank_type
FROM RankedPlayers
WHERE rank <= 5
ORDER BY position, now_cost_rank_type ASC;

-- Which players score the msot points?
-- Top 15
SELECT name, total_points
FROM players
ORDER BY total_points DESC
LIMIT 15;

-- WHich position scores the most points?
SELECT position, SUM(total_points)
FROM players
WHERE total_points >= 40
GROUP BY position;

-- Which team has the most fantasy points so far?
-- DROP VIEW team_total_fpl_points;
CREATE VIEW team_total_fpl_points AS
SELECT 
    DISTINCT team, 
    SUM(total_points) OVER (PARTITION BY team) AS team_total_points
FROM 
    players
ORDER BY 
    team_total_points DESC


-- Which players have the highest percentage of their
-- team's fantasy points (ordered by best to worst teams)?
-- DROP VIEW player_team_points_percentage;
CREATE VIEW player_team_points_percentage AS
SELECT 
    p.name,
    p.team,
    p.total_points,
    ttfp.team_total_points,
    ROUND((p.total_points * 100.0) / ttfp.team_total_points, 2) AS percentage_of_team_points 
FROM
    players AS p
JOIN
   team_total_fpl_points AS ttfp 
ON
    p.team = ttfp.team
WHERE 
    (p.total_points * 100.0) / ttfp.team_total_points  >= 10 --players with 10% or more of their team's points
ORDER BY
    team_total_points DESC,
    percentage_of_team_points DESC;    


-- Best Picks for Attacking returns
SELECT 
    name,
    team,
    total_points,
    goals_scored,
    expected_goals_per_90,
    assists, 
    expected_assists_per_90,
    expected_goal_involvements_per_90
FROM
    players
ORDER BY
    total_points DESC
LIMIT 50;

-- Are goals scorers under or overperforming?
CREATE VIEW goal_performance_vs_goal_expectations AS
SELECT
    name,
    team,
    expected_goals,
    goals_scored,
    ROUND(goals_scored - expected_goals, 2) AS finishing,
    CASE 
        WHEN expected_goals > goals_scored THEN 'Underperforming'
        WHEN expected_goals < goals_scored THEN 'Overperforming'
        ELSE 'Performing'
    END AS finishing_evaluation
FROM    
    players
WHERE
    goals_scored >= 3
ORDER BY
    goals_scored DESC,
    finishing DESC;


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

