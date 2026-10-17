#read in data
players<-read.csv("league_players.csv",header=T)
matches<-read.csv("ashford_matches.csv",header=T)
#produce summary statistics
summary(players)
summary(matches)
#produce scatter plot using ashford_matches
plot(matches$opponent_rank, matches$goals_scored,
     xlab = "Opponent Rank",
     ylab = "Goals Scored",
     main = "Goals Scored vs Opponent Rank")
#produce histogram using league_players
hist(players$bmi,
     main = "Distribution of Player BMI",
     xlab = "BMI",
     ylab = "Frequency",
     col = "lightgreen",
     border = "black",
     ylim = c(0, 150))
#classify each variable by type
str(players)
str(matches)
# fit linear model
model <- lm(goals_scored ~ opponent_rank, data = matches)
# summary of linear model
summary(model)
# Try a linear model
plot(matches$opponent_rank, matches$goals_scored,
     xlab = "Opponent Rank",
     ylab = "Goals Scored",
     main = "Goals Scored vs Opponent Rank",
     pch = 16)
abline(model, col = "red", lwd = 2)
