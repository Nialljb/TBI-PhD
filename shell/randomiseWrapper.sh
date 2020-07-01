#!/bin/sh

module load fsl/6.0.1

scripts=/rds/general/project/c3nl_shared/live/dependencies

root=/rds/general/user/nbourke/home/projects/social
project=${root}/volumetric_results


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

for task in act_LARS_disc aware_LARS_disc emo_LARS_disc intel_LARS_disc total_LARS_disc;
  do
  #- set output -#
  mkdir -p ${project}/${task}_out2
  output=${project}/${task}_out2

  for mod in smwc1 smwc2;
    do
    #- set variables -#
    all_FA=${project}/all_${mod}.nii.gz
    FA_skeleton_mask=${project}/all_${mod}_mask.nii.gz
    design=${root}/scripts/${task}.mat
    contrast=${root}/scripts/contrast.con

    ## Run command ##
    ~/c3nl_tools/pbs_randomise_par -wt 06:00:00 -mem 8Gb -i $all_FA -o ${output}/TBSS_${mod}_${task} -m $FA_skeleton_mask -d $design -t $contrast -n 5000 --T2 -V

  done
done
