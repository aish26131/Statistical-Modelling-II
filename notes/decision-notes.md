Lily Week 3: Week 3 logistic regression. Extended Week 4’s injury model to all player variables, selected the model by LRT, checked an interaction, and fitted a logistic model for Ashford wins. Uploaded code (code/Week 3.R) and outputs (4 files in outputs/). Drafted with Claude, then run, debugged and checked myself.


Lily Week 9: proportional odds model for Loss/Draw/Win: home OR 5.3 (1.6–19.1), opponent rank OR 1.13 per place; PO assumption not rejected (LRT p = 0.42). Matched-pairs analysis: 11 vs 3 discordant pairs, conditional OR 3.67 (1.02–13.1), exact test p = 0.057, so borderline. Bradley–Terry not applicable (only Ashford’s matches).

**FINAL PROJECT**
Aishvini Analysis 1: Player Injury Risk — Analytical Decisions Log

Research question: To what extent do age, training load and previous injuries explain player injury risk, and does accounting for differences between football clubs improve the model?

1. Choice of research question

We selected player injury risk because understanding the characteristics associated with injuries has practical relevance for football clubs, particularly in relation to player welfare, training management and injury prevention.

2. Data preparation and exploratory analysis

We examined the dataset containing 620 players across 24 football clubs. No missing values were identified, so no observations were excluded during data preparation.

Exploratory analysis revealed differences in age, previous injuries and injury proportions across training load levels. These findings motivated further investigation using regression modelling.

3. Choice of statistical model

We selected binary logistic regression with a logit link because the response variable, injury status, takes two possible values: injured or not injured.

We also considered a mixed-effects logistic regression model with a club-level random intercept because players belonging to the same club may share characteristics or training environments.

4. Model selection

We fitted candidate models incorporating age, training load, previous injuries and playing position. Models were compared using AIC, BIC and likelihood ratio tests.

We retained age, training load and previous injuries because they contributed to model fit. Playing position was excluded because its inclusion increased AIC and BIC and did not provide a statistically significant improvement in fit (p = 0.433).

5. Representation of training load

We compared treating training load as a numerical predictor with treating it as a categorical predictor.

The categorical representation did not significantly improve model fit (p = 0.242) and increased both AIC and BIC. We therefore retained the numerical representation for parsimony, recognising that this assumes a constant change in log-odds between successive training load levels.

6. Assessment of nonlinearity

We investigated quadratic terms for age and previous injuries to assess whether their relationships with injury log-odds departed from linearity.

Neither quadratic term provided a statistically significant improvement in model fit. Consequently, we retained the simpler linear terms.

7. Assessment of interaction effects

We investigated an interaction between training load and previous injuries because the association between training load and injury risk may differ according to a player's injury history.

Although the interaction model produced a marginally lower AIC (546.84 compared with 547.27), BIC favoured the main-effects model, and the likelihood ratio test was not statistically significant (p = 0.119).

We therefore retained the main-effects model on grounds of parsimony and interpretability.

8. Assessment of club-level variation

We fitted a mixed-effects logistic regression model incorporating a random intercept for football club.

The model produced a singular fit, with an estimated random-intercept variance of zero. Furthermore, its AIC was higher than that of the standard logistic regression model (549.27 compared with 547.27).

We therefore retained standard logistic regression because the data did not provide sufficient evidence that accounting for additional club-level variation improved model fit.

9. Model diagnostics and goodness of fit

We assessed model adequacy using Pearson residuals, Cook's distance, calibration, the Pearson dispersion statistic and McFadden's pseudo-R².

The Pearson dispersion statistic of 1.065 indicated no substantial overdispersion. However, imperfect calibration and a McFadden's pseudo-R² of 0.093 highlighted limitations in the model's explanatory and predictive performance.

We acknowledged these limitations rather than concluding that statistical significance alone demonstrated adequate model fit.

10. Sensitivity analysis

Cook's distance identified 51 potentially influential observations using the screening threshold of 4/n.

We refitted the model excluding these observations to investigate the robustness of our findings. Although all associations remained positive, the estimated effect sizes increased substantially.

We decided to retain all 620 observations in the primary analysis because influential observations are not necessarily erroneous, and their exclusion could introduce bias.

11. Presentation and interpretation of results

We decided to present adjusted odds ratios with 95% Wald confidence intervals rather than relying solely on regression coefficients and p-values. This improves interpretability for a non-specialist audience and communicates uncertainty.

We prioritised the results table in the main report because of the four-page limit. Exploratory and diagnostic plots are retained in the shared workspace as supporting evidence.

12. Final model and limitations

Our final model is a binary logistic regression model containing age, numerical training load and previous injuries.

We acknowledge that the estimated associations are sensitive in magnitude to the exclusion of influential observations, calibration is imperfect, and predictive performance has not been independently validated. Furthermore, the analysis does not establish causal relationships.

These limitations were incorporated into the report to ensure that the conclusions remain proportionate to the statistical evidence.
