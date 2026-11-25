Lily Week 3: Week 3 logistic regression. Extended Week 4’s injury model to all player variables, selected the model by LRT, checked an interaction, and fitted a logistic model for Ashford wins. Uploaded code (code/Week 3.R) and outputs (4 files in outputs/). Drafted with Claude, then run, debugged and checked myself.


Lily Week 9: proportional odds model for Loss/Draw/Win: home OR 5.3 (1.6–19.1), opponent rank OR 1.13 per place; PO assumption not rejected (LRT p = 0.42). Matched-pairs analysis: 11 vs 3 discordant pairs, conditional OR 3.67 (1.02–13.1), exact test p = 0.057, so borderline. Bradley–Terry not applicable (only Ashford’s matches).

**FINAL PROJECT**

**Aishvini Analysis 1: Player Injury Risk — Analytical Decisions Log**

Research question: To what extent do age, training load and previous injuries explain player injury risk, and does accounting for differences between football clubs improve the model?

1. Choice of research question

We selected player injury risk because understanding the characteristics associated with injuries has practical relevance for football clubs, particularly in relation to player welfare, training management and injury prevention.

2. Data preparation and exploratory analysis

We examined the dataset containing 620 players across 24 football clubs. No missing values were identified, so no observations were excluded during data preparation.

Exploratory analysis revealed differences in age, previous injuries and injury proportions across training load levels. These findings motivated further investigation using regression modelling.

3. Choice of statistical model

We selected a generalised linear model with a binomial response distribution and logit link because injury status is binary.

We also considered a mixed-effects logistic regression model with a club-level random intercept because players belonging to the same club may share characteristics or training environments.

4. Model selection

We fitted candidate models incorporating age, training load, previous injuries and playing position. Models were compared using AIC, BIC and likelihood ratio tests.

We retained age, training load and previous injuries because they contributed to model fit. Playing position was excluded because its inclusion increased AIC and BIC and did not provide a statistically significant improvement in fit (p = 0.433).

5. Representation of training load

We compared treating training load as a numerical predictor with treating it as a categorical predictor.

The categorical representation did not significantly improve model fit (p = 0.242) and increased both AIC and BIC. We therefore retained the numerical representation for parsimony, recognising that this assumes a constant change in log-odds between successive training load levels.

6. Assessment of nonlinearity

We investigated quadratic terms for age and previous injuries to assess whether their relationships with injury log-odds departed from linearity.

Neither quadratic term provided a statistically significant improvement in model fit (p = 0.400 and p = 0.496, respectively). Consequently, we retained the simpler linear terms.

7. Assessment of interaction effects

We investigated an interaction between training load and previous injuries because the association between training load and injury risk may differ according to a player's injury history.

Although the interaction model produced a marginally lower AIC (546.84 compared with 547.27), BIC favoured the main-effects model, and the likelihood ratio test was not statistically significant (p = 0.119).

We therefore retained the main-effects model on grounds of parsimony and interpretability.

8. Assessment of club-level variation

We fitted a mixed-effects logistic regression model incorporating a random intercept for football club.

The model produced a singular fit, with an estimated random-intercept variance of zero. Furthermore, its AIC was higher than that of the standard logistic regression model (549.27 compared with 547.27).

We therefore retained standard logistic regression because the data did not provide sufficient evidence that accounting for additional club-level variation improved model fit.

9. Model diagnostics and goodness of fit

The final model significantly improved upon the null model (χ²(3) = 55.44, p < 0.001). However, improvement relative to the null model does not establish adequate absolute model fit.

We assessed model adequacy using Pearson residuals, Cook’s distance, calibration, the Pearson dispersion statistic and McFadden’s pseudo-R².

The Pearson dispersion statistic was 1.065. Following the lecturer’s GLM guidance, this statistic was interpreted cautiously given the ungrouped binary response. Imperfect calibration and a McFadden’s pseudo-R² of 0.093 highlighted limitations in model performance. In the highest predicted-risk group, the observed injury proportion was 54.8%, compared with a predicted probability of 46.4%.

We assessed leverage using the lecturer’s recommended threshold of 2p/n = 0.01290. This identified 54 high-leverage observations (8.7% of the dataset). Only one observation exceeded both the leverage and the lecturer’s Cook’s distance thresholds, demonstrating that high leverage does not necessarily imply high influence.

We additionally examined standardised deviance residuals against fitted probabilities and a normal Q-Q plot. The residuals formed two distinct bands, consistent with the binary response. Departures from normality were interpreted cautiously because normally distributed residuals are not an assumption of binary logistic regression.

Of the 620 observations, 26 (4.2%) had absolute standardised deviance residuals exceeding two, while none exceeded three. These screening thresholds were interpreted cautiously given the binary response. Combined with the leverage, influence and calibration assessments, these findings did not provide sufficient justification for changing the final model or excluding observations. Nevertheless, imperfect calibration and sensitivity of effect sizes were acknowledged as limitations.

10. Sensitivity analysis

We initially applied the Cook’s distance threshold of 4/n = 0.00645, identifying 51 potentially influential observations.

Following the lecturer’s GLM guidance, we additionally applied the threshold of 8/(n − 2p) = 0.01307, identifying 11 potentially influential observations.

We refitted the model separately after excluding the observations identified by each threshold.

Predictor

Original OR

Excluding 11

Excluding 51

Age

1.111

1.168

1.268

Training load

1.377

1.624

2.494

Previous injuries

1.667

1.887

2.754

All associations remained positive and statistically significant, although their estimated magnitudes increased following exclusion.

Comparing both thresholds demonstrated robustness in the direction of associations but sensitivity in their magnitudes.

We retained all 620 observations in the primary analysis because influential observations are not necessarily erroneous, and their exclusion could introduce bias. AIC values from the sensitivity models were not directly compared with those from the primary model because they were fitted to different datasets.

11. Presentation and interpretation of results

We decided to present adjusted odds ratios with 95% Wald confidence intervals rather than relying solely on regression coefficients and p-values. This improves interpretability for a non-specialist audience and communicates uncertainty.

We prioritised the results table in the main report because of the four-page limit. Exploratory and diagnostic plots are intended for inclusion in the shared workspace as supporting evidence.

12. Final model and limitations

Our final model is a binary logistic regression model containing age, numerical training load and previous injuries.

All three predictors were positively associated with injury odds. Accounting for additional club-level variation did not improve model fit.

We acknowledge that the estimated associations are sensitive in magnitude to the exclusion of influential observations, calibration is imperfect, and predictive performance has not been independently validated. Furthermore, the analysis does not establish causal relationships.

These limitations were incorporated into the report to ensure that the conclusions remain proportionate to the statistical evidence.
