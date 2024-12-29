# fpl-project

<p>Fantasy Premier League (FPL) is a fantasy sports game based on the English Premiere League season.</p> 

<p>As a basic overview of the game, you pick players to be on your team and (hopefully) score your team points. Unlike American fantasy football, FPL allows you to pick whichever players you want, meaning you can have the same players as other teams. However, each player is given a price, and you are given a €100 million budget to spend on 15 players at the beginning of the season. Each week you start 11 of your 15 players, and you can transfer(switch out) players at a rate of 1 per gameweek. Ultimately, the goal is to get the most points for your money.</p>

<p>In this project, I use my skills as a data analyst to set up a database in sqlite and run queries to determine the best fpl picks based on the data from the current Premier League season.</p>

<h3>How It Works</h3>

<p>I started by downloading a dataset on kaggle with fpl relevant data for the first 15 games of the current PL season. </p>

<p><a href="https://www.kaggle.com/datasets/meraxes10/fantasy-premier-league-dataset-2024-2025">Data downloaded from kaggle</a></p>

<p>Next, I cleaned the data using pandas in the <code>players.py</code> file.</p>

<p>After, I got the data looking the way I wanted, I created the <code>players.db</code> file.</p>

<p>Then, I used the sqlite extension in vs code to write and run queries on my <code>players.db</code> file.</p>
