# vector with numbers
x<-c(1,2,3)
(x<-c(1,2,3))
# vector with letters
(y<-c("a","b","c"))
# vector with logicals
(z1<-c(TRUE,TRUE,FALSE))
(z2<-c(T,T,F)) # same

# vector type
class(x)
class(y)
class(z1)

# skodum hvad er til i vinnusvaedinu
ls()
# fjarlaegjum hlut ur vinnusvaedi
rm(x)
ls()

######################################
# nokkrar gagnlegar skipanir

# buum til vigra
(x1<-seq(1,10))
# sama
(x1<-1:10)
(x2<-seq(0,1,length=10))

rep(1,10)
rep(c(1,2,3),2)
rep(c(1,2,3),each=2)

# lengd vigurs
length(x1)

(x3<-c(6,3,8,9,4))
# rada stokum eftir rod
sort(x3)
# hvar i staerdarrod er stakid
rank(x3)
# skilar visi a staerdarrod
order(x3)

# sameina vigra
c(x1,x2)
cbind(x1,x2)
rbind(x1,x2)

######################################
# visun i vigra
x4<-c(4,7,5,3,4,8,9)
# na i fyrsta stak i vigrinum x4
x4[1]
# na i fyrsta og annad stak
x4[c(1,4)]
# notum skilyrdi til ad velja stok
x4[x4>=7]
# visar sem uppfylla skilyrdi
which(x4>=7)
which(x4!=3)   # != ekki jafnt og
which(x4==3)   # != ekki jafnt og

# na i oll stok nema thad fyrsta
x4[-1]
# ma i oll stok nema fyrsta og annad
x4[-c(1,2)]

######################################
# endurteknigarreglan - VARUD

(y1<-c(1,2,3,4))
(y2<-c(1,2,3))
(y3<-c(1,2))

y1+y2
y1+y3   #!
y1 + 1

y1*2
y1*y2
y1*y3  #!

######################################
# fylki

(X<-matrix(1:10,ncol=2,byrow=T))
(Y<-matrix(1:10,ncol=2,byrow=F))
# visa i stak i fylki
X[1,2]
# na i annan dalk
X[,2]
# na i thridju rodina
X[3,]
# staerd fylkis
dim(X)
# getum gefum dalkum og rodum i fylkinu nafn
rownames(Y)<-c("ry1","ry2","ry3","ry4","ry5")
colnames(Y)<-c("dy1","dy2")
Y
# tha er haegt ad visa i eftir nafni
Y["ry2","dy2"]

# fylki bylt
t(X)
# stakvis margfoldun
X*Y
# hefdbundin fylkjamargfoldun
X%*%t(Y)

(Z<-matrix(1:4,ncol=2))
# akvedan
det(Z)
# andhverfan
solve(Z)
