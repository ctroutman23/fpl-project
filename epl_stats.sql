-- Queries epl_stats
SELECT * FROM epl_stats;


-- Away vs. Home stats

-- Away Games
CREATE VIEW total_away_games AS
SELECT 
  AwayTeam,
  COUNT(AwayTeam) AS AwayGames
FROM
  epl_stats
GROUP BY
  AwayTeam;

-- Home Games
CREATE VIEW total_home_games AS
SELECT 
  HomeTeam,
  COUNT(HomeTeam) AS HomeGames
FROM
  epl_stats
GROUP BY
  HomeTeam;

-- Attack

-- Away
CREATE VIEW team_attack_away AS
SELECT 
  AwayTeam,
  SUM(FTAG) AS goals_scored_away,
  SUM(`AS`) AS shots_away,
  SUM(AST) AS shots_on_target_away
FROM
  epl_stats
GROUP BY
  AwayTeam
ORDER BY
  SUM(FTAG) DESC;

-- Add in away games column
CREATE VIEW team_attack_away_with_games AS
SELECT
  taa.AwayTeam,
  tag.AwayGames,
  taa.goals_scored_away,
  taa.shots_away,
  taa.shots_on_target_away
FROM
  team_attack_away AS taa 
JOIN
  total_away_games AS tag
ON
  taa.AwayTeam = tag.AwayTeam;

-- Home
CREATE VIEW team_attack_home AS
SELECT
  HomeTeam,
  SUM(FTHG) AS goals_scored_home,
  SUM(HS) AS shots_home,
  SUM(HST) AS shots_on_target_home
FROM
  epl_stats
GROUP BY
  HomeTeam
ORDER BY
  SUM(FTHG) DESC;

-- Add in home games column
CREATE VIEW team_attack_home_with_games AS
SELECT
  tah.HomeTeam,
  thg.HomeGames,
  tah.goals_scored_home,
  tah.shots_home,
  tah.shots_on_target_home
FROM
  team_attack_home AS tah 
JOIN
  total_home_games AS thg
ON
  tah.HomeTeam = thg.HomeTeam;

-- Defense

-- Away
CREATE VIEW team_defense_away AS
SELECT 
  AwayTeam,
  SUM(FTHG) AS goals_conceded_away,
  SUM(HS) AS shots_conceded_away,
  SUM(HST) AS shots_on_target_conceded_away
FROM
  epl_stats
GROUP BY
  AwayTeam
ORDER BY
  SUM(FTHG);

-- Add in away games column
CREATE VIEW team_defense_away_with_games AS
SELECT
  tda.AwayTeam,
  tag.AwayGames,
  tda.goals_conceded_away,
  tda.shots_conceded_away,
  tda.shots_on_target_conceded_away
FROM
  team_defense_away AS tda 
JOIN
  total_away_games AS tag
ON
  tda.AwayTeam = tag.AwayTeam;

-- Home
CREATE VIEW team_defense_home AS
SELECT 
  HomeTeam,
  SUM(FTAG) AS goals_conceded_home,
  SUM(`AS`) AS shots_conceded_home,
  SUM(AST) AS shots_on_target_conceded_home
FROM
  epl_stats
GROUP BY
  HomeTeam
ORDER BY
  SUM(FTAG);

-- Add in home games column
CREATE VIEW team_defense_home_with_games AS
SELECT
  tdh.HomeTeam,
  thg.HomeGames,
  tdh.goals_conceded_home,
  tdh.shots_conceded_home,
  tdh.shots_on_target_conceded_home
FROM
  team_defense_home AS tdh 
JOIN
  total_home_games AS thg
ON
  tdh.HomeTeam = thg.HomeTeam;

  