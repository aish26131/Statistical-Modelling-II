# Question 2: How does Ashford's scoring rate differ between home and away?
# Poisson regression for goals per match, adjusted for final opponent rank.
# Run from the repository root. Base R only.
# Rscript code/q2_home_away_scoring.R "path/to/ashford_matches.csv"
# In RStudio: keep the CSV in the root and source("code/q2_home_away_scoring.R").
# Read in the match data and set Away as the reference category
args <- commandArgs(trailingOnly = TRUE)
candidates <- c("ashford_matches.csv", "ashford_matches(1).csv")
path <- if (length(args)) args[1] else candidates[file.exists(candidates)][1]
if (is.na(path) || !file.exists(path)) stop("Supply the course match CSV path.")
matches <- read.csv(path)
matches$home_away <- factor(matches$home_away, levels = c("Away", "Home"))
required <- c("home_away", "goals_scored", "goals_conceded", "opponent_rank")
stopifnot(all(required %in% names(matches)), !anyNA(matches[required]),
          nrow(matches) == 46, all(table(matches$opponent_rank, matches$home_away) == 1))

# Exploratory analysis: scoring totals and means by venue
print(aggregate(goals_scored ~ home_away, matches,
                function(x) c(matches = length(x), total = sum(x), mean = mean(x))))

# Extend the group's Week 6 Poisson analysis: test venue after adjusting for rank.
rank_only <- glm(goals_scored ~ opponent_rank, family = poisson, data = matches)
additive <- update(rank_only, . ~ . + home_away)
interaction <- update(additive, . ~ . + home_away:opponent_rank)
model_tests <- anova(rank_only, additive, interaction, test = "Chisq")
print(model_tests)
print(AIC(rank_only, additive, interaction))
# Model diagnostics: dispersion and the most influential fixture
print(c(Pearson_dispersion = sum(residuals(additive, type = "pearson")^2) /
          df.residual(additive)))

# Remove both matches against the most influential fixture's opponent.
influential <- matches[which.max(cooks.distance(additive)), ]
print(influential)
sensitivity <- update(additive, data = subset(matches, opponent_rank != influential$opponent_rank))
# Rate ratios with 95% Wald confidence intervals
rate_ratios <- function(model, sample_label) {
  terms <- c("home_awayHome", "opponent_rank")
  limits <- exp(confint.default(model, parm = terms))
  data.frame(sample = sample_label, matches = nobs(model), term = terms,
             rate_ratio = unname(exp(coef(model)[terms])),
             lower_95 = limits[, 1], upper_95 = limits[, 2], row.names = NULL)
}
results <- rbind(rate_ratios(additive, "Full season"),
                 rate_ratios(sensitivity, "Excluding rank 24 pair"))
print(results)

# Compare home and away fixtures against each opponent
pairs <- reshape(matches[c("opponent_rank", "home_away", "goals_scored")],
                 idvar = "opponent_rank", timevar = "home_away", direction = "wide")
delta <- with(pairs, goals_scored.Home - goals_scored.Away)
print(c(higher_at_home = sum(delta > 0), equal = sum(delta == 0),
        lower_at_home = sum(delta < 0)))

# Save question 2 outputs
dir.create("outputs", showWarnings = FALSE)
write.csv(results, "outputs/q2_scoring_rate_ratios.csv", row.names = FALSE)
selection <- data.frame(model = c("Rank only", "Rank + venue", "Rank * venue"),
                        AIC = AIC(rank_only, additive, interaction)$AIC,
                        LR_chisq = model_tests$Deviance,
                        df_added = model_tests$Df,
                        p_value = model_tests[["Pr(>Chi)"]])
write.csv(selection, "outputs/q2_scoring_model_selection.csv", row.names = FALSE)
png("outputs/q2_home_away_paired_goals.png", width = 1600, height = 1200, res = 180)
par(mar = c(4.5, 4.5, 3, 1))
plot(pairs$opponent_rank, delta, type = "n", ylim = c(-2.35, 5.55),
     main = "Home and away scoring against the same opponent",
     xlab = "Opponent's final league position (1 = highest)",
     ylab = "Home goals minus away goals", las = 1, xaxt = "n", bty = "l")
axis(1, at = c(1, 5, 10, 15, 20, 24))
abline(h = 0, col = "grey65")
segments(pairs$opponent_rank, 0, pairs$opponent_rank, delta, col = "grey70", lwd = 2)
points(pairs$opponent_rank, delta, pch = 19, cex = 1.1)
text(24, 5, "8 at home, 3 away", pos = 2, cex = 0.78)
invisible(dev.off())
