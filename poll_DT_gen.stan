data {
  int<lower=0> N;    //the number of pollsters 
  int<lower=0> K;    //the number of groups K = 3 (approve, disapprove, unsure)
  int<lower=0> m[N,K]; //matrix of pollsters(N) and the number of groups(K)
  
  
  real<lower=0> a; //hyperparameter for gamma hyper prior
  real<lower=0> b; //hyperparameter for gamma hyper prior
}


parameters {
  vector<lower=0>[K] alpha; //hyper parameters for dirichlet distribution
  simplex[K] p[N]; //for each pollster, probabilities for the 3 different groups sum up to 1
}


model {
  alpha ~ gamma(a,b);   //vector alpha consists of K = 3 random draws, prior distribution for alpha
  
  for (n in 1:N){
  p[n] ~ dirichlet(alpha);
  }  //prior 
  
  for (l in 1:N){
    m[l,] ~ multinomial(p[l]); //likelihood
  }
  
}

generated quantities{
  simplex[K] p_gnt[N];
  int <lower=0> y_gen[N,K];
  
  for (d in 1:N){
    p_gnt[d] = dirichlet_rng(alpha);
    
  }
  
  for (s in 1:N){
    y_gen[s,] = multinomial_rng(p[s],100);}

}


