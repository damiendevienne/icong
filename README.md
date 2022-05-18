# ICONG (congruence index)

## About
Here is the code for computing the Icong index as described in these articles: 

*  de Vienne, Damien M; Giraud, Tatiana; Martin, Olivier C; ",A congruence index for testing topological similarity between trees,Bioinformatics,23,23,3119-3124,2007,Oxford University Press

* de Vienne, Damien M; Giraud, Tatiana; Martin, Olivier C; ",In response to comment on ‘A congruence index for testing topological similarity between trees’,Bioinformatics,25,1,150-151,2009,Oxford University Press




Please, cite at least the first one if you use Icong in a publication. 


## Tuto

* Download and unpack the zip of the current repo: [click here for example](https://github.com/damiendevienne/icong/archive/refs/heads/main.zip)
* open a terminal and go to the location where you unpacked it (`cd icong-main/`)
* open R by typing `R` at the prompt.
* Install the package `ape` by typing `install.packages("ape")`
* source the code by typing `source("icong.R")`
* read your trees from external files as follows:
```r
    t1<-read.tree("your-file-with-tree-1")
    t2<-read.tree("your-file-with-tree-2")
```
* Compute Icong:
```r
icong<-ICONG.R(t1, t2) 
```


## More 
### PAUP*
Icong relies on the program PAUP* for the computation of the Maximum Agreement SubTree (MAST) between the two trees compared. Thye current repo contains a version of this program (`paup`) precompiled for linux. If you need other version (you use other OS) you can get it here : [http://phylosolutions.com/paup-test/](http://phylosolutions.com/paup-test/). 

Note that the R script that calls PAUP* considers that is is launched by typing `paup` in a console. 

### Unrooted trees

You you will see that some functions in the `icong.R` file are unrooted trees. Note that this works but has not yet been published (and may not be...)

## Problems

You can always try to send me an email (damien.de-vienne@univ-lyon1.fr) if you have any question. But keep in mind that this work was published in 2007!! 
