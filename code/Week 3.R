#read in data
players<-read.csv("league_players.csv",header=T)
matches<-read.csv("ashford_matches.csv",header=T)
players$position<-factor(players$position)

#extends Week 4 (injured ~ training_load) by adding the other player variables
#fit full logistic model with all predictors
full_model <- glm(injured ~ age + minutes_played + training_load +
                    prev_injuries + bmi + position,
                  family = binomial(link = "logit"), data = players)
summary(full_model)

#likelihood ratio test for each term (drop-in-deviance)
drop1(full_model, test = "Chisq")

#minutes_played, bmi and position not significant so fit reduced model
reduced_model <- glm(injured ~ age + training_load + prev_injuries,
                     family = binomial(link = "logit"), data = players)
summary(reduced_model)

#test whether the three dropped terms are needed (H0: reduced model adequate)
anova(reduced_model, full_model, test = "Chisq")

#check interaction: does the training_load effect differ by position?
int_model <- glm(injured ~ age + training_load * position + prev_injuries,
                 family = binomial(link = "logit"), data = players)
anova(reduced_model, int_model, test = "Chisq")

#odds ratios with 95% profile likelihood confidence intervals
exp(cbind(odds_ratio = coef(reduced_model), confint(reduced_model)))

#binary response for Ashford wins
matches$win <- as.integer(matches$goals_scored > matches$goals_conceded)
table(matches$home_away, matches$win)

#logistic model for wins using opponent rank and home/away
win_model <- glm(win ~ opponent_rank + home_away,
                 family = binomial(link = "logit"), data = matches)
summary(win_model)
drop1(win_model, test = "Chisq")
exp(cbind(odds_ratio = coef(win_model), confint(win_model)))

#save week 3 outputs
write.csv(drop1(full_model, test = "Chisq"), "week3_injury_drop1.csv")
write.csv(round(exp(cbind(odds_ratio = coef(reduced_model), confint(reduced_model))), 3),
          "week3_injury_odds_ratios.csv")
write.csv(round(exp(cbind(odds_ratio = coef(win_model), confint(win_model))), 3),
          "week3_win_odds_ratios.csv")

#plot of predicted injury probability by training load (age fixed at average)
png("week3_injury_probability.png", width = 800, height = 600)
new_players <- expand.grid(training_load = 1:5, prev_injuries = c(0, 2),
                           age = mean(players$age))
new_players$prob <- predict(reduced_model, new_players, type = "response")
plot(1:5, new_players$prob[new_players$prev_injuries == 0], type = "b", pch = 16,
     ylim = c(0, 1), xlab = "Training load",
     ylab = "Predicted probability of injury",
     main = "Predicted injury probability (average age)")
lines(1:5, new_players$prob[new_players$prev_injuries == 2], type = "b", lty = 2)
legend("topleft", c("0 previous injuries", "2 previous injuries"),
       lty = c(1, 2), pch = c(16, 1))
dev.off()
