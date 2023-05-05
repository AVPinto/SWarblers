###Use Seqouia on Seychelles Warbler data

##check for install and load packages

install.packages('rlang')
library(rlang)

if (!is_installed("devtools"))
{ install.packages(devtools)}

if (!is_installed("dplyr"))
{ install.packages(dplyr)}
      
if (!is_installed("stringr"))
{ install.packages(stringr)}

if (!is_installed("data.table"))
{ install.packages(data.table)}

if (!is_installed("igraph"))
{ install.packages(igraph)}              
              
if (!is_installed("devtools"))
{ install.packages(devtools)} 
                      
if (!is_installed("sequoia"))
{ install.packages(sequoia)} 
                          
library(dplyr)
library(stringr)
library(data.table)
library(igraph)
library(devtools)
library(sequoia)

##load in data from csv in folder

##load pedigree output from masterbayes
masterped <- read.csv('Ped_Merged_AMS_NTerr_120819.csv')
head(masterped)
##drop unnecessary columns
masterped <- masterped[-c(4:6)]

##load sex determinations
birdsex <- read.csv('Sex_determinations_2023-02-15.csv')
head(birdsex)
##drop unnecessary columns
birdsex <- birdsex[-c(1,4:11)]
##rename for merging
colnames(birdsex) <- c("id","sex")

#merge dataframes
joinedbirds <- inner_join(masterped,birdsex,by = "id", multiple = "any")
head(joinedbirds, 20)

#load birth years
birthyears <- read.csv('Databaseoutput2017-2022_Individuals.csv')
birthyears <- birthyears[-c(2,4)]
colnames(birthyears) <- c('id','BirthYear')
head(birthyears)

##add create life history
WarblerLifeHistory <- inner_join(joinedbirds,birthyears, by = "id", multiple = "any")
WarblerLifeHistory <- WarblerLifeHistory[-c(2,3)]
head(WarblerLifeHistory)

#make simulated genotype data
simSNP <-SimGeno(joinedbirds)

##do parentage assignment
parentsout <- sequoia(GenoM = simSNP,
                      LifeHistData = WarblerLifeHistory,
                      Module = 'par')

head(parentsout)
parentsout$PedigreePar
SummarySeq(parentsout)

maybeparents <- GetMaybeRel(GenoM = simSNP,
                            LifeHistData = WarblerLifeHistory,
                            Module = 'par')

