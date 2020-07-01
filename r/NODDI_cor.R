rm(list= ls())
options(scipen=999) # gets rid of scientific notation

# http://www.sthda.com/english/wiki/correlation-matrix-a-quick-start-guide-to-analyze-format-and-visualize-a-correlation-matrix-using-r-software

# Packages
if (!require("Hmisc")) {
  install.packages("Hmisc")
  library(Hmisc)
}

library(ggplot2)

if (!require("corrplot")) {
  install.packages("corrplot")
  library(corrplot)
}


install.packages("PerformanceAnalytics")
library(PerformanceAnalytics)
library(psych) # good for describeBy command

df.metrics <- read.csv('~/Dropbox/TBI Team Folder/TBI_NODDI/r_analysis/dataframes/wholeBrain_skeleton.csv')
df.psych <- read.csv('~/Dropbox/TBI Team Folder/TBI_NODDI/r_analysis/dataframes/neuropsych.csv')

#
cor(df.metrics, method = "pearson", use = "complete.obs")
# Pearson correlation coefficient measures the linear dependence between two variables. kendall and spearman correlation methods are non-parametric rank-based correlation test.

my_data <- df.metrics[, c(1,2,3)]
head(my_data, 6)
chart.Correlation(my_data, histogram=TRUE, pch=19)

res <- cor(my_data)


my_data <- df.metrics[, c(3,4,5,6,7,8)]
head(my_data, 6)
res <- cor(my_data)
round(res, 2)


res2 <- rcorr(as.matrix(my_data))
res2

# function called at bottom
flattenCorrMatrix(res2$r, res2$P)


# Insignificant correlations are leaved blank
corrplot(res2$r, type="upper", order="hclust", 
         p.mat = res2$bon_P, sig.level = 0.01, insig = "blank")

# ~~~
# Plots for the voxelwise correlation with neuropsych measures
# ~~~
p_Trails <- ggplot(df.psych, aes(color= Group, df.psych$TMBminusA, df.psych$mask_TrailsBminusA_tstat2), na.omit=TRUE)
p_Trails  + geom_point(shape=1) + # shape 1 just makes hollow dots
  geom_smooth(method=lm) + # geom_smooth creates a line; method=linear model  
  theme(text = element_text(size = 42)) 


p_LM1 <- ggplot(df.psych, aes(color= Group, df.psych$LM1Total, df.psych$mask_LM1_tstat1), na.omit=TRUE)
p_LM1  + geom_point(shape=1) + # shape 1 just makes hollow dots
  geom_smooth(method=lm) + # geom_smooth creates a line; method=linear model  
  theme(text = element_text(size = 42)) 

p_LM2 <- ggplot(df.psych, aes(color= Group, df.psych$LM2Total, df.psych$mask_LM2_tstat1), na.omit=TRUE)
p_LM2  + geom_point(shape=1) + # shape 1 just makes hollow dots
  geom_smooth(method=lm) + # geom_smooth creates a line; method=linear model  
  theme(text = element_text(size = 42)) 

p_Inhib <- ggplot(df.psych, aes(color= Group, df.psych$StroopInhibTime, df.psych$mask_StroopInhib_tstat2), na.omit=TRUE)
p_Inhib  + geom_point(shape=1) + # shape 1 just makes hollow dots
  geom_smooth(method=lm) + # geom_smooth creates a line; method=linear model  
  theme(text = element_text(size = 42)) 

p_combi <- ggplot(df.psych, aes(color= Group, df.psych$StroopCombiBaseline, df.psych$mask_CombiBaseline_tstat2), na.omit=TRUE)
p_combi  + geom_point(shape=1) + # shape 1 just makes hollow dots
  geom_smooth(method=lm) + # geom_smooth creates a line; method=linear model  
  theme(text = element_text(size = 42)) 

# ++++++++++++++++++++++++++++
# flattenCorrMatrix
# ++++++++++++++++++++++++++++
# cormat : matrix of the correlation coefficients
# pmat : matrix of the correlation p-values
flattenCorrMatrix <- function(cormat, pmat) {
  ut <- upper.tri(cormat)
  data.frame(
    row = rownames(cormat)[row(cormat)[ut]],
    column = rownames(cormat)[col(cormat)[ut]],
    cor  =(cormat)[ut],
    p = pmat[ut]
  )
}

#  ++++++++++++
#  ggcorplot
# +++++++++++++

library(ggcorrplot)
# Correlation matrix
data(mtcars)
corr <- round(cor(my_data), 1)

# Plot
ggcorrplot(corr, hc.order = TRUE, 
           sig.level = 0.01,
           insig ="blank",
           type = "lower", 
           lab = TRUE, 
           lab_size = 8, 
           
           colors = c("royalblue2", "white", "firebrick2"), 
           title="Correlogram of Diffusion Metrics", 
           ggtheme=theme_bw) +
  theme(legend.text = element_text(size = 14)) +
  theme(text = element_text(size = 14))


cor(my_data$whole_brain_skeleton_icvf, my_data$whole_brain_skeleton_isovf)


cor(df.psych$whole_brain_skeleton_icvf, df.psych$MD)
cor(df.psych$whole_brain_skeleton_icvf, df.psych$TMBminusA)
cor(df.psych$MD, df.psych$TMBminusA)


lm_eqn <- function(df){
  m <- lm(y ~ x, df);
  eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
                   list(a = format(unname(coef(m)[1]), digits = 2),
                        b = format(unname(coef(m)[2]), digits = 2),
                        r2 = format(summary(m)$r.squared, digits = 3)))
  as.character(as.expression(eq));
}

p <- ggplot(my_data, aes( df.metrics$whole_brain_skeleton_md, df.metrics$whole_brain_skeleton_fa))
p + geom_point(shape=1) +
  geom_smooth(method=lm) +
  geom_text(x = df.metrics$whole_brain_skeleton_md, y = df.metrics$whole_brain_skeleton_fa, label = lm_eqn(df.metrics), parse = TRUE)

cor.test(df.metrics$whole_brain_skeleton_md , df.metrics$whole_brain_skeleton_fa)






p_Trails <- ggplot(df.psych, aes(color= Group, df.psych$TMBminusA, df.psych$whole_brain_skeleton_), na.omit=TRUE)
p_Trails  + geom_point(shape=1) + # shape 1 just makes hollow dots
  geom_smooth(method=lm) + # geom_smooth creates a line; method=linear model  
  theme(text = element_text(size = 42)) 


describeBy(df.psych$TMBminusA, df.psych$MD)
x <- aov(df.psych$TMBminusA, df.psych$MD)
summary(x)
TukeyHSD(x, conf.level = 0.95)

m2 <- with(df, lm(ContrastINHSWIvsCombiBase~as.factor(rad_report)+wholeBrainStats))
summary(m2)
anova(m1,m2)
m3 <- with(df, lm(ContrastINHSWIvsCombiBase~as.factor(rad_report)*wholeBrainStats))
summary(m3)
anova(m1,m3)


## Ploting correlation of WM ans skeleton

p <- ggplot(df.metrics, aes(color=Group, WM, whole_brain_skeleton_vbm))
p + geom_point()



Con_subset <- df.metrics[ which(df.metrics$Group=='Control'),]
Pat_subset <- df.metrics[ which(df.metrics$Group=='TBI'),]

cor(Con_subset$whole_brain_skeleton_vbm, Con_subset$WM)
cor(Pat_subset$whole_brain_skeleton_vbm, Pat_subset$WM)

plot(Pat_subset$WM, Pat_subset$whole_brain_skeleton_vbm)
