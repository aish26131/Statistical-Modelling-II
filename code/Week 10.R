# Week 10 - Hierarchical Models

# 1. Install required packages
if (!requireNamespace("rlang", quietly = TRUE)) {
  install.packages("rlang")
}

if (!requireNamespace("lme4", quietly = TRUE)) {
  install.packages("lme4")
}

# Load package
library(lme4)


# 2. Import dataset
players <- read.csv("league_players.csv")

# Inspect data
head(players)
names(players)
str(players)
summary(players)
colSums(is.na(players))


# 3. Prepare variables
players$team <- factor(players$team)
players$position <- factor(players$position)

players$injured <- as.numeric(
  as.character(players$injured)
)

# Check outcome and grouping
table(players$injured)
table(players$team)

# Check variable types
str(players)


# 4. Explore injury rates between clubs

injury_rates <- aggregate(
  injured ~ team,
  data = players,
  FUN = mean
)

print(injury_rates)

barplot(
  injury_rates$injured,
  names.arg = injury_rates$team,
  las = 2,
  cex.names = 0.6,
  main = "Injury proportion by club",
  ylab = "Proportion injured",
  col = "lightblue"
)


# 5. Standard logistic regression

logistic_model <- glm(
  injured ~ age + training_load +
    prev_injuries + position,
  family = binomial(link = "logit"),
  data = players
)

summary(logistic_model)


# 6. Mixed-effects logistic regression

mixed_model <- glmer(
  injured ~ age + training_load +
    prev_injuries + position + (1 | team),
  family = binomial(link = "logit"),
  data = players,
  control = glmerControl(
    optimizer = "bobyqa"
  )
)

summary(mixed_model)


# 7. Compare models

AIC(logistic_model, mixed_model)

BIC(logistic_model, mixed_model)

anova(logistic_model, mixed_model,
      test = "Chisq")


# 8. Examine random effects

VarCorr(mixed_model)

ranef(mixed_model)

isSingular(mixed_model)


# 9. Interpret fixed effects

exp(fixef(mixed_model))

exp(confint(
  mixed_model,
  parm = "beta_",
  method = "Wald"
))


# 10. Model diagnostics

pearson_res <- residuals(
  mixed_model,
  type = "pearson"
)

fitted_probs <- fitted(mixed_model)

plot(
  fitted_probs,
  pearson_res,
  xlab = "Fitted injury probability",
  ylab = "Pearson residuals",
  main = "Mixed model diagnostics",
  pch = 19
)

abline(h = 0, col = "red", lty = 2)


# 11. Compare observed and predicted
# injury proportions by club

players$predicted_injury <- fitted(mixed_model)

club_predictions <- aggregate(
  cbind(injured, predicted_injury) ~ team,
  data = players,
  FUN = mean
)

print(club_predictions)

plot(
  club_predictions$injured,
  club_predictions$predicted_injury,
  xlab = "Observed injury proportion",
  ylab = "Predicted injury proportion",
  main = "Observed vs predicted by club",
  pch = 19
)

abline(0, 1, col = "red", lty = 2)

