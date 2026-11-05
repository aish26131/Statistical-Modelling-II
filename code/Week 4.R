#Week 4 - Binomial regression

#read in data
players<-read.csv("league_players.csv",header=T)

#choose a binary response: injured (0 = not injured, 1 = injured)
#use training_load as the explanatory variable and remove missing values in the variables used in the model
players<-players[complete.cases(players[,c("injured","training_load")]),]
stopifnot(all(players$injured %in% c(0,1)))

#produce summary statistics
summary(players[,c("injured","training_load")])
table(players$injured)
mean(players$injured)

#calculate the observed injury proportion at each training level
injury_rate<-aggregate(injured ~ training_load, data = players, FUN = mean)
injury_rate

#fit a binomial model using the logit link log(p/(1-p)) = beta0 + beta1 * training_load
#training_load is treated as numeric: each one-level increase has the same effect on log odds
model <- glm(injured ~ training_load,
             family = binomial(link = "logit"), data = players)

#summary of binomial model
summary(model)

#calculate odds ratios and 95% Wald confidence intervals the training_load odds ratio describes a one-level increase in training load an odds ratio is not a probability ratio
odds_ratio <- exp(coef(model))
se <- sqrt(diag(vcov(model)))
lower <- exp(coef(model) - 1.96 * se)
upper <- exp(coef(model) + 1.96 * se)
results <- data.frame(odds_ratio, lower, upper)
results

#compare the model with an intercept-only model
null_model <- glm(injured ~ 1,
                  family = binomial(link = "logit"), data = players)
anova(null_model, model, test = "Chisq")

#predict injury probabilities for training levels 1 to 5
new_players <- data.frame(training_load = 1:5)
prediction <- predict(model, newdata = new_players,
                      type = "link", se.fit = TRUE)
new_players$probability <- plogis(prediction$fit)
new_players$lower <- plogis(prediction$fit - 1.96 * prediction$se.fit)
new_players$upper <- plogis(prediction$fit + 1.96 * prediction$se.fit)
new_players

#plot observed injury proportions and fitted probabilities
plot(injury_rate$training_load, injury_rate$injured,
     xlab = "Training Load",
     ylab = "Probability of Injury",
     main = "Injury Probability vs Training Load",
     pch = 16,
     ylim = c(0, 1),
     xaxt = "n")
axis(1, at = 1:5)
lines(new_players$training_load, new_players$probability,
      col = "red", lwd = 2)
lines(new_players$training_load, new_players$lower,
      col = "red", lty = 2)
lines(new_players$training_load, new_players$upper,
      col = "red", lty = 2)
legend("topleft",
       legend = c("Observed proportion", "Fitted probability", "95% confidence interval"),
       col = c("black", "red", "red"),
       pch = c(16, NA, NA), lty = c(NA, 1, 2), bty = "n")
