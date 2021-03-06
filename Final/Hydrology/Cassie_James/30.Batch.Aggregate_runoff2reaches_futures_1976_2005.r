
###Set directories

data.dir="/home/jc246980/Hydrology.trials/Outputs/Outputs_Futures/Qrun"
out.dir="/home/jc246980/Hydrology.trials/Aggregate_reach/Output_futures/Qrun_aggregated2reach_1976to2005/"
future.dir="/home/jc165798/Climate/CIAS/Australia/5km/monthly_csv/"

ESs=list.files(future.dir, pattern='RCP') ##this used to say �RCP85�
GCMs = list.files(paste(future.dir,pattern=ESs[1],sep=''))
ESs=ESs[1]#add this line
GCMs= GCMs[6:length(GCMs)] #add this line.


###Run loop to aggergate runoff to reach for each twelve month period
sh.dir='/home/jc246980/Freshwater_scripts/sh/Aggregate/';dir.create(sh.dir,recursive=TRUE) #dir to write sh scripts to
setwd(sh.dir)

for(es in ESs) {
for(gcm in GCMs) {

##create the sh file
zz = file(paste('30.',es,'.',gcm,'.aggregate.sh',sep=''),'w')
cat('#!/bin/bash\n',file=zz)
cat('cd $PBS_O_WORKDIR\n',file=zz)
cat("R CMD BATCH --no-save --no-restore '--args es=\"",es,"\" gcm=\"",gcm,"\" data.dir=\"",data.dir,"\" out.dir=\"",out.dir,"\" ' ~/Freshwater_scripts/Final/Hydrology/Cassie_James/30.Run.Aggregate_runoff2reaches_futures_1976_2005.r 30.",es,'.',gcm,'.Rout \n',sep='',file=zz) #run the R script in the background
close(zz)

##submit the script
system(paste('qsub -l nodes=1:ppn=12 30.',es,'.',gcm,'.aggregate.sh',sep=''))
}
}
