
# Columns may have been accidently shifted in the old dataset. Here values have been re extracted from single shell data. Whole brain skeleton has also been included.


# Install dependencies ----
library(reshape2)
library(matrixStats)
library(ggplot2)
require(plotrix)
library(compute.es)

rm(list= ls()) # clear screen
options(scipen=999) # gets rid of scientific notation
df.metrics <- read.csv('~/Dropbox/TBI Team Folder/TBI_NODDI/r_analysis/dataframes/corrected_singleShell.csv')

d <- function(arg1){
  x <- mes(m.1=mean(subset(df.metrics, df.metrics$Group=="Control")[,arg1],na.rm = T), m.2=mean(subset(df.metrics, df.metrics$Group=="TBI")[,arg1], na.rm=T),
           n.1=table(df.metrics$Group)[1],n.2 = table(df.metrics$Group)[2],
           sd.1 = sd(subset(df.metrics, df.metrics$Group=="Control")[,arg1],na.rm = T),
           sd.2=sd(subset(df.metrics, df.metrics$Group=="TBI")[,arg1], na.rm=T), verbose = F, dig = 4)  
  return(list(arg1,x$d, x$l.d, x$u.d))
}
d("fa_Cingulate_L")

names(df.metrics) # 4-33 are metrics of interest
y <- lapply(names(df.metrics[3:58]),d)
z <- melt(matrix(unlist(y),4,224))

a1 <- subset(z,z$Var1==1)[3]
a2 <- subset(z,z$Var1==2)[3]
a3 <- subset(z,z$Var1==3)[3]
a4 <- subset(z,z$Var1==4)[3]

a6 <- cbind(a1,a2, a3, a4)
names(a6) <- c("roi","d", "l.d","u.d")
a6$metric <- gsub("_[A-z].*", "",a6$roi)
a6$roi <-gsub("fa_", "", a6$roi)
a6$roi <-gsub("md_", "", a6$roi)
a6$roi <-gsub("FA_", "", a6$roi)
a6$roi <-gsub("MD_", "", a6$roi)

a6$d <- as.numeric(levels(a6$d)[a6$d])
a6$l.d <- as.numeric(levels(a6$l.d)[a6$l.d])
a6$u.d <- as.numeric(levels(a6$u.d)[a6$u.d])

eff_plot <- ggplot(a6, aes(roi))

eff_plot + geom_bar(aes(fill = metric, x= roi, y= d),stat = "identity", position = "dodge", colour="black") + 
  scale_fill_brewer(palette="Spectral") +
  geom_errorbar(aes(mapping=metric, ymin=a6$l.d, ymax=a6$u.d), linetype =2, colour = "#333333", width=.3, position=position_dodge(.9)) +
  labs(x="ROI Tracts",y="d",title="Effect size between single and multishell DWI") +
  theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title = element_text(size = 18), axis.text.x=element_text(angle=90, vjust=0.5, size = 18), axis.text = element_text(size = 18), legend.text = element_text(size = 18), legend.title = element_text(size = 18),  legend.key.size = unit(1, "cm"))

axis.text = element_text(size = 18),   legend.text = element_text(size = 18), legend.key.size = unit(1, "cm")
#--

com_plot <- ggplot(df.metrics, aes(color = Group, x = fa_wholebrain_wm, y = FA_wholebrain_wm))
com_plot + geom_jitter(aes(col = Group)) +
  coord_flip() +
  scale_color_manual(values=c("deepskyblue2", "orangered2")) +
  labs(title="Distribution of FA between DWI modalities",x="Single Shell DWI (fa)", y="Multishell DWI (FA)") + 
  theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title = element_text(size = 18, family = "Times"), axis.text = element_text(size = 18, family = "Times"), axis.text.x = element_text(size = 18, family = "Times"), 
        legend.text = element_text(size = 18, family = "Times"), legend.key.size = unit(1, "cm"))
