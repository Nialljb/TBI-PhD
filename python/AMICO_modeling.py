#Import python libraries
import sys, os 
import glob

# Maria Yanez-Lopez 2018 
# V2.0 Niall Bourke ~ 17/07/2019

#https://github.com/daducci/AMICO/issues/56 REMEMBER TO ADD THIS BEFORE IMPORTING AMICO OR IT WILL NOT WORK!!!
nb_threads = 1
os.environ["OMP_NUM_THREADS"] = str(nb_threads)  # Has impact on a supercomputer
os.environ["MKL_NUM_THREADS"] = str(nb_threads)  # Has impact both on supercomputer and personal computer if you are using MKL

#Import amico 
import amico
#Setup/initialize the framework (this only has to be done once):
amico.core.setup()


#Define the data directory (data needs to share NODDI acquisition protocol; ie, b-values)
DATA_DIR = sys.argv[1]  # take 1st user input argument 
SUBJECT = sys.argv[2] # take 2nd user input argument 

print(SUBJECT)

bval = glob.glob(DATA_DIR + SUBJECT + "/*bval") # find string with wildcard expansion - output is a list
bval = ''.join(bval) # convert list output from glob to string
bvec = glob.glob(DATA_DIR + SUBJECT + "/*bvec")
bvec = ''.join(bvec)
data = glob.glob(DATA_DIR + SUBJECT + "/*ec_data*")
data = ''.join(data)  
mask = glob.glob(DATA_DIR + SUBJECT + "/*mask*")
mask = ''.join(mask)

print(SUBJECT + " " + bval + " exists")
ae = amico.Evaluation(DATA_DIR, SUBJECT)
amico.util.fsl2scheme(bval, bvec, schemeFilename = DATA_DIR + SUBJECT + "/NODDI.scheme", bStep = 1000, delimiter = None) #Using normalised bvecs, check naming!

#Load the data:
ae.load_data(dwi_filename = data , scheme_filename = "NODDI.scheme", mask_filename = mask, b0_thr = 0)

#Set model for NODDI and generate the response functions for all the compartments: Note that you need to compute the reponse functions only once per study; in fact, scheme files with same b-values but different number/distribution of samples on each shell will result in the same precomputed kernels (which are actually computed at higher angular resolution). The function generate_kernels() does not recompute the kernels if they already exist, unless the flag regenerate is set, e.g. generate_kernels( regenerate = True )
ae.set_model("NODDI")
ae.generate_kernels()

#https://github.com/daducci/AMICO/issues/67
ae.CONFIG['solver_params']['numThreads'] = nb_threads

#Load the precomputed kernels (at higher resolution) and adapt them to the actual scheme (distribution of points on each shell) of the current subject:
ae.load_kernels()


#Model fit:
ae.fit()

#Finally, save the results as NIfTI images:
ae.save_results()
