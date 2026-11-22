# Week 11 - Accounting for grouped data

# Check both models exist
exists("logistic_model")
exists("mixed_model")

# Compare model fit
AIC(logistic_model, mixed_model)
BIC(logistic_model, mixed_model)

# Compare fixed-effect estimates
summary(logistic_model)
summary(mixed_model)

# Estimated between-club variance
VarCorr(mixed_model)

# Check singularity
isSingular(mixed_model)

# Compare coefficients and standard errors
comparison <- data.frame(
  Variable = names(coef(logistic_model)),
  Logistic_Estimate = coef(logistic_model),
  Mixed_Estimate = fixef(mixed_model),
  Logistic_SE = sqrt(diag(vcov(logistic_model))),
  Mixed_SE = sqrt(diag(vcov(mixed_model)))
)

print(comparison)
