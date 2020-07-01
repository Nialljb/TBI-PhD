# Install dependencies ----
rm(list= ls()) # clear screen
options(scipen=999) # gets rid of scientific notation

library(reshape2)
library(matrixStats)
library(ggplot2)
library(psych)
# White matter mask
df.vbm <- read.csv('~/Dropbox/TBI Team Folder/TBI_NODDI/r_analysis/dataframes/tractVol_meanIntensity_fsl.csv')

long_con.vbm <- melt(df.vbm[4:18])

ggplot(long_con.vbm, aes(x=variable, y=value)) +
  geom_jitter(width = 0.2, outlier.size=0, aes(col = Group)) +
    geom_boxplot(outlier.size=0, alpha=0.2) + 
      coord_flip() +
        scale_color_manual(values=c("deepskyblue2", "orangered2")) +
          labs(title="Distribution of White Matter Volume",x="Tracts", y="Volume") + 
            theme(plot.title = element_text(hjust = 0.5, size = 18), axis.title = element_text(size = 18, family = "Times"), axis.text = element_text(size = 18, family = "Times"), axis.text.x = element_text(size = 18, family = "Times"), 
                  legend.text = element_text(size = 18, family = "Times"), legend.key.size = unit(1, "cm"))


t.test(df$wm_vol ~ df$Group)

# VBM mask vs. skeletonised track massk ----
df.vbm_skel <- read.csv('~/Dropbox/TBI Team Folder/TBI_NODDI/r_analysis/dataframes/comparingVol_estimates.csv')

plot(df.vbm_skel$Skeleton_vol ~ df.vbm_skel$WM_mask_vol)
cor(df.vbm_skel$Skeleton_vol,  df.vbm_skel$WM_mask_vol)
t.test(df.vbm_skel$Skeleton_vol,  df.vbm_skel$WM_mask_vol)

## Comparing SPM and fsl values ##
df <- read.csv('~/Dropbox/TBI Team Folder/TBI_NODDI/r_analysis/dataframes/volume.csv')


names(df)
describeBy(df$wm_vol, df$Group)

plot(df$WM_spm, df$wm_vol)
cor(df$WM_spm, df$wm_vol)
plot(df$wm_vol, df$WM_M_fsl)
cor(df$wm_vol, df$WM_M_fsl)

p <- ggplot(df, aes(colour = Group, WM_spm, wm_vol ))
p + geom_point() 

p <- ggplot(df, aes(colour = Group, wm_vol, newMNI_FA_M ))
p + geom_point() 

cor(df$wm_vol, df$newMNI_FA_M)
