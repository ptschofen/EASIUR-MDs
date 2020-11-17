setwd('C:/Users/ptsch/Documents/GitHub/EASIUR-MDs')

## Load Packages, set working directory
library(tidyverse)
library(foreign)
library(readstata13)

# Read in data, select columns of interest
easiur.mds<-read.csv('EASIUR MDs.csv')
easiur.mds<-easiur.mds[which(names(easiur.mds) %in% c('FIPS', 'PEC.Annual.Area',
                                                      'PEC.Annual.P150', 'PEC.Annual.P300',
                                                      'SO2.Annual.Area', 
                                                      'SO2.Annual.P150',
                                                      'SO2.Annual.P300', 'NOX.Annual.Area', 
                                                      'NOX.Annual.P150', 'NOX.Annual.P300',
                                                      'NH3.Annual.Area', 'NH3.Annual.P150', 
                                                      'NH3.Annual.P300'))]

pop.adj<-read.csv('EASIUR_MD_Population_adjust.csv')
pop.adj<-pop.adj[which(names(pop.adj) %in% c('FIPS', 'PEC.Annual.Area',
                                             'PEC.Annual.P150', 'PEC.Annual.P300',
                                             'SO2.Annual.Area', 
                                             'SO2.Annual.P150',
                                             'SO2.Annual.P300', 'NOX.Annual.Area', 
                                             'NOX.Annual.P150', 'NOX.Annual.P300',
                                             'NH3.Annual.Area', 'NH3.Annual.P150', 
                                             'NH3.Annual.P300'))]



# Adjust for population and mortality change according to EASIUR method suggested in SI
#### --- Plug in desired year --- ###

easiur.mds[, 2:13]<-easiur.mds[, 2:13]*pop.adj[, 2:13]^(2014-2005)

# Convert to short tons ($/tonne)*(tonne/1.10231 short tons)
easiur.mds[, 2:13]<-easiur.mds[, 2:13]/1.10231

# Adjust for different VSL Used (Easiur: $8.8M in $2010, EPA: $8.1M in $2010)
easiur.mds[, 2:13]<-easiur.mds[, 2:13]/1.0911

# Change FIPS code of Miami Dade to APEEP format
easiur.mds$FIPS[which(easiur.mds$FIPS==12086)]<-12025

# Reorder by FIPS
easiur.mds<-easiur.mds[order(easiur.mds$FIPS),]

easiur.mds.area<-easiur.mds[which(names(easiur.mds) %in% c('FIPS','NH3.Annual.Area', 
                                                           'NOX.Annual.Area', 
                                                           'PEC.Annual.Area', 'SO2.Annual.Area'))]
easiur.mds.area$easiur.assignment<-'Area'
easiur.mds.area<-easiur.mds.area[, c('FIPS', 'NH3.Annual.Area', 'NOX.Annual.Area', 'PEC.Annual.Area', 'SO2.Annual.Area', 'easiur.assignment')]
names(easiur.mds.area)<-c('FIPS', 'MD.NH3', 'MD.NOx', 'MD.PM25', 'MD.SO2', 'easiur.assignment')

easiur.mds.med150<-easiur.mds[which(names(easiur.mds) %in% c('FIPS','NH3.Annual.P150', 
                                                             'NOX.Annual.P150', 
                                                             'PEC.Annual.P150', 
                                                             'SO2.Annual.P150'))]
easiur.mds.med150$easiur.assignment<-'Med 150'
easiur.mds.med150<-easiur.mds.med150[, c('FIPS', 'NH3.Annual.P150', 'NOX.Annual.P150', 'PEC.Annual.P150', 'SO2.Annual.P150', 'easiur.assignment')]
names(easiur.mds.med150)<-c('FIPS', 'MD.NH3', 'MD.NOx', 'MD.PM25', 'MD.SO2', 'easiur.assignment')
easiur.mds.tall300<-easiur.mds[which(names(easiur.mds) %in% c('FIPS','NH3.Annual.P300', 
                                                              'NOX.Annual.P300', 
                                                              'PEC.Annual.P300', 
                                                              'SO2.Annual.P300'))]

easiur.mds.tall300$easiur.assignment<-'Tall 300'
easiur.mds.tall300<-easiur.mds.tall300[, c('FIPS', 'NH3.Annual.P300', 'NOX.Annual.P300', 'PEC.Annual.P300', 'SO2.Annual.P300', 'easiur.assignment')]
names(easiur.mds.tall300)<-c('FIPS', 'MD.NH3', 'MD.NOx', 'MD.PM25', 'MD.SO2', 'easiur.assignment')
easiur.mds.combined<-rbind(easiur.mds.area, easiur.mds.med150, easiur.mds.tall300)

# Inflate to from 2010 to 2018
#easiur.mds.combined[, 2:5]<-easiur.mds.combined[, 2:5]*1.155948
#easiur.mds.combined$easiur.assignment<-as.factor(easiur.mds.combined$easiur.assignment)
rm(easiur.mds, pop.adj, easiur.mds.area, easiur.mds.med150, easiur.mds.tall300)
