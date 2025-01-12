-- Queries epl_stats
SELECT * FROM epl_stats;


-- Away vs. Home stats

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

  