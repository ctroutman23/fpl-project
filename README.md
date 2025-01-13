# fpl-project

Fantasy Premier League (FPL) is a fantasy sports game based on the English Premiere League season.

As a basic overview of the game, you pick players to be on your team and (hopefully) score your team points. Unlike American fantasy football, FPL allows you to pick whichever players you want, meaning you can have the same players as other teams. However, each player is given a price, and you are given a €100 million budget to spend on 15 players at the beginning of the season. Each week you start 11 of your 15 players, and you can transfer(switch out) players at a rate of 1 per gameweek. Ultimately, the goal is to get the most points for your money.

In this project, I use my skills as a data analyst to set up a database in sqlite and run queries to determine the best fpl picks based on the data from the current Premier League season.

## How I Set This Up

### Dataset 1 - FPL PLayer Data

<p>I started by downloading a dataset on kaggle with fpl specific data for the first 15 games of the current PL season. </p>

[Data downloaded from kaggle](https://www.kaggle.com/datasets/meraxes10/fantasy-premier-league-dataset-2024-2025)

Next, I cleaned the data using pandas in the `players.py` file.

After, I got the data looking the way I wanted, I created the `fpl_picks.db` file, connecting the cleaned players dataset to the db as a table.

Then, I used the sqlite extension in vs code to write and run queries on my `fpl_picks.db` file.

### Dataset 2 - EPL Statistics Data

Using [this dataset](https://datahub.io/core/english-premier-league#season-2425), I completed the same steps above, creating an epl_stats table in my `fpl_picks.db`.

I was then able to get team data for home and away specific stats.


### Created An API to Connect My Database to Tableau Public





### - Set Up Dashboard




