#' Intraclass Correlation Coefficient (ICC) under ANOVA Model 1A.
#'
#' This ICC is associated with the one-factor ANOVA model where each subject could be rated by a different group of raters. This ICC represents
#' a measure of inter-rater reliability among all raters involved in the experiment.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} - Equation #8.1.3, chapter 8. Advanced Analytics, LLC.
#' @param ratings This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @return This function returns a list containing the following 9 values:
#' 1. sig2s: the subject variance component. 2. sig2e: the error variance component. 3. icc1a: the ICC/inter-rater reliability coefficient
#' 4. n: the number of subjects. 5. r: the number of raters. 6. max.rep: the maximum number of ratings per subject. 7. min.rep: the minimum
#' number of ratings per subjects. 8. M: the total number of ratings for all subjects and raters. 9. ov.mean: the overall mean rating.
#' @examples
#' #iccdata1 is a small dataset that comes with the package. Use it as follows:
#' library(irrICC)
#' iccdata1 #see what the iccdata1 dataset looks like
#' icc1a.fn(iccdata1)
#' coeff <- icc1a.fn(iccdata1)$icc1a
#' coeff
#' @importFrom magrittr %>%
#' @importFrom dplyr tally across
#' @export
icc1a.fn <- function(ratings){
  ratings <- data.frame(lapply(ratings, as.character),stringsAsFactors=FALSE)
  ratings <- as.data.frame(lapply(ratings,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  ratings[,2:ncol(ratings)] <- lapply(ratings[,2:ncol(ratings)],as.numeric)
  rep.vec <- dplyr::group_by(ratings,across(1))%>%tally()
  n <- nrow(rep.vec)
  r <- ncol(ratings)-1
  ov.mean <- mean(as.numeric(unlist(ratings[,2:(r+1)])),na.rm = TRUE)
  b <- cbind(ratings[1],(!is.na(ratings[,2:(r+1)])))
  mij <- sapply(2:(r+1), function(x) tapply(b[[x]],b[[1]],sum))
  target.vec <- as.matrix(unlist(rep.vec[1]))
  mij.df <- cbind(target.vec,mij)
  names(mij.df) <- names(b)
  #k0.1 <- mij[,2:(r+1)]**2
  k0.1 <- mij**2
  # m.jvec <- colSums(mij[,2:(r+1)]) #Total number of ratings per rater m.j
  m.jvec <- colSums(mij) #Total number of ratings per rater m.j
  k0.2 <- matrix(m.jvec,nrow = n,ncol=r,byrow = TRUE)
  k0 <- sum(k0.1 / k0.2)
  # mi.tot <- cbind(rep.vec[1],miTot=rowSums(mij[,2:(r+1)]))
  mi.tot <- cbind(rep.vec[1],miTot=rowSums(mij))
  Ty <- sum(ratings[,2:(r+1)],na.rm = TRUE)
  T2y <- sum(ratings[,2:(r+1)]**2,na.rm = TRUE)
  T2s.1 <- sapply(2:(r+1),function(x) tapply(ratings[[x]], ratings[[1]],function(x) sum(x,na.rm = TRUE))) #sums of ratings by subject & rater
  T2s.2 <- cbind(rep.vec[[1]],rowSums(T2s.1,na.rm=TRUE),mi.tot[[2]],rowSums(T2s.1,na.rm=TRUE)**2/mi.tot[[2]]) #sums of ratings by subject + mi. + subject-level mean

  T2s.2 <-  as.data.frame(T2s.2)
  T2s.2 <- data.frame(lapply(T2s.2, as.character),stringsAsFactors=FALSE)
  T2s.2[,2:4] <- lapply(T2s.2[,2:4],as.numeric)
  T2s <- sum(T2s.2[,4],na.rm = TRUE)
  max.rep <- max(rep.vec$n)
  min.rep <- min(rep.vec$n)
  Mtot <- sum(mi.tot$miTot)
  sig2e <- max(0,(T2y - T2s)/(Mtot-n))
  sig2s <- max(0,(T2s-Ty**2/Mtot-(n-1)*sig2e)/(Mtot-k0))
  icc1a <- (sig2s/(sig2s+sig2e))
  return(data.frame(sig2s,sig2e,icc1a,n,r,max.rep,min.rep,Mtot,ov.mean))
}
#format(p.value,digits=6,scientific = TRUE)


#' Intraclass Correlation Coefficient (ICC) under ANOVA Model 1B.
#'
#' This ICC is associated with the one-factor ANOVA model where each rater may rate a different group of subjects. This ICC represents a global
#' measure of intra-rater reliability coefficient for all raters involved in the experiment.
#' @references See equation 8.2.4 of chapter 8 in Gwet, 2014: Handbook of Inter-Rater Reliability - 4th ed.
#' @param ratings This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates in
#' subject numbers if a subject was rated multiple times) and each of the remaining columns is associated with a particular rater and contains
#' its numeric ratings.
#' @return This function returns a list containing the following 9 values:
#' 1. sig2r: the rater variance component. 2. sig2e: the error variance component. 3. icc1b: the ICC/intra-rater reliability coefficient
#' 4. n: the number of subjects. 5. r: the number of raters. 6. max.rep: the maximum number of ratings per subject. 7. min.rep: the minimum
#' number of ratings per subjects. 8. M: the total number of ratings for all subjects and raters. 9. ov.mean: the overall mean rating.
#' @examples
#' #iccdata1 is a small dataset that comes with the package. Use it as follows:
#' library(irrICC)
#' iccdata1 #see what the iccdata1 dataset looks like
#' icc1b.fn(iccdata1)
#' coeff <- icc1b.fn(iccdata1)$icc1b #this only gives you the ICC coefficient
#' coeff
#' @export
icc1b.fn <- function(ratings){
  ratings <- data.frame(lapply(ratings, as.character),stringsAsFactors=FALSE)
  ratings <- as.data.frame(lapply(ratings,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  ratings[,2:ncol(ratings)] <- lapply(ratings[,2:ncol(ratings)],as.numeric)
  rep.vec <- dplyr::group_by(ratings,across(1))%>%tally()
  n <- nrow(rep.vec)
  r <- ncol(ratings)-1
  ov.mean <- mean(as.matrix(ratings[,2:(r+1)]),na.rm = TRUE)

    #Calculating the mij matrix
  b <- cbind(ratings[1],(!is.na(ratings[,2:(r+1)])))
  mij <- sapply(2:(r+1), function(x) tapply(b[[x]],b[[1]],sum))
  mij <- cbind(rep.vec[1],mij)
  names(mij) <- names(b)

  k1.1 <- mij[,2:(r+1)]**2
  mi.vec <- rowSums(mij[,2:(r+1)]) #Total number of ratings per subject mi.
  k1.2 <- replicate(r,mi.vec)
  k1 <- sum(k1.1 / k1.2)

  mi.tot <- cbind(rep.vec[1],miTot=rowSums(mij[,2:(r+1)]))
  m.jtot <- as.data.frame(cbind(raters=colnames(ratings)[2:(r+1)],mjTot=colSums(mij[,2:(r+1)])))

  Ty <- sum(ratings[,2:(r+1)],na.rm = TRUE)
  T2y <- sum(ratings[,2:(r+1)]**2,na.rm = TRUE)
  T2r.1 <- (colSums(ratings[,2:(r+1)],na.rm = TRUE))**2
  T2r.2 <- as.numeric(as.vector(unlist(m.jtot[,2])))
  T2r <- sum(T2r.1 / T2r.2,na.rm=TRUE)

  max.rep <- max(rep.vec$n)
  min.rep <- min(rep.vec$n)
  Mtot <- sum(mi.tot$miTot)
  sig2e <- max(0,(T2y - T2r)/(Mtot-r))
  sig2r <- max(0,(T2r-Ty**2/Mtot - (r-1)*sig2e)/(Mtot-k1))
  icc1b <- (sig2r/(sig2r+sig2e))
  return(data.frame(sig2r,sig2e,icc1b,n,r,max.rep,min.rep,Mtot,ov.mean))
}

#' Mean of Squares for Errors (MSE) under ANOVA Model 1A.
#'
#' This MSE is associated with the one-factor ANOVA model where each subject could be rated by a different group of raters. This MSE is used
#' for calculating confidence intervals and p-values associated with the inter-rater reliability coefficient.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.1. Advanced Analytics, LLC.
#' @param dfra This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @return This function returns a vector containing the following 3 values:
#' 1. mse: the MSE. 2. M: The total number of ratings from all raters and subjects. 3. n: The number of subjects that participated in the experiment.
mse1a.fn <- function(dfra){
  dfra <- data.frame(lapply(dfra, as.character),stringsAsFactors=FALSE)
  dfra <- as.data.frame(lapply(dfra,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  dfra[,2:ncol(dfra)] <- lapply(dfra[,2:ncol(dfra)],as.numeric)
  #rep.vec <- dplyr::count(dfra,1)
  rep.vec <- dplyr::group_by(dfra,across(1))%>%tally()
  names(rep.vec)[2]<-"nrepli"
  n <- nrow(rep.vec) #n = number of subjects
  r <- ncol(dfra)-1 #r = number of raters
  Mtot <- sum(!is.na(dfra[,2:ncol(dfra)])) #Mtot = total number of non-missing ratings
  tvec <- as.vector(unlist(rep.vec[1]))
  ybar.ivec <- sapply(tvec,function(x){
    dfra.imat <- dfra[(dfra[1]==x),2:(r+1)]
    ybar.i <- mean(as.matrix(dfra.imat),na.rm = TRUE)
  })
  rep.vec <- cbind(rep.vec,ybar.ivec)
  dfra1 <- merge(dfra,rep.vec)
  mse <- sum((dfra1[,2:(r+1)]-replicate(r,dfra1$ybar.ivec))**2,na.rm = TRUE)/(Mtot-n)
  return(data.frame(mse,Mtot,n))
}
#' Mean of Squares for Errors (MSE) under ANOVA Model 1B.
#'
#' This MSE is associated with the one-factor ANOVA model where each rater may rate a different group of subjects. This MSE is used
#' for calculating confidence intervals and p-values associated with the intra-rater reliability coefficient.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.3. Advanced Analytics, LLC.
#' @param dfra This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @return This function returns a vector containing the following 3 values:
#' 1. mse: the MSE. 2. M: The total number of ratings from all raters and subjects. 3. n: The number of subjects that participated in the experiment.
mse1b.fn <- function(dfra){
  #Computing the MSE associated with Model 1B (c.f. K. Gwet "Handbook of Inter-Rater Reliability", 4th edition, page 219)
  dfra <- data.frame(lapply(dfra, as.character),stringsAsFactors=FALSE)
  dfra <- as.data.frame(lapply(dfra,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  dfra[,2:ncol(dfra)] <- lapply(dfra[,2:ncol(dfra)],as.numeric)
  #rep.vec <- plyr::count(dfra,1)
  rep.vec <- dplyr::group_by(dfra,across(1))%>%tally()
  names(rep.vec)[2]<-"nrepli"
  n <- nrow(rep.vec) #n = number of subjects
  r <- ncol(dfra)-1 #r = number of raters
  Mtot <- sum(!is.na(dfra[,2:ncol(dfra)])) #Mtot = total number of non-missing ratings
  ymean <- mean(as.numeric(as.vector(unlist(dfra[,2:(r+1)]))),na.rm = TRUE)
  ybar.j. <- colMeans(dfra[,2:(r+1)],na.rm = TRUE)
  ybar.j.mat <- matrix(ybar.j.,nrow=nrow(dfra),ncol=r,byrow = TRUE)
  mse <- sum((dfra[,2:(r+1)]-ybar.j.mat)**2,na.rm = TRUE)/(Mtot-r)
  return(data.frame(mse,Mtot,n))
}

#' Mean of Squares for Subjects (MSS) under ANOVA Model 1A.
#'
#' This MSS is associated with the one-factor ANOVA model where each subject may be rated a different group of raters. This MSS is used
#' for calculating confidence intervals and p-values associated with the inter-rater reliability coefficient.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.1. Advanced Analytics, LLC.
#' @param dfra This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @return This function returns a vector containing the following 2 values:
#' 1. mss: the MSS. 2. n: The number of subjects.
mss1a.fn <- function(dfra){
  #Computing the MSS associated with Model 1B (c.f. K. Gwet "Handbook of Inter-Rater Reliability", 4th edition, page 219)
  dfra <- data.frame(lapply(dfra, as.character),stringsAsFactors=FALSE)
  dfra <- as.data.frame(lapply(dfra,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  dfra[,2:ncol(dfra)] <- lapply(dfra[,2:ncol(dfra)],as.numeric)
  ymean <- mean(as.matrix(dfra[,2:ncol(dfra)]),na.rm=TRUE)
  #rep.vec <- dplyr::count(dfra,1)
  rep.vec <- dplyr::group_by(dfra,across(1))%>%tally()
  names(rep.vec)[2]<-"nrepli"
  r <- ncol(dfra)-1
  misflag <- cbind(dfra[1],(!is.na(dfra[,2:(r+1)])))
  mij <- sapply(2:(r+1), function(x) tapply(misflag[[x]],misflag[[1]],sum))
  mij <- cbind(rep.vec[1],mij)
  names(mij) <- names(misflag)
  mi.vec <- rowSums(mij[,2:(r+1)],na.rm = TRUE)
  n <- nrow(rep.vec) #n = number of subjects
  tvec <- as.vector(unlist(rep.vec[1]))
  ybar.ivec <- sapply(tvec,function(x){
    dfra.imat <- dfra[(dfra[1]==x),2:(r+1)]
    ybar.i <- mean(as.matrix(dfra.imat),na.rm = TRUE)
  })
  rep.vec <- cbind(rep.vec,ybar.ivec)
  mss <- sum(mi.vec*(rep.vec[,3]-ymean)**2,na.rm = TRUE)/(n-1)
  return(data.frame(mss,n))
}
#' Mean of Squares for Raters (MSR) under ANOVA Model 1B.
#'
#' This MSR is associated with the one-factor ANOVA model where each rater may rate a different group of subjects. This MSR is used
#' for calculating confidence intervals and p-values associated with the intra-rater reliability coefficient.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.4. Advanced Analytics, LLC.
#' @param dfra This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @return This function returns a vector containing 2 values:
#' 1. msr: the MSR. 2. r: The number of raters that participated in the experiment.
msr1b.fn <- function(dfra){
  #Computing the MSR associated with Model 1B (c.f. K. Gwet "Handbook of Inter-Rater Reliability", 4th edition, page 219)
  dfra <- data.frame(lapply(dfra, as.character),stringsAsFactors=FALSE)
  dfra <- as.data.frame(lapply(dfra,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  dfra[,2:ncol(dfra)] <- lapply(dfra[,2:ncol(dfra)],as.numeric)
  #rep.vec <- dplyr::count(dfra,1)
  rep.vec <- dplyr::group_by(dfra,across(1))%>%tally()
  names(rep.vec)[2]<-"nrepli"
  r <- ncol(dfra)-1 #r = number of raters
  ybar.j. <- colMeans(dfra[,2:(r+1)],na.rm = TRUE)
  ymean <- mean(as.numeric(unlist(dfra[,2:(r+1)])),na.rm = TRUE)
  #Calculating the mij matrix
  b <- cbind(dfra[1],(!is.na(dfra[,2:(r+1)])))
  mij <- sapply(2:(r+1), function(x) tapply(b[[x]],b[[1]],sum))
  mij <- cbind(rep.vec[1],mij)
  names(mij) <- names(b)
  m.jtot <- as.data.frame(cbind(raters=colnames(dfra)[2:(r+1)],mjTot=colSums(mij[,2:(r+1)])))
  msr <- sum(as.numeric(as.vector(unlist(m.jtot[2]))) * (ybar.j.-ymean)**2) / (r-1)
  return(data.frame(msr,r))
}

#' Confidence Interval of Intraclass Correlation Coefficient (ICC) under ANOVA Model 1A.
#'
#' This function computes the lower and upper confidence bounds associated with the ICC under the one-factor ANOVA model
#' where each subject may be rated by a different group of raters.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.1, equations
#' 8.3.1 and 8.3.2. Advanced Analytics, LLC.
#' @param ratings This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @param conflev This is the optional confidence level associated with the confidence interval. If not specified, the default value
#' will be 0.95, which is the most commonly-used valuee in the literature.
#' @importFrom stats pf qf
#' @return This function returns a vector containing the lower confidence (lcb) and the upper confidence bound (ucb).
#' @examples
#' #iccdata3 is a small dataset that comes with the package. Use it as follows:
#' library(irrICC)
#' iccdata3 #see what the iccdata3 dataset looks like
#' ci.ICC1a(iccdata3)
#' @export
ci.ICC1a <- function(ratings,conflev=0.95){
  #This function produces the model 1A-based confidence interval associated with the intraclass correlation coefficient ICCa
  #(c.f. K. Gwet- Handbook of Inter-Rater Reliability-4th Edition, page 207)
  ratings <- data.frame(lapply(ratings, as.character),stringsAsFactors=FALSE)
  ratings <- as.data.frame(lapply(ratings,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  ratings[,2:ncol(ratings)] <- lapply(ratings[,2:ncol(ratings)],as.numeric)
  mse <- mse1a.fn(ratings)
  mss <- mss1a.fn(ratings)
  fobs <- mss$mss/mse$mse
  fl <- fobs/qf(1-(1-conflev)/2, df1=mse$n-1, df2=mse$Mtot-mse$n)
  fu <- fobs * qf(1-(1-conflev)/2, df1=mse$Mtot-mse$n, df2=mse$n-1)
  lcb <- (fl-1)/(fl+mse$Mtot/mse$n-1)
  ucb <- (fu-1)/(fu+mse$Mtot/mse$n-1)
  lcb <- max(0,lcb)
  ucb <- min(1,ucb)
  #c.i <- paste0("(",format(lcb,digits=4,scientific=FALSE)," to ",format(ucb,digits=4,scientific=FALSE),")")
  return(data.frame(lcb,ucb))
}
#' Confidence Interval of Intraclass Correlation Coefficient (ICC) under ANOVA Model 1B.
#'
#' This function computes the lower and upper confidence bounds associated with the ICC under the one-factor ANOVA model
#' where each rater may rate a different group of subjects.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.4, equations
#' 8.3.5 and 8.3.6. Advanced Analytics, LLC.
#' @param ratings This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @param conflev This is the optional confidence level associated with the confidence interval. If not specified, the default value
#' will be 0.95, which is the most commonly-used valuee in the literature.
#' @return This function returns a vector containing the following the lower confidence (lcb) and the upper confidence bound (ucb).
#' @examples
#' #iccdata1 is a small dataset that comes with the package. Use it as follows:
#' library(irrICC)
#' iccdata1 #see what the iccdata3 dataset looks like
#' ci.ICC1b(iccdata1)
#' @export
ci.ICC1b <- function(ratings,conflev=0.95){
  #This function produces the model 1B-based confidence interval associated with the intraclass correlation coefficient ICCa
  #(c.f. K. Gwet- Handbook of Inter-Rater Reliability-4th Edition, pages 218-219)
  ratings <- data.frame(lapply(ratings, as.character),stringsAsFactors=FALSE)
  ratings <- as.data.frame(lapply(ratings,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  ratings[,2:ncol(ratings)] <- lapply(ratings[,2:ncol(ratings)],as.numeric)
  mse <- mse1b.fn(ratings) #return(c(mse,Mtot,n))
  msr <- msr1b.fn(ratings) #return(c(msr,r))
  fobs <- msr[[1]]/mse[[1]]
  fl <- fobs/qf(1-(1-conflev)/2, df1=msr[[2]]-1, df2=mse[[2]]-msr[[2]])
  fu <- fobs * qf(1-(1-conflev)/2, df1=mse[[2]]-msr[[2]], df2=msr[[2]]-1)
  lcb <- (fl-1)/(fl+mse[[2]]/msr[[2]]-1)
  ucb <- (fu-1)/(fu+mse[[2]]/msr[[2]]-1)
  lcb <- min(0,lcb)
  ucb <- max(1,ucb)
  #c.i <- paste0("(",format(lcb,digits=4,scientific=FALSE)," to ",format(ucb,digits=4,scientific=FALSE),")")
  return(data.frame(lcb,ucb))
}
#' P-value of the ICC under ANOVA Model 1A for the specific null values 0,0.1,0.3,0.5,0.7,0.9.
#'
#' This function computes the p-value associated with the Intraclass Correlation Coefficient (ICC) under the one-factor ANOVA
#' model where each subject may be rated by a different group of raters.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.2, equation
#' 8.3.4. Advanced Analytics, LLC.
#' @param ratings This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @return This function returns a vector containing 6 p-values associated with the 6 null values 0,0.1,0.3,0.5,0.7,0.9.
#' @examples
#' #iccdata1 is a small dataset that comes with the package. Use it as follows:
#' library(irrICC)
#' iccdata1 #see what the iccdata1 dataset looks like
#' pval.ICC1a(iccdata1)
#' @export
pval.ICC1a <- function(ratings){
  ratings <- data.frame(lapply(ratings, as.character),stringsAsFactors=FALSE)
  ratings <- as.data.frame(lapply(ratings,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  ratings[,2:ncol(ratings)] <- lapply(ratings[,2:ncol(ratings)],as.numeric)
  mse.out <- mse1a.fn(ratings)
  mss.out <- mss1a.fn(ratings)
  mse <- mse.out$mse
  Mtot <- mse.out$Mtot
  n <- mse.out$n
  mss <- mss.out[[1]]
  rho.zero <- c(0,0.1,0.3,0.5,0.7,0.9)
  pval <- sapply(1:6,function(x){
     fobs <- mss/(mse*(1+Mtot*rho.zero[x]/(n*(1-rho.zero[x]))))
     pvals <- 1 - pf(fobs,df1=n-1,df2=Mtot-n)
  })
  return(data.frame(rho.zero,pval))
}
#' P-value of the ICC under ANOVA Model 1A for arbitrary null values.
#'
#' This function computes the p-value associated with the Intraclass Correlation Coefficient (ICC) under the one-factor ANOVA model
#' where each subject may be rated by a different group of raters.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.2, equation
#' 8.3.4. Advanced Analytics, LLC.
#' @param ratings This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @param rho.zero This is an optional parameter that represents a vector containing an arbitrary number of null values between 0 and 1
#' for which a p-value will be calculated. If not specified then its defauklt value will be 0.
#' @return This function returns a vector containing p-values associated with the null values specified in the parameter rho.zero.
#' @examples
#' #iccdata1 is a small dataset that comes with the package. Use it as follows:
#' library(irrICC)
#' iccdata1 #see what the iccdata1 dataset looks like
#' pvals.ICC1a(iccdata1,c(0,0.17,0.22,0.35))
#' @export
pvals.ICC1a <- function(ratings,rho.zero=0){
  ratings <- data.frame(lapply(ratings, as.character),stringsAsFactors=FALSE)
  ratings <- as.data.frame(lapply(ratings,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  ratings[,2:ncol(ratings)] <- lapply(ratings[,2:ncol(ratings)],as.numeric)
  mse.out <- mse1a.fn(ratings)
  mss.out <- mss1a.fn(ratings)
  mse <- mse.out[[1]]
  Mtot <- mse.out[[2]]
  n <- mse.out[[3]]
  mss <- mss.out[[1]]
  rlen <- length(rho.zero)
  pval <- sapply(1:rlen,function(x){
    fobs <- mss/(mse*(1+Mtot*rho.zero[x]/(n*(1-rho.zero[x]))))
    pvals <- 1 - pf(fobs,df1=n-1,df2=Mtot-n)
  })
  return(data.frame(rho.zero,pval))
}
#' P-value of the ICC under ANOVA Model 1B for the specific null values 0,0.1,0.3,0.5,0.7,0.9.
#'
#' This function computes the p-value associated with the Intraclass Correlation Coefficient (ICC) under the one-factor ANOVA model
#' where each rater may rate a different group of subject.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.5, equation
#' 8.3.8. Advanced Analytics, LLC.
#' @param ratings This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @return This function returns a vector containing 6 p-values associated with the 6 null values 0,0.1,0.3,0.5,0.7,0.9.
#' @examples
#' #iccdata1 is a small dataset that comes with the package. Use it as follows:
#' library(irrICC)
#' iccdata1 #see what the iccdata1 dataset looks like
#' pval.ICC1b(iccdata1)
#' @export
pval.ICC1b <- function(ratings){
  #This function computes 6 Model 1B-based p-values associated with the 6 rho values in rho.zero <- c(0,0.1,0.3,0.5,0.7,0.9)
  #(c.f. K. Gwet- Handbook of Inter-Rater Reliability-4th Edition, pages 221)
  ratings <- data.frame(lapply(ratings, as.character),stringsAsFactors=FALSE)
  ratings <- as.data.frame(lapply(ratings,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  ratings[,2:ncol(ratings)] <- lapply(ratings[,2:ncol(ratings)],as.numeric)
  mse.out <- mse1b.fn(ratings) #return(c(mse,Mtot,n))
  msr.out <- msr1b.fn(ratings) #return(c(msr,r))
  mse <- mse.out$mse
  Mtot <- mse.out$Mtot
  r <- msr.out$r
  msr <- msr.out$msr
  rho.zero <- c(0,0.1,0.3,0.5,0.7,0.9)
  pval <- sapply(1:6,function(x){
    fobs <- msr/(mse*(1+Mtot*rho.zero[x]/(r*(1-rho.zero[x]))))
    pvals <- 1 - pf(fobs,df1=r-1,df2=Mtot-r)
  })
  return(data.frame(rho.zero,pval))
}
#' P-value of the ICC under ANOVA Model 1B for arbitrary null values.
#'
#' This function computes the p-value associated with the Intraclass Correlation Coefficient (ICC) under the one-factor ANOVA model
#' where each rater may rate a different group of subjects.
#' @references  Gwet, K.L. (2014): \emph{Handbook of Inter-Rater Reliability - 4th ed.} chapter 8, section 8.3.5, equation
#' 8.3.8. Advanced Analytics, LLC.
#' @param ratings This is a data frame containing 3 columns or more.  The first column contains subject numbers (there could be duplicates
#' if a subject was assigned multiple ratings) and each of the remaining columns is associated with a particular rater and contains its
#' numeric ratings.
#' @param gam.zero This is an optional parameter that represents a vector containing an arbitrary number of null values between 0 and 1
#' for which a p-value will be calculated. If left unspecified, its default value will be 0.
#' @return This function returns a vector containing p-values associated with the null values specified in the parameter gam.zero.
#' @examples
#' #iccdata1 is a small dataset that comes with the package. Use it as follows:
#' library(irrICC)
#' iccdata1 #see what the iccdata1 dataset looks like
#' #Let c(0.05,0.13,0.28,0.33) be an arbitrary vector of values between 0 and 1
#' pvals.ICC1b(iccdata1,c(0.05,0.13,0.28,0.33))
#' @export
pvals.ICC1b <- function(ratings,gam.zero=0){
  #This function computes p-values either for a single rho-zero value or for a vector of values assigned to parameter gam.zero= VALUES
  #(c.f. K. Gwet- Handbook of Inter-Rater Reliability-4th Edition, pages 221)
  ratings <- data.frame(lapply(ratings, as.character),stringsAsFactors=FALSE)
  ratings <- as.data.frame(lapply(ratings,function (y) if(class(y)=="factor" ) as.character(y) else y),stringsAsFactors=F)
  ratings[,2:ncol(ratings)] <- lapply(ratings[,2:ncol(ratings)],as.numeric)
  mse.out <- mse1b.fn(ratings) #return(c(mse,Mtot,n))
  msr.out <- msr1b.fn(ratings) #return(c(msr,r))
  mse <- mse.out$mse
  Mtot <- mse.out$Mtot
  r <- msr.out$r
  n <- mse.out$n
  msr <- msr.out$msr
  rlen <- length(gam.zero)
  pval <- sapply(1:rlen,function(x){
    fobs <- msr/(mse*(1+Mtot*gam.zero[x]/(r*(1-gam.zero[x]))))
    pvals <- 1 - pf(fobs,df1=r-1,df2=Mtot-r)
  })
  return(data.frame(gam.zero,pval))
}
