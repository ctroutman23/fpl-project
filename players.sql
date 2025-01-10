-- Use sql queries to find the best fpl picks 
-- based on the data from the 24-25 season so far (15 games)

-- Data points to consider:


-- GENERAL INFO

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


-- Which players score the most points?
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



-- TEAM NUMBERS

-- Which team has the most fantasy points so far?
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


-- Goal involvement numbers by team
CREATE VIEW team_goal_involvement_numbers AS
SELECT 
    team, 
    SUM(goals_scored) AS total_team_goals,
    SUM(assists) AS total_team_assists,
    (SUM(goals_scored) + SUM(assists)) AS total_team_goal_involvement
FROM players
GROUP BY team
ORDER BY (SUM(goals_scored) + SUM(assists)) DESC;

-- Percentage players have of their team's goal involvements(goals and assists)
SELECT 
    players.name,
    players.goals_scored,
    players.assists,
    (players.goals_scored + players.assists) AS total_player_goal_involvement,
    ROUND(((players.goals_scored + players.assists) * 1.0 / team_goal_involvement_numbers.total_team_goal_involvement) * 100, 2) AS player_goal_inv_perc,
    team_goal_involvement_numbers.*
FROM
    team_goal_involvement_numbers
JOIN players ON team_goal_involvement_numbers.team = players.team
ORDER BY
    ROUND(((players.goals_scored + players.assists) * 1.0 / team_goal_involvement_numbers.total_team_goal_involvement) * 100, 2) DESC;

-- WHich teams are under/over performing their numbers?

-- Attack


-- Defense


-- ATTACKING PICKS

-- Best Picks for Attacking returns
CREATE VIEW attacking_numbers AS
SELECT 
    name,
    team,
    total_points,
    starts,
    goals_scored,
    expected_goals,
    expected_goals_per_90,
    assists, 
    expected_assists,
    expected_assists_per_90,
    expected_goal_involvements_per_90,
    ict_index,
    threat,
    creativity,
    influence,
    penalties_order,
    direct_freekicks_order
FROM
    players
ORDER BY
    total_points DESC;


-- Are goals scorers under or overperforming?
CREATE VIEW goal_performance_vs_goal_expectations AS
SELECT
    name,
    position,
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


-- Total Fantasy Point Breakdown by category for each player, rannked by total points
CREATE VIEW fantasy_point_breakdown_by_category AS
WITH fantasy_points_breakdown AS (
    SELECT 
        name,
        position,
        team,
        total_points,
        -- minutes/apperance points
        (starts + CASE 
            WHEN (minutes / starts) >= 60 THEN starts 
            ELSE 0 END) AS appearance_points,
        -- goals
        CASE  
            WHEN position = 'FWD' THEN goals_scored * 4 
            WHEN position = 'MID' THEN goals_scored * 5
            WHEN position = 'DEF' THEN goals_scored * 6
            ELSE goals_scored * 10
        END AS goal_points,
        -- assists
        (assists * 3) AS assist_points,
        -- clean sheets
        CASE
            WHEN position = 'MID' THEN clean_sheets * 1 
            WHEN position IN ('DEF', 'GKP') THEN clean_sheets * 4
            ELSE clean_sheets * 0
        END AS clean_sheet_points, 
        -- saves
        CASE
            WHEN position = 'GKP' THEN saves / 3 
            ELSE 0
        END AS save_points,
        -- penalty saves
        CASE
            WHEN position = 'GKP' THEN penalties_saved * 5 
            ELSE 0
        END AS penalty_save_points,
        -- bonus points
        bonus AS bonus_points,
        -- yellow cards
        (yellow_cards * -1) AS yellow_card_points,
        -- red cards
        (red_cards * -3) AS red_card_points,
        -- own goals
        (own_goals * -2) AS own_goal_points,
        -- penalties missed
        (penalties_missed * -2) AS penalty_miss_points
    FROM
        players
)
SELECT
    name,
    position,
    team,
    total_points,
    appearance_points,
    goal_points,
    assist_points,
    clean_sheet_points,
    save_points,
    penalty_save_points,
    bonus_points,
    yellow_card_points,
    red_card_points,
    own_goal_points,
    penalty_miss_points,
    -- the dataset is missing the data we need to calculate penalty-conceded points
    -- goals conceded
    CASE
         WHEN position IN ('DEF', 'GKP') THEN
            (total_points - (appearance_points + goal_points + assist_points + 
            clean_sheet_points + save_points + penalty_save_points + bonus_points + 
            yellow_card_points + red_card_points + own_goal_points + 
            penalty_miss_points)) 
         ELSE 0
    END AS goals_conceded_points
FROM
    fantasy_points_breakdown
ORDER BY
    total_points DESC;


-- Points scored by players from top 6 teams
SELECT * FROM fantasy_point_breakdown_by_category
WHERE team IN ("Liverpool", "Arsenal", "Chelsea", "Nott'm Forest", "Newcastle", "Man City");



-- DEFENSIVE PICKS

-- Best picks for defensive returns
CREATE VIEW defensive_numbers AS
SELECT 
    name,
    team,
    position,
    total_points,
    starts,
    minutes,
    clean_sheets,
    clean_sheets_per_90,
    saves,
    saves_per_90,
    penalties_saved,
    goals_conceded,
    goals_conceded_per_90,
    expected_goals_conceded,
    expected_goals_conceded_per_90,
    bps
FROM
    players
WHERE
    position IN ('DEF', 'GKP')
ORDER BY
    total_points DESC;



