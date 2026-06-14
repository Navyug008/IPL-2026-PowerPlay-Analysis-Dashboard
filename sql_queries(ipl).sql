-- Q1. Team-wise total auction spending
select team,sum(winning_bid_cr) as total_spend_Crore
from clean_auction
group by team
order by total_spend_Crore desc;

-- Q2. Top 10 most expensive players
select player,winning_bid_cr as max
from clean_auction
order by max desc
limit 10;

-- Q3. Team-wise average batting score
select team,avg(batting_average) as bs
from clean_batting
group by team
order by bs desc;

-- Q4. Top batsman by total runs
SELECT player, SUM(runs) AS total_runs
FROM clean_batting
GROUP BY player
ORDER BY total_runs DESC
LIMIT 10;

-- Q5. Top bowlers by wickets
select player,sum(wickets) as w
from clean_bowling
group by player
order by w desc
limit 10;

-- Q6. Player auction + batting performance
select a.player,a.team,a.winning_bid_cr,b.runs
from clean_auction a
join clean_batting b
on a.player = b.player;

-- Q7. Auction + bowling stats
SELECT 
    a.player,
    a.team,
    a.winning_bid_cr,
    b.wickets
FROM clean_auction a
JOIN clean_bowling b
ON a.player = b.player
order by a.winning_bid_cr desc;

-- Q8. Rank players by auction price
SELECT 
    player,
    team,
    winning_bid_cr,
    RANK() OVER (ORDER BY winning_bid_cr DESC) AS price_rank
FROM clean_auction;

-- Q9. Rank batsmen by runs
select player, sum(runs) as total_runs,
RANK() over (order by sum(runs) desc) as run_rank
from clean_batting
group by player;

-- Q10. Running total of team spending
SELECT 
    player,
    team,
    winning_bid_cr,
    SUM(winning_bid_cr) OVER (PARTITION BY team ORDER BY winning_bid_cr) AS running_spend
FROM clean_auction;

select * from clean_match_results;
select * from clean_auction;

-- Q11. Team win count
select winner, count(*) as Win
from clean_match_results
group by winner
order by Win desc;

-- Q12. Team's most expensive player
SELECT *
FROM
(
    SELECT player,
           team,
           winning_bid_cr,
           ROW_NUMBER() OVER
           (
               PARTITION BY team
               ORDER BY winning_bid_cr DESC
           ) rn
    FROM clean_auction
) x
WHERE rn = 1;

-- Q13 Which players contribute the most runs in their team?
SELECT player,
       team,
       SUM(runs) AS total_runs,
       RANK() OVER
       (
           PARTITION BY team
           ORDER BY SUM(runs) DESC
       ) AS team_rank
FROM clean_batting
GROUP BY player, team;

-- Q14 Top expensive players and their performance
SELECT
    a.player,
    a.team,
    a.winning_bid_cr,
    b.runs,
    bw.wickets
FROM clean_auction a
JOIN clean_batting b
    ON a.player = b.player
JOIN clean_bowling bw
    ON a.player = bw.player
ORDER BY a.winning_bid_cr DESC
LIMIT 10;