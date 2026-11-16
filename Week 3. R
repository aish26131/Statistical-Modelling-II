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
