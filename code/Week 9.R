#read in data
matches<-read.csv("ashford_matches.csv",header=T)
matches$home_away<-factor(matches$home_away)
library(MASS)
library(nnet)
library(survival)

#create ordered match result (Loss < Draw < Win)
gd <- matches$goals_scored - matches$goals_conceded
matches$result <- factor(ifelse(gd < 0, "Loss", ifelse(gd == 0, "Draw", "Win")),
                         levels = c("Loss", "Draw", "Win"), ordered = TRUE)
matches$win <- as.integer(matches$result == "Win")
table(matches$home_away, matches$result)

#proportional odds model for match result
#positive coefficient = shift towards better results
po_model <- polr(result ~ home_away + opponent_rank, data = matches, Hess = TRUE)
summary(po_model)

#likelihood ratio test for each term
drop1(po_model, test = "Chisq")

#check interaction between venue and opponent rank
po_int <- polr(result ~ home_away * opponent_rank, data = matches, Hess = TRUE)
anova(po_model, po_int)

#odds ratios with 95% profile likelihood confidence intervals
po_or <- exp(cbind(odds_ratio = coef(po_model), confint(po_model)))
po_or

#check proportional odds assumption: compare with multinomial model (LRT)
mn_model <- multinom(result ~ home_away + opponent_rank, data = matches, trace = FALSE)
LR <- deviance(po_model) - deviance(mn_model)
df_po <- length(coef(mn_model)) - (length(coef(po_model)) + length(po_model$zeta))
c(LR = LR, df = df_po, p.value = 1 - pchisq(LR, df_po))

#matched pairs: each opponent played once at home and once away
home <- matches[matches$home_away == "Home", ]
away <- matches[matches$home_away == "Away", ]
home <- home[order(home$opponent_rank), ]
away <- away[order(away$opponent_rank), ]
pair_tab <- table(Home = factor(home$win, levels = c(1, 0), labels = c("Win", "No win")),
                  Away = factor(away$win, levels = c(1, 0), labels = c("Win", "No win")))
pair_tab

#McNemar test and exact binomial test on discordant pairs
mcnemar.test(pair_tab)
binom.test(pair_tab["Win", "No win"],
           pair_tab["Win", "No win"] + pair_tab["No win", "Win"])

#conditional logistic regression (each opponent is a stratum)
matches$home <- as.integer(matches$home_away == "Home")
cl_model <- clogit(win ~ home + strata(opponent_rank), method = "exact", data = matches)
summary(cl_model)

#save week 9 outputs
write.csv(round(po_or, 3), "week9_result_po_odds_ratios.csv")
write.csv(as.data.frame.matrix(pair_tab), "week9_home_away_pairs.csv")
write.csv(round(summary(cl_model)$conf.int, 3), "week9_clogit_odds_ratio.csv")

#plot of fitted probability of winning by opponent rank, home vs away
png("week9_win_probability.png", width = 800, height = 600)
grid <- expand.grid(opponent_rank = 1:24, home_away = c("Home", "Away"))
pr <- predict(po_model, grid, type = "probs")
plot(1:24, pr[grid$home_away == "Home", "Win"], type = "l", lwd = 2,
     ylim = c(0, 1), xlab = "Opponent league rank (1 = strongest)",
     ylab = "Fitted probability of winning",
     main = "Proportional odds model: P(win) home vs away")
lines(1:24, pr[grid$home_away == "Away", "Win"], lwd = 2, lty = 2)
legend("topleft", c("Home", "Away"), lty = c(1, 2), lwd = 2)
dev.off()
