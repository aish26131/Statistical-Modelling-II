## Question 2 – How does Ashford United's scoring rate differ between home and away after accounting for the opponent's final league position?

### Choice of research question and exploratory analysis

We chose this question because Ashford played each of its 23 opponents once at home and once away. The schedule therefore lets us compare scoring at the two venues against the same opposition. Ashford scored 40 goals in 23 home fixtures (1.74 per match) and 20 in 23 away fixtures (0.87 per match). To see how widely this difference was shared across opponents, we plotted home goals minus away goals for each pair. Ashford scored more at home against 13 opponents, the same against seven and fewer against three.

### Model selection

We built on the group's Week 6 Poisson regression. The response was Ashford's goal count in each match. We used away as the reference venue and treated final league position as numeric, with 1 denoting the highest-ranked team. Adding venue to the rank-only model improved fit (likelihood-ratio χ²(1) = 6.80, p = 0.009; AIC fell from 138.23 to 133.43).

We also considered whether the home advantage varied with opponent rank. Adding the venue × rank interaction increased AIC to 135.07 and gave little improvement in fit (χ²(1) = 0.36, p = 0.548). We therefore retained the additive model and report a common home-to-away rate ratio across ranks.

### Model diagnostics and sensitivity analysis

The Pearson dispersion estimate was 0.99, close to the value of one expected under the Poisson model. Cook's distance identified the 8–0 home win against the bottom-ranked club as the most influential fixture. We retained this match in the primary analysis. For the sensitivity check, we removed both fixtures against that club so that every remaining opponent still contributed one match at each venue.

| Predictor | All 46 matches, rate ratio (95% CI) | Excluding both fixtures against the bottom-ranked club, rate ratio (95% CI) |
|---|---:|---:|
| Home versus away | 2.00 (1.17–3.42) | 1.88 (1.05–3.39) |
| Opponent one place lower in the final table | 1.056 (1.016–1.097) | 1.025 (0.983–1.069) |

### Presentation, interpretation and limitations

We report rate ratios with 95% Wald confidence intervals so that the estimates can be read as differences in expected goals per match. After accounting for rank, Ashford's estimated scoring rate was twice as high at home. Removing the bottom-ranked opponent reduced this estimate to 1.88, although the interval remained wide. The rank association was more sensitive: the estimated increase in scoring per place lower in the table fell from 5.6% to 2.5%, and its interval then included no change.

The analysis covers one club in one season. Treating rank as numeric assumes the same proportional change in expected goals for each one-place difference. Final rank summarises the entire season, so we interpret it retrospectively. The data describe an association between venue and scoring; they cannot establish how much of the difference was caused by playing at home.

## Appendix – R code for Question 2

Run the following code from the repository root with the course match CSV in the working directory. The script prints the model results and saves the paired-goals figure and two results tables in `outputs/`.

```r
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
```

