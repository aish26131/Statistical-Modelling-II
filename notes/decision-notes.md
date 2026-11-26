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

We additionally explored training load and previous injury history jointly. At training load levels 2–5, injury proportions were consistently higher among players with previous injuries. The varying differences between groups motivated investigation of a training load–previous injuries interaction. Findings at training load level 1 were interpreted cautiously because of the small sample size.

3. Choice of statistical model

We selected a generalised linear model with a binomial response distribution and logit link because injury status is binary.

We also considered a mixed-effects logistic regression model with a club-level random intercept because players belonging to the same club may share characteristics or training environments.

4. Model selection

We fitted candidate models incorporating age, training load, previous injuries and playing position. Models were compared using AIC, BIC and likelihood ratio tests.

We retained age, training load and previous injuries because they contributed to model fit. Playing position was excluded because its inclusion increased AIC and BIC and did not provide a statistically significant improvement in fit (p = 0.433).

Nested models were compared using likelihood ratio tests (LRTs) at the 5% level, supplemented by AIC and BIC. Adjusted LRTs supported retaining age (χ²(1) = 13.53, p < 0.001), training load (χ²(1) = 8.59, p = 0.003) and previous injuries (χ²(1) = 31.48, p < 0.001). Playing position, categorical training load and quadratic terms provided insufficient improvement (all p > 0.05). Although a training load–previous injuries interaction marginally reduced AIC (ΔAIC = 0.43), the LRT (p = 0.119), BIC and parsimony favoured the main-effects model. The mixed-effects model produced a singular fit with zero estimated between-club variance and higher AIC (549.27 versus 547.27), supporting standard logistic regression.

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

Following the lecturer’s marking workshop guidance, we calculated fitted probabilities for hypothetical players aged 25 with one previous injury. Estimated injury probabilities were 11.9% and 26.0% at training load levels 2 and 5, respectively. This comparison was selected to communicate the training load association in practical terms while holding other predictors constant. These estimates are illustrative rather than causal predictions or independently validated risk assessments.

12. Final model and limitations

Our final model is a binary logistic regression model containing age, numerical training load and previous injuries.

All three predictors were positively associated with injury odds. Accounting for additional club-level variation did not improve model fit.

We acknowledge that the estimated associations are sensitive in magnitude to the exclusion of influential observations, calibration is imperfect, and predictive performance has not been independently validated. Furthermore, the analysis does not establish causal relationships.

These limitations were incorporated into the report to ensure that the conclusions remain proportionate to the statistical evidence.




Analysis 3: Player Training Load — Analytical Decisions Log

Research question: What player characteristics are associated with training load, and does accounting for differences between football clubs improve the model?

Choice of research question
We selected training load because it is under the club's control and, as Analysis 1 shows, is associated with injury risk. Understanding which player characteristics are associated with higher training load is therefore relevant to workload management and player welfare. The question also uses the player data with a different response and a different model type from Analysis 1 (logistic regression, injury) and Analysis 2 (Poisson regression, goals), so the report covers three model families.

Data preparation and exploratory analysis
We used the dataset of 620 players across 24 football clubs. No missing values were identified, so no observations were excluded.
Training load is recorded on an ordered 1–5 scale. The distribution is concentrated in the middle: 3.2% at level 1, 21.5% at level 2, 38.5% at level 3, 25.5% at level 4 and 11.3% at level 5.
Cross-tabulation by position showed that goalkeepers had the largest share of high training loads (48% at level 4 or 5, compared with 34% of defenders, 34% of forwards and 38% of midfielders). Boxplots suggested that players with higher training loads had played more minutes, while age showed little difference across load levels.
We rescaled minutes played to thousands of minutes so that odds ratios describe a practically meaningful change.

Choice of statistical model
We selected a proportional odds (cumulative logit) model because training load is an ordered categorical response.
We did not treat training load as a continuous response in a linear model, because the categories are ordered but not necessarily equally spaced, and the response is bounded with only five levels.
We considered a multinomial logistic model, which ignores the ordering and requires many more parameters. We used it as a comparison model to test the proportional odds assumption (see below).
In the proportional odds model, a positive coefficient indicates higher odds of being in a higher training load category.

Model selection
We fitted a full model containing playing position, age, minutes played, BMI and previous injuries. Terms were assessed using likelihood ratio tests (LRTs) at the 5% level, supplemented by AIC and BIC.
Single-term LRTs from the full model supported minutes played (χ²(1) = 34.08, p < 0.001) and playing position (χ²(3) = 11.52, p = 0.009). Age (p = 0.227), BMI (p = 0.283) and previous injuries (p = 0.156) did not provide a significant improvement.
Because dropping several terms at once can differ from dropping them one at a time, we tested removing age, BMI and previous injuries jointly. The joint LRT was not significant (χ²(3) = 4.74, p = 0.192), and AIC decreased from 1717.3 to 1716.1, supporting the reduced model.
In the reduced model, both remaining terms were required: minutes played (χ²(1) = 33.72, p < 0.001) and position (χ²(3) = 11.68, p = 0.009).

