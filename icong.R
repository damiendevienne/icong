require(ape)

##################################################################
##                                                              ##
##           ICONG index for rooted and unrooted trees          ##
##          If you use this code and Icong please cite:         ##
##     de Vienne D.M., Giraud, T. and Martin, O.C. 2007.        ##
##    A Congruence Index for Testing Topological Similarity     ##
##      between Trees. Bioinformatics 23 (23): 3119-3124.       ##
##                                                              ##
## - Note that the unrooted version of Icong is not             ##
##   published yet.                                             ##
##                                                              ##
##                                                              ##
## - Note that if you use the ICONG.R function for unrooted     ##
##   trees, or the ICONG.U function for rooted trees, the       ##
##   results will be INCORECT.                                  ##
##                                                              ##
## - IMPORTANT: this code depends on the use of PAUP*. It is    ##
##   provided with a precompiled version. You can get your own  ##
##   one if needed here: http://paup.sc.fsu.edu/                ## 
##                                                              ##
##################################################################

MAST<-function(t1,t2) {
    ##random name for file
    randname<-paste(sample(c(letters, LETTERS,0:9), 10, replace=TRUE),collapse="")
    infile<-paste(randname, ".nex", sep="")
    outfile<-paste(randname, ".out", sep="")
    trashfile<-paste(randname, ".trash", sep="")
    exec.agree<-function(t1,t2, infi, outfi,trashfi) {
        ##we must create a temp file with a unique name
        write.nexus(t1,t2,file=infile)
        cat(paste("BEGIN PAUP;\nAgree /all=sets showtree=no treefile=",outfi,";\nEND;\n",sep=""),file=infi, append=TRUE)
        system(paste("./paup -n ",infi," -u > ",trashfi,sep=""))
        system(paste("rm ",infi,sep=""))
       system(paste("rm ",trashfi,sep=""))
    }
    step1<-exec.agree(t1,t2,infile, outfile, trashfile)
    a<-read.nexus(outfile)
    system(paste("rm ",outfile, sep=""))
    if (class(a)=="multiPhylo") MASTsize<-Ntip(a[[1]])
    else MASTsize<-Ntip(a)
    return(list(size=MASTsize,trees=a))
}
#FOR ROOTED TREES
ICONG.R<-function(t1,t2) {
    N<-Ntip(t1)
    mast<-MAST(t1,t2)
    ncobs<-mast$size
    print(ncobs)
    ncbar = -0.11+1.48*sqrt(N)
    signc = 0.159 + 0.232*log(N)
    f <- function(u) {2.96*exp(1.9*u)}
    uobs  = (ncbar-ncobs)/signc
    icong = ncobs/ncbar
    pval = integrate(f, lower=-Inf, upper=uobs)$value
    return(list(Icong=icong, Pval = pval, trees=write.tree(mast$trees)))
}
#FOR UNROOTED TREES
ICONG.U<-function(t1,t2) {
    #make sure that trees are unrooted by re-unrooting them
    t1<-unroot(t1)
    t2<-unroot(t2)
    N<-Ntip(t1)
    mast<-MAST(t1,t2)
    ncobs<-mast$size
    print(ncobs)
    ncbar = 0.05645+1.75706*sqrt(N)
    signc = 0.1648 + 0.1992*log(N)
    f <- function(u) {1.381265*exp(1.560*u)}
    uobs  = (ncbar-ncobs)/signc
    icong = ncobs/ncbar
    pval = integrate(f, lower=-Inf, upper=uobs)$value
    return(list(Icong=icong, Pval = pval, trees=write.tree(mast$trees)))
}
ICONG<-function(t1,t2,type) {
    if (type=="rooted") res<-ICONG.R(t1,t2)
    else res<-ICONG.U(t1,t2)
    return(res)
}
##to check tree compatibility first.
CHECKTREES<-function(t1,t2) {
    resu <- list()
    resu$msg<-list()
    lab1<-t1$tip.label
    lab2<-t2$tip.label
    if (!is.binary(t1)) resu$msg<-c(resu$msg, "Tree 1 is not binary.")
    if (!is.binary(t2)) resu$msg<-c(resu$msg, "Tree 2 is not binary.")
    if (length(lab1)!=length(lab2)) resu$msg<-c(resu$msg, "The number of labels differs in the two trees.")
    if (sum(duplicated(lab1))>0) resu$msg<-c(resu$msg,"Some tip labels in tree 1 are duplicated.")
    if (sum(duplicated(lab2))>0) resu$msg<-c(resu$msg,"Some tip labels in tree 2 are duplicated.")
    if (sum(sum(!is.element(lab2,lab1)),sum(!is.element(lab1,lab2)))>0) resu$msg<-c(resu$msg,"Some tip labels are not present in both trees.")
    if (length(resu$msg)==0) resu$res<-"ok"
    else resu$res<-"err"
    return(resu)
}

##create a function to deal with all possible problems
ReadAndDo<-function(text1,text2, type) {
    #read the text trees and check that everythiong is ok. If not it returns a message explaining it. 
    #if yest it computes ICONG
    #if icong NOT ok it returns why
    #if Icong OK, it returns Icong and Pval AND also the MAST tree(s)
    t1<-read.tree(text=text1)
    t2<-read.tree(text=text2)
    if (is.null(t1)||is.null(t2)) {
        res<-list(res="ERR",rest1=is.null(t1),rest2=is.null(t2))
    }
    else {
        test<-CHECKTREES(t1,t2)
        if (test[[1]]=="err") {

        }
        else {
            res<-ICONG(t1,t2,type)
        }
    }

    return(res)
}

#ReadAndDo(input[[1]], input[[2]],input[[3]])

