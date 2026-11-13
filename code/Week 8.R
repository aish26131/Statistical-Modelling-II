# Week 8 - Contingency Tables

# 1. Import the data
players <- read.csv("league_players.csv")

head(players)
str(players)
summary(players)
names(players)


# 2. Convert variables into factors
players$position <- factor(players$position,
                           levels = c("GK", "DEF", "MID", "FWD"))

players$injured <- factor(players$injured,
                          levels = c(0, 1),
                          labels = c("No", "Yes"))


# 3. Construct a contingency table
injury_table <- table(players$position, players$injured)

injury_table

injury_counts <- as.data.frame(injury_table)

names(injury_counts) <- c("position", "injured", "freq")

# Include row and column totals
addmargins(injury_table)

# Row percentages
round(prop.table(injury_table, margin = 1) * 100, 2)


# 4. Visualise the relationship
barplot(t(injury_table),
        beside = FALSE,
        legend.text = TRUE,
        col = c("lightblue", "salmon"),
        main = "Injury status by playing position",
        xlab = "Playing position",
        ylab = "Number of players")

# Proportional bar chart
barplot(t(prop.table(injury_table, margin = 1)),
        legend.text = TRUE,
        col = c("lightblue", "salmon"),
        main = "Proportion injured by position",
        xlab = "Playing position",
        ylab = "Proportion")


# 5. Chi-squared test of independence
chi_test <- chisq.test(injury_table)

chi_test

# Expected frequencies
chi_test$expected

# Pearson residuals
chi_test$residuals


# 6. Log-linear modelling
# Convert the contingency table into a data frame
injury_counts <- as.data.frame(injury_table)

names(injury_counts) <- c("position", "injured", "freq")

# Independence model
ind_model <- glm(freq ~ position + injured,
                 family = poisson(link = "log"),
                 data = injury_counts)

# Association model
assoc_model <- glm(freq ~ position * injured,
                   family = poisson(link = "log"),
                   data = injury_counts)

# Compare models
anova(ind_model, assoc_model, test = "Chisq")

# Examine model fit
summary(ind_model)
deviance(ind_model)
df.residual(ind_model)

# Expected counts under independence
fitted(ind_model)

# Model comparison
AIC(ind_model, assoc_model)
