## Before running this script run GBBayes.R, and GBC.R

## load data
data1=read.csv("./Data/ObjectiveDataPerSubjExp1.csv")
data2=read.csv("./Data/ObjectiveDataPerSubjExp2.csv")
pooledData=rbind(data1,data2)

#parameters
seed=1

set.seed(seed)

############################ Unconscious ############################ 
############################ Exp 1 
res1GBBayesU=GBBayes(data1$R_U,data1$N_U,chance = 0.5,BF_threshold = 3,
                    AS_low_bound = .5,
                    theta_mu_prior = .55, theta_sig_prior = .1,
                    sigma_mu_prior = .025, sigma_sig_prior = .05,
                    n_chains = 2, burining_period = 1500, iterations_per_chain = 5000,
                    base_seed = seed)
res1GBCU=GBC(data1$R_U,data1$N_U,chance = 0.5,alpha = 0.05, tail = 'right')

############################ Exp 2 
res2GBBayesU=GBBayes(data2$R_U,data2$N_U,chance = 0.5,BF_threshold = 3,
                    AS_low_bound = .5,
                    theta_mu_prior = .55, theta_sig_prior = .1,
                    sigma_mu_prior = .025, sigma_sig_prior = .05,
                    n_chains = 2, burining_period = 1500, iterations_per_chain = 5000,
                    base_seed = seed)
res2GBCU=GBC(data2$R_U,data2$N_U,chance = 0.5,alpha = 0.05, tail = 'right')

############################ Exp 1&2 
res12GBBayesU=GBBayes(pooledData$R_U,pooledData$N_U,chance = 0.5,BF_threshold = 3,
                     AS_low_bound = .5,
                     theta_mu_prior = .55, theta_sig_prior = .1,
                     sigma_mu_prior = .025, sigma_sig_prior = .05,
                     n_chains = 2, burining_period = 1500, iterations_per_chain = 5000,
                     base_seed = seed)
res12GBCU=GBC(pooledData$R_U,pooledData$N_U,chance = 0.5,alpha = 0.05, tail = 'right')
averageAS=mean(pooledData$R_U/pooledData$N_U)
stdAS=sd(pooledData$R_U/pooledData$N_U)

############################ Conscious 1 (conT-conS) ############################
############################ Exp 1 
res1GBBayesC1=GBBayes(data1$R_C1,data1$N_C1,chance = 0.5,BF_threshold = 3,
                    AS_low_bound = .5,
                    theta_mu_prior = .55, theta_sig_prior = .1,
                    sigma_mu_prior = .025, sigma_sig_prior = .05,
                    n_chains = 2, burining_period = 1500, iterations_per_chain = 5000,
                    base_seed = seed)
res1GBCC1=GBC(data1$R_C1,data1$N_C1,chance = 0.5,alpha = 0.05, tail = 'right')

############################ Exp 2
res2GBBayesC1=GBBayes(data2$R_C1,data2$N_C1,chance = 0.5,BF_threshold = 3,
                    AS_low_bound = .5,
                    theta_mu_prior = .55, theta_sig_prior = .1,
                    sigma_mu_prior = .025, sigma_sig_prior = .05,
                    n_chains = 2, burining_period = 1500, iterations_per_chain = 5000,
                    base_seed = seed)
res2GBCC1=GBC(data2$R_C1,data2$N_C1,chance = 0.5,alpha = 0.05, tail = 'right')

############################ Exp 1&2 
res12GBBayesC1=GBBayes(pooledData$R_C1,pooledData$N_C1,chance = 0.5,BF_threshold = 3,
                      AS_low_bound = .5,
                      theta_mu_prior = .55, theta_sig_prior = .1,
                      sigma_mu_prior = .025, sigma_sig_prior = .05,
                      n_chains = 2, burining_period = 1500, iterations_per_chain = 5000,
                      base_seed = seed)
res12GBCC1=GBC(pooledData$R_C1,pooledData$N_C1,chance = 0.5,alpha = 0.05, tail = 'right')
averageAS=mean(pooledData$R_C1/pooledData$N_C1)
stdAS=sd(pooledData$R_C1/pooledData$N_C1)

############################ Conscious 2 (conT-unS) ############################
############################ Exp 1 
R=data1$R_C2[!is.na(data1$R_C2)]
N=data1$N_C2[!is.na(data1$R_C2)]
res1GBBayesC2=GBBayes(R,N,chance = 0.5,BF_threshold = 3,
                    AS_low_bound = .5,
                    theta_mu_prior = .55, theta_sig_prior = .1,
                    sigma_mu_prior = .025, sigma_sig_prior = .05,
                    n_chains = 2, burining_period = 1500, iterations_per_chain = 5000,
                    base_seed = seed)
res1GBCC2=GBC(R,N,chance = 0.5,alpha = 0.05, tail = 'right')

############################ Exp 2 
R=data2$R_C2[!is.na(data2$R_C2)]
N=data2$N_C2[!is.na(data2$R_C2)]
res2GBBayesC2=GBBayes(R,N,chance = 0.5,BF_threshold = 3,
                    AS_low_bound = .5,
                    theta_mu_prior = .55, theta_sig_prior = .1,
                    sigma_mu_prior = .025, sigma_sig_prior = .05,
                    n_chains = 2, burining_period = 1500, iterations_per_chain = 5000,
                    base_seed = seed)
res2GBCC2=GBC(R,N,chance = 0.5,alpha = 0.05, tail = 'right')

############################ Exp 1&2 
R=pooledData$R_C2[!is.na(pooledData$R_C2)]
N=pooledData$N_C2[!is.na(pooledData$R_C2)]
res12GBBayesC2=GBBayes(R,N,chance = 0.5,BF_threshold = 3,
                      AS_low_bound = .5,
                      theta_mu_prior = .55, theta_sig_prior = .1,
                      sigma_mu_prior = .025, sigma_sig_prior = .05,
                      n_chains = 2, burining_period = 1500, iterations_per_chain = 5000,
                      base_seed = seed)
res12GBCC2=GBC(R,N,chance = 0.5,alpha = 0.05, tail = 'right')
averageAS=mean(R/N)
stdAS=sd(R/N)