# Install dependencies ----
library(reshape2)
library(matrixStats)
library(ggplot2)
require(plotrix)
library(compute.es)

rm(list= ls()) # clear screen
options(scipen=999) # gets rid of scientific notation

#df.metrics <- read.csv('~/Dropbox/TBI Team Folder/TBI_NODDI/r_analysis/dataframes/effectSize_diffusionMetrics.csv')
df.metrics <- read.csv('~/Dropbox/TBI Team Folder/TBI_NODDI/r_analysis/dataframes/effectSize_diffusionMetrics2.csv')


d <- function(arg1){
  x <- mes(m.1=mean(subset(df.metrics, df.metrics$Group=="Control")[,arg1],na.rm = T), m.2=mean(subset(df.metrics, df.metrics$Group=="TBI")[,arg1], na.rm=T),
           n.1=table(df.metrics$Group)[1],n.2 = table(df.metrics$Group)[2],
           sd.1 = sd(subset(df.metrics, df.metrics$Group=="Control")[,arg1],na.rm = T),
           sd.2=sd(subset(df.metrics, df.metrics$Group=="TBI")[,arg1], na.rm=T), verbose = F, dig = 4)  
  return(list(arg1,x$d, x$l.d, x$u.d))
}
# Test if function works on one example variable
d("AD_Cingulate_R")

names(df.metrics) # 3-106 are metrics of interest
# Run function across list of variables of interest
y <- lapply(names(df.metrics[3:119]),d)
z <- melt(matrix(unlist(y),4,117))

a1 <- subset(z,z$Var1==1)[3]
a2 <- subset(z,z$Var1==2)[3]
a3 <- subset(z,z$Var1==3)[3]
a4 <- subset(z,z$Var1==4)[3]

a6 <- cbind(a1,a2, a3, a4)
names(a6) <- c("roi","d", "l.d","u.d")

a6$metric <- gsub("_[A-z].*", "",a6$roi)
a6$roi <-gsub("fa_", "", a6$roi)
a6$roi <-gsub("icvf_", "", a6$roi)
a6$roi <-gsub("od_", "", a6$roi)
a6$roi <-gsub("vol_", "", a6$roi)
a6$roi <-gsub("MD_", "", a6$roi)
a6$roi <-gsub("RD_", "", a6$roi)
a6$roi <-gsub("AD_", "", a6$roi)
a6$roi <-gsub("isovf_", "", a6$roi)
a6$roi <-gsub("absVol_", "", a6$roi)

a6$d <- as.numeric(levels(a6$d)[a6$d])
a6$l.d <- as.numeric(levels(a6$l.d)[a6$l.d])
a6$u.d <- as.numeric(levels(a6$u.d)[a6$u.d])

eff_plot <- ggplot(a6, aes(roi))

eff_plot + geom_bar(aes(fill = metric, x= roi, y= d),stat = "identity", position = "dodge", colour="black") + 
  theme(axis.text.x=element_text(angle=90, vjust=0.5)) +
  scale_fill_brewer(palette="Spectral") +
  geom_errorbar(aes(mapping=metric, ymin=a6$l.d, ymax=a6$u.d), linetype =2, colour = "#333333", width=.3, position=position_dodge(.9)) +
  labs(x="ROI Tracts",y="d",title="Effect Size") 



# Subsetting to exclude Volume
#sub <- a6[which(a6$metric!='vol'),] # (rows, column) In matlab you need to specify row or all rowss, here you put nothing in it will look at all rows by default.  
sub <- a6[which(a6$metric!='RD' & a6$metric!='AD'),] # (rows, column) In matlab you need to specify row or all rowss, here you put nothing in it will look at all rows by default.  
# a6$metric!='vol' & 
sub_plot <- ggplot(sub, aes(roi))

sub_plot + geom_bar(aes(fill = metric, x= roi, y= d),stat = "identity", position = "dodge", colour="black") + 
  theme(axis.text.x=element_text(angle=90, vjust=0.5)) +
  scale_fill_brewer(palette="Spectral") +
  geom_errorbar(aes(mapping=metric, ymin=sub$l.d, ymax=sub$u.d), linetype =2, colour = "#333333", width=.3, position=position_dodge(.9)) +
  labs(x="ROI Tracts",y="d",title="Effect Size")  +
  theme(text = element_text(size=20)) 

