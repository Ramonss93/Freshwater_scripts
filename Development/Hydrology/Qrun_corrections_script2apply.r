####################################################################################
#Script to apply corrections to futures
#drafted by Cassie james 
#GNU General Public License .. feel free to use / distribute ... no warranties
####################################################################################
library(SDMTools) #load the necessary library

#### set directories
wd = '/home/jc165798/working/NARP_hydro/'; setwd(wd) #define and set the working directory
cur.dir='/home/jc246980/Hydrology.trials/Outputs/Output_1976_2005/'
cur.dir.1960='/home/jc246980/Hydrology.trials/Outputs/Output_1960_1990/'
data.dir='/home/jc246980/Hydrology.trials/Outputs/Outputs_Futures/Qrun/'
out.dir='/home/jc246980/Hydrology.trials/Outputs/Outputs_Futures/Qrun_corrected_1976_2005/'
future.dir="/home/jc165798/Climate/CIAS/Australia/5km/monthly_csv/"

ESs=list.files(future.dir, pattern='RCP')
GCMs = list.files(paste(future.dir,pattern=ESs[1],sep=''))
YEARs=seq(2015, 2085,10)
yois=1976:2005
tt = expand.grid(sprintf('%02i',1:12),yois=yois);tt = paste(tt[,1],tt[,2],sep='_')

#### Load runoff data run using dynamic model for 1976:2005 and calculate 30 year means
load(paste(cur.dir,'Q_run_30yearagg_dynamic.Rdata',sep=''))
Qrun_agg=Qrun; 
colnames(Qrun_agg) = tt #add the column names

Qrun_agg_mean=NULL


    for (mm in 1:12) { cat(mm,'\n') #cycle through each of the months

	   tdata_curmean = rowMeans(Qrun_agg[,which(as.numeric(substr(colnames(Qrun_agg),1,2))==mm)],na.rm=TRUE) #calculate row mean
	   Qrun_agg_mean=cbind(Qrun_agg_mean,tdata_curmean)

    }

tt = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');colnames(Qrun_agg_mean)= tt

#### Load runoff data run using dynamic model for 1960:1990 and calculate 30 year means

load(paste(cur.dir.1960,'Q_run_30yearagg_dynamic_1960.Rdata',sep=''))
Qrun_agg_1960=Qrun; 
colnames(Qrun_agg_1960) = tt #add the column names

Qrun_agg_mean_1960=NULL


    for (mm in 1:12) { cat(mm,'\n') #cycle through each of the months

	   tdata_curmean = rowMeans(Qrun_agg_1960[,which(as.numeric(substr(colnames(Qrun_agg_1960),1,2))==mm)],na.rm=TRUE) #calculate row mean
	   Qrun_agg_mean_1960=cbind(Qrun_agg_mean_1960,tdata_curmean)

    }

tt = c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');colnames(Qrun_agg_mean_1960)= tt

#### load current runoff data determined on 30 year averages 1976_2005

load(paste(cur.dir,'TomHarwood_data/','Qrun.current_5km_means.Rdata',sep='')) 
Qrun_cur=Qrun; 
colnames(Qrun_cur) = tt #add the column names
mm=c('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')




#### apply corrections to futures based on patterns observed in aggregated runoff data for 1976_2005

	for(es in ESs) { 
	
		for(gcm in GCMs) {
		
			load(paste(data.dir,es,"_",gcm,".Rdata",sep=''))
			tt = expand.grid(mm,YEARs=YEARs);tt = paste(tt[,2],tt[,1],sep='_'); colnames(Qrun) = tt #add the column names
			Qrun_corrected=NULL
			
			for (yy in YEARs) {
				
				futdata=Qrun[,grep(yy,colnames(Qrun))]
				tdata=((futdata+1)/(Qrun_cur+1))*(Qrun_agg_mean+1)
				Qrun_corrected=cbind(Qrun_corrected, tdata)
				
			}	
			tt = expand.grid(mm,YEARs=YEARs);tt = paste(tt[,2],tt[,1],sep='_'); colnames(Qrun_corrected) = tt #add the column names
			save(Qrun_corrected, file=paste(out.dir,es,"_",gcm,".Rdata",sep='')) #save the runoff			
				
		}		
	}			
				
				
#### apply corrections to futures based on patterns observed in aggregated runoff data for 1960_1990

	for(es in ESs) { 
	
		for(gcm in GCMs) {
		
			load(paste(data.dir,es,"_",gcm,".Rdata",sep=''))
			tt = expand.grid(mm,YEARs=YEARs);tt = paste(tt[,2],tt[,1],sep='_'); colnames(Qrun) = tt #add the column names
			Qrun_corrected_1960=NULL
			
			for (yy in YEARs) {
				
				futdata=Qrun[,grep(yy,colnames(Qrun))]
				tdata=((futdata+1)/(Qrun_cur+1))*(Qrun_agg_mean_1960+1)
				Qrun_corrected_1960=cbind(Qrun_corrected_1960, tdata)
				
			}	
			tt = expand.grid(mm,YEARs=YEARs);tt = paste(tt[,2],tt[,1],sep='_'); colnames(Qrun_corrected) = tt #add the column names
			save(Qrun_corrected, file=paste(out.dir,es,"_",gcm,".Rdata",sep='')) #save the runoff			
				
		}		
	}						
				
				
				