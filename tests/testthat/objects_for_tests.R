library(auditor)
library(car)
library(carData)
library(MASS)
library(DALEX2)
library(randomForest)
library(mlbench)
data("PimaIndiansDiabetes")
data("Prestige")
set.seed(71)
PimaIndiansDiabetes$diabetes <- ifelse(PimaIndiansDiabetes$diabetes == "pos", 1,0 )

model.lm <- lm(prestige~education + women + income, data = Prestige)
model.glm <- glm(Postwt ~ Prewt + Treat + offset(Prewt),
                 family = gaussian, data = anorexia)
model.rf <- randomForest::randomForest(Postwt ~ Prewt + Treat, data = anorexia)
model.class.glm <- glm(diabetes~., family=binomial,	data=PimaIndiansDiabetes)
model.class.rf <- randomForest(Species ~ ., data=iris, importance=TRUE,
                        proximity=TRUE)

model.class.glm2 <- glm(diabetes~pressure, family=binomial,	data=PimaIndiansDiabetes)
au.class.glm2 <- audit(model.class.glm2)

au.lm <- audit(model.lm, label = "lm")
au.glm <- audit(model.glm, label = "glm")
au.rf <- audit(model.rf, label="rf")
au.class.glm <- audit(model.class.glm, label="class glm")
au.class.rf <- audit(model.class.rf)

explainer_lm <- explain(model.lm, data = Prestige, y = Prestige$prestige)
au_expl_lm <- audit(explainer_lm)

cd.lm <- observationInfluence(au.lm)
mp.lm <- modelPerformance(au.lm)
mf.lm <- modelFit(au.lm)
glm_mr <- modelResiduals(au.glm, "Prewt")
rf_mr <- modelResiduals(au.rf, "Treat")
