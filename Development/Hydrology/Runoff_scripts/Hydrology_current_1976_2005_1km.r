####################################################################################
##### run Budyko code simply providing matrix 12xn where columns represent 12 months -- static analysis at 1km using 5km PAWHC
base.asc='/home/jc165798/Climate/CIAS/Australia/1km/baseline.76to05/base.asc.gz'
pos='/home/jc165798/Climate/CIAS/Australia/1km/baseline.76to05/base.positions.csv'
tmin='/home/jc165798/Climate/CIAS/Australia/1km/baseline.76to05/monthly.tmin.csv'
tmax='/home/jc165798/Climate/CIAS/Australia/1km/baseline.76to05/monthly.tmax.csv'
pr='/home/jc165798/Climate/CIAS/Australia/1km/baseline.76to05/monthly.pr.csv'
outname='current_1km'

library(SDMTools) #load the necessary library
dyn.load('/home/jc165798/SCRIPTS/sdmcode/R_development/hydrology/Budyko.so') #load the C code

###set directories
wd = '/home/jc165798/working/NARP_hydro/'; setwd(wd) #deifne and set the working directory

####read in all necessary inputs
base.asc = read.asc.gz(base.asc) #read in the base asc file
pos = read.csv(pos,as.is=TRUE)
pos$PAWHC = extract.data(cbind(pos$lon,pos$lat),read.asc('inputs/PAWHC_5km.asc')) #append data to pos
pos$PAWHC[which(is.na(pos$PAWHC))] = mean(pos$PAWHC,na.rm=TRUE) #set missing data to mean values
pos$kRs = extract.data(cbind(pos$lon,pos$lat),read.asc('inputs/kRs_5km.asc'))
pos$kRs[which(is.na(pos$kRs))] = 0.16 #set missing data to 0.16
pos$DEM = extract.data(cbind(pos$lon,pos$lat),read.asc('inputs/dem_36sec.asc'))

if (outname=='current_1km') {
	tmin = read.csv(tmin,as.is=TRUE)[,-c(1:2)] #read in monthly tmin
	tmax = read.csv(tmax,as.is=TRUE)[,-c(1:2)] #read in monthly tmax
	pr = read.csv(pr,as.is=TRUE)[,-c(1:2)] #read in precipitatation
} else {
	tmin = read.csv(tmin,as.is=TRUE) #read in monthly tmin
	tmax = read.csv(tmax,as.is=TRUE) #read in monthly tmax
	pr = read.csv(pr,as.is=TRUE) #read in precipitatation
}

###run the analysis and write out data
tt = .Call('BudykoBucketModelStatic',
	pos$DEM, #dem info
	as.matrix(pr), # monthly precip
	as.matrix(tmin), #monthly tmin
	as.matrix(tmax), #monthly tmax
	pos$PAWHC, #soil water holding capacity
	pos$kRs, #unknown kRs values 
	pos$lat / (180/pi), #latitudes in radians
	nrow(pr) #number of rows that need run
)

summary(as.vector(tt[[1]]))
summary(as.vector(tt[[2]]))
summary(as.vector(tt[[3]]))
summary(as.vector(tt[[4]]))

wd='/home/jc246980/Hydrology.trials/Output_1976_2005_1km';setwd(wd)

Eact = tt[[1]]; save(Eact, file=paste('Eact.',outname,'.Rdata',sep='')) #save the actual evapotranspiration
Epot = tt[[2]]; save(Epot, file=paste('Epot.',outname,'.Rdata',sep='')) #save the potential evapotranspiration
Qrun = tt[[3]]; save(Qrun, file=paste('Qrun.',outname,'.Rdata',sep='')) #save the runoff
Rnet = tt[[4]]; save(Rnet, file=paste('Rnet.',outname,'.Rdata',sep='')) #save the net radiation