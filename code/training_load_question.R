#Question 3: What player characteristics are associated with training load?
#proportional odds model (training load 1-5 is an ordered response)

#read in data
players<-read.csv("league_players.csv",header=T)
players$position<-factor(players$position)
players$team<-factor(players$team)
library(MASS)
library(nnet)

#training load as an ordered response (1 < 2 < 3 < 4 < 5)
players$load<-factor(players$training_load, levels = 1:5, ordered = TRUE)
#minutes in thousands so odds ratios are easier to interpret
players$minutes_1000<-players$minutes_played/1000

#exploratory analysis
table(players$position, players$load)
round(prop.table(table(players$position, players$load), 1), 2)
par(mfrow = c(1, 2))
boxplot(minutes_played ~ training_load, data = players,
        xlab = "Training load", ylab = "Minutes played")
boxplot(age ~ training_load, data = players,
        xlab = "Training load", ylab = "Age")
par(mfrow = c(1, 1))

#full proportional odds model
#positive coefficient = higher training load
po_full <- polr(load ~ position + age + minutes_1000 + bmi + prev_injuries,
                data = players, Hess = TRUE)
summary(po_full)

#likelihood ratio test for each term
drop1(po_full, test = "Chisq")

#age, bmi and prev_injuries not significant so fit reduced model
po_red <- polr(load ~ position + minutes_1000, data = players, Hess = TRUE)
summary(po_red)

#test whether the three dropped terms are needed jointly (H0: reduced model adequate)
anova(po_red, po_full)
drop1(po_red, test = "Chisq")

#sensitivity check: does adding club (team) improve the reduced model?
po_red_team <- polr(load ~ position + minutes_1000 + team, data = players, Hess = TRUE)
anova(po_red, po_red_team)
AIC(po_red, po_red_team)

#check proportional odds assumption against multinomial model
mn_red <- multinom(load ~ position + minutes_1000, data = players, trace = FALSE)
LR <- deviance(po_red) - deviance(mn_red)
df_po <- length(coef(mn_red)) - (length(coef(po_red)) + length(po_red$zeta))
c(LR = LR, df = df_po, p.value = 1 - pchisq(LR, df_po))

#odds ratios with 95% profile likelihood confidence intervals
or_red <- exp(cbind(odds_ratio = coef(po_red), confint(po_red)))
or_red

#save question 3 outputs
write.csv(drop1(po_full, test = "Chisq"), "q3_training_load_drop1.csv")
write.csv(round(or_red, 3), "q3_training_load_odds_ratios.csv")
write.csv(anova(po_red, po_red_team), "q3_training_load_team_lrt.csv")

#plot of predicted probability of high training load (4 or 5) by minutes and position
png("q3_high_load_probability.png", width = 800, height = 600)
grid <- expand.grid(minutes_1000 = seq(0.1, 4, length.out = 50),
                    position = levels(players$position))
pr <- predict(po_red, grid, type = "probs")
grid$p_high <- pr[, "4"] + pr[, "5"]
plot(range(grid$minutes_1000), c(0, 1), type = "n",
     xlab = "Minutes played (thousands)",
     ylab = "Predicted probability of training load 4 or 5",
     main = "Predicted probability of high training load")
pos <- levels(players$position)
for (i in 1:4) {
  lines(grid$minutes_1000[grid$position == pos[i]],
        grid$p_high[grid$position == pos[i]], lty = i, lwd = 2)
}
legend("topleft", pos, lty = 1:4, lwd = 2)
dev.off()


