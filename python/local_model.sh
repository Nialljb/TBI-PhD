

#source activate PY27_AMICO
project=tmp # Jan2020
dir=/Users/nbourke/scratch/BIOAX/${project}/data/ # remember needs to end with /
echo "" > /Users/nbourke/scratch/BIOAX/${project}/subjAMICO.txt


for i in `ls $dir/`; do
  sub="${dir}/${i}/ec_data.nii.gz"
  if [ -f "$sub" ]; then
    echo "AMICO exists for $i"
    echo $i >> /Users/nbourke/scratch/BIOAX/${project}/subjAMICO.txt
  else
    echo "error: AMICO not found for $i"
  fi
done

for subject in `cat /Users/nbourke/scratch/BIOAX/${project}/subjAMICO.txt`; do
  python /Users/nbourke/scratch/BIOAX/scripts/AMICO_modeling.py $dir $subject
done