Assessment of nonlinearity
We added a quadratic term for minutes played to assess whether its relationship with the cumulative log-odds departed from linearity. It did not significantly improve fit (χ²(1) = 1.56, p = 0.212), so we retained the linear term.

Assessment of interaction effects
We investigated a position × minutes played interaction, because the association between minutes and training load could differ between positions (for example, for goalkeepers).
The interaction was not significant (χ²(3) = 3.72, p = 0.294) and increased both AIC (1718.4 versus 1716.1) and BIC (1767.1 versus 1751.5). We therefore retained the main-effects model.

Proportional odds assumption
We compared the proportional odds model with a multinomial model containing the same predictors using an LRT. There was no evidence against the proportional odds assumption for the full model (χ²(21) = 25.71, p = 0.218) or the final model (χ²(12) = 17.41, p = 0.135). This test has limited power, so the conclusion is that the data are consistent with the assumption rather than that it is proven.

Assessment of club-level variation
We assessed club in two ways.
Club as a fixed effect: adding club to the final model gave a borderline LRT (χ²(23) = 36.84, p = 0.034), but increased AIC (1725.2 versus 1716.1) and substantially increased BIC (1862.6 versus 1751.5), reflecting the 23 additional parameters.
Club as a random intercept (cumulative link mixed model, ordinal package): the estimated between-club variance was small (0.066, SD 0.26). AIC was almost identical to the model without club (1715.75 versus 1716.08), and the position and minutes estimates were essentially unchanged (for example, minutes coefficient 0.693 versus 0.701).
Because the evidence was mixed and accounting for club did not change the substantive conclusions, we retained the simpler proportional odds model without club. Club differences are reported as a limitation and sensitivity check.

Model diagnostics and goodness of fit
The final model significantly improved on the null model (χ²(4) = 39.80, p < 0.001). However, McFadden's pseudo-R² was low (0.023), indicating that position and minutes explain only a small part of the variation in training load.
Observed and predicted proportions in each training load category agreed closely overall (for example, 0.385 observed versus 0.385 predicted at level 3). We interpreted this cautiously, because the threshold parameters ensure close agreement for the overall distribution.
More informative calibration checks compared observed and predicted proportions with high training load (level 4 or 5) within subgroups:
- By minutes played (thirds): low 0.290 observed versus 0.271 predicted; medium 0.345 versus 0.364; high 0.469 versus 0.467.
- By position: defenders 0.338 versus 0.322; forwards 0.338 versus 0.379; goalkeepers 0.484 versus 0.466; midfielders 0.383 versus 0.378.
Calibration was good across minutes groups. The model slightly over-predicted high load for forwards, which we note as a limitation.

Sensitivity analysis
Ten players had played fewer than 1000 minutes (minimum 105), giving them potential leverage on the minutes effect. We refitted the final model excluding these players.

Predictor             Original OR   Excluding <1000 mins
Forward vs defender   1.967         1.960
Goalkeeper vs defender 1.207        1.254
Midfielder vs defender 1.586        1.602
Minutes (per 1000)    2.016         1.910

All estimates were very similar, and the direction and significance of associations were unchanged. We therefore retained all 620 observations in the primary analysis.

Presentation and interpretation of results
We present odds ratios with 95% profile-likelihood confidence intervals, which are more interpretable for a non-specialist audience than coefficients on the log-odds scale.
Final model odds ratios (95% CI):
- Minutes played, per additional 1000 minutes: 2.02 (1.59–2.56)
- Forwards versus defenders: 1.97 (1.30–2.98)
- Midfielders versus defenders: 1.59 (1.11–2.27)
- Goalkeepers versus defenders: 1.21 (0.70–2.07), no clear difference
Holding position fixed, playing an extra 1000 minutes is associated with roughly double the odds of being in a higher training load category.
To communicate this in practical terms, we calculated fitted probabilities of a high training load (level 4 or 5) for hypothetical players. At 2500 minutes, the estimated probability was 28.5% for a defender, 38.7% for a midfielder and 43.9% for a forward. For a defender, it rose from 16.5% at 1500 minutes to 44.6% at 3500 minutes. These estimates are illustrative, not causal predictions.
An interesting finding is that goalkeepers had the highest raw proportion of high training loads, but after accounting for minutes played they did not differ clearly from defenders. This is because goalkeepers in the data tend to play more minutes. Forwards had the highest odds of a high load once minutes were accounted for.
A plot of predicted probability of high training load against minutes played, by position, is included in the outputs folder.

Final model and limitations
Our final model is a proportional odds model for training load containing playing position and minutes played.
Limitations:
- The model explains little of the variation in training load (McFadden's pseudo-R² = 0.023), so other unmeasured factors are likely to matter.
- The associations are not causal. Minutes played and training load may both reflect a player's role in the squad, and the direction of the relationship cannot be established.
- There is some evidence of club differences (fixed-effect LRT p = 0.034), although they did not change the conclusions.
- The proportional odds test has limited power, and the model slightly over-predicts high load for forwards.
- Training load is recorded on a coarse 1–5 scale.
These limitations will be reflected in the report so that the conclusions remain proportionate to the evidence.


