# Week 6 - Poisson Regression

# 1. Import the dataset
matches <- read.csv("ashford_matches.csv")

# Inspect the data
head(matches)
str(matches)
summary(matches)
colSums(is.na(matches))


# 2. Prepare the variables
names(matches)

# Convert home/away into a categorical variable
matches$home_away <- factor(matches$home_away)

# Set Away as the reference category
matches$home_away <- relevel(matches$home_away, ref = "Away")


# 3. Exploratory data analysis

# Distribution of goals scored
table(matches$goals_scored)

barplot(table(matches$goals_scored),
        main = "Distribution of goals scored",
        xlab = "Goals scored",
        ylab = "Number of matches",
        col = "lightblue")

# Mean and variance of goals scored
mean(matches$goals_scored)
var(matches$goals_scored)

# Mean goals by home/away
aggregate(goals_scored ~ home_away,
          data = matches, FUN = mean)

# Goals scored against opponent rank
plot(matches$opponent_rank, matches$goals_scored,
     xlab = "Opponent league rank",
     ylab = "Goals scored",
     main = "Goals scored vs opponent rank",
     pch = 19)


# 4. Fit Poisson regression models

# Null model
model0 <- glm(goals_scored ~ 1,
              family = poisson(link = "log"),
              data = matches)

# Model with home/away
model1 <- glm(goals_scored ~ home_away,
              family = poisson(link = "log"),
              data = matches)

# Model with home/away and opponent rank
model2 <- glm(goals_scored ~ home_away + opponent_rank,
              family = poisson(link = "log"),
              data = matches)

# Model including interaction
model3 <- glm(goals_scored ~ home_away * opponent_rank,
              family = poisson(link = "log"),
              data = matches)


# 5. Compare the models

anova(model0, model1, model2, model3,
      test = "Chisq")

AIC(model0, model1, model2, model3)


# 6. Examine the additive model
summary(model2)

# Exponentiate coefficients
exp(coef(model2))

# 95% confidence intervals for rate ratios
exp(confint.default(model2))


# 7. Check for overdispersion

dispersion <- sum(residuals(model2, type = "pearson")^2) /
  df.residual(model2)

dispersion


# 8. Model diagnostics

# Deviance residuals vs fitted values
plot(fitted(model2),
     residuals(model2, type = "deviance"),
     xlab = "Fitted values",
     ylab = "Deviance residuals",
     main = "Residuals vs fitted values",
     pch = 19)

abline(h = 0, col = "red", lty = 2)

# Observed vs predicted goals
plot(fitted(model2), matches$goals_scored,
     xlab = "Predicted goals",
     ylab = "Observed goals",
     main = "Observed vs predicted goals",
     pch = 19)

abline(0, 1, col = "red", lty = 2)


# 9. Goodness-of-fit test

1 - pchisq(deviance(model2),
           df.residual(model2))
