###################################################################################################
### scripts to prepare figures for final report


module load R-2.15.1

#Load R
#create some images

library(plotrix) 
library(SDMTools)
library(maptools)

base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') 
pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE) 
all.cols = colorRampPalette(c("#A50026","#D73027","#F46D43","#FDAE61","#FEE090","#FFFFBF","#E0F3F8","#ABD9E9","#74ADD1","#4575B4","#313695"))(21)#colorRampPalette(c('red4','orangered','gold','beige','tan','lightblue4','blue4'))(21) #define a set of colors
cols = all.cols[21:1] # blue to red
legend.pnts = cbind(c(113,114.5,114.5,113),c(-44,-44,-38,-38)) #define the location of the legend
image.dir = "/home/jc246980/Final report/Figures/"
data.dir="/home/jc246980/DrySeason/Futuredat/Quantiles_delta/"
futdir = "/home/jc165798/Climate/CIAS/Australia/5km/monthly_csv/"	
pnts=cbind(x=c(113,116,116,113), y=c(-13,-13,-18.5,-18.5))
ESs = list.files(futdir, pattern="RCP") 	
es=ESs[4]
year=2085

###################################################################################################
### Dry season figures
VOIS = c('delta_num_month', 'delta_total_severity', 'delta_max_clust_length', 'delta_fut_clust_severity', 'delta_month_max_clust')

					
				png(paste(image.dir,'Dryseason.',year,'.png',sep=''),width=dim(base.asc)[1]*2, height=dim(base.asc)[2]*3+100, units='px', pointsize=20, bg='lightgrey')
					par(mar=c(0,0,0,0),mfrow=c(5,3),cex=1,oma=c(1,3,3,0)) #define the plot parameters
					first=TRUE
					for (voi_delta in VOIS) { cat(voi_delta,'\n')	
						load(paste(data.dir,voi_delta,"_delta.Rdata",sep='')) #loads dry season metrics
						deltalim_x=round(range(outdelta)[1],1)
						deltalim_y=round(range(outdelta)[2],1)
						deltalims=c(deltalim_x,deltalim_y)
						deltamid=round(((deltalims[1]+deltalims[2])/2),1)
						deltalabs = c(paste('<',deltalims[1]),deltamid,paste('>',deltalims[2]))
						
						for (percentile in c(10,50,90)) { cat(percentile,'\n') #cycle through the percentiles
								tasc = base.asc; tasc[cbind(pos$row,pos$col)] = outdelta[,paste(es,year,percentile,sep='_')] #get the data
								tasc[which(tasc<deltalims[1])] = deltalims[1]; tasc[which(tasc>deltalims[2])] = deltalims[2] #ensure all data within limits
								image(tasc,ann=FALSE,axes=FALSE,zlim=deltalims,col=cols) #create the image
								if (percentile==10) legend.gradient(pnts,cols=cols,limits=deltalims, title='')
						}

						mtext(c('10th Percentile','50th Percentile','90th Percentile'),side=3,line=1,outer=TRUE,cex=2,at=seq(1/6,0.99,1/3))
						mtext(c('Cluster Start','Cluster Severity','Cluster Length', 'Total Severity', 'Total Length'),side=2,line=1,outer=TRUE,cex=2, at=seq(1/10, 0.99, 1/5))
					}
				dev.off() #close out the image
				
				
Drainageshape = readShapePoly('/home/jc246980/Janet_Stein_data/Drainage_division') #read in your shapefile				
				
data.dir="/home/jc246980/DrySeason/Futuredat/Quantiles_sd/"				

VOIS = c('sd_num_month', 'sd_total_severity', 'sd_max_clust_length', 'sd_fut_clust_severity', 'sd_month_max_clust')
percentile=50
pnts=cbind(x=c(113,116,116,113), y=c(-13,-13,-18.5,-18.5))


					
	png(paste(image.dir,'Dryseason_sd_',year,'.png',sep=''),width=dim(base.asc)[1]*2+30, height=dim(base.asc)[2]*3+100, units='px', pointsize=20, bg='lightgrey')
		par(mar=c(0,0,0,0),mfrow=c(3,2),cex=1,oma=c(3,3,3,0)) #define the plot parameters
		for (voi_delta in VOIS) { cat(voi_delta,'\n')	
			load(paste(data.dir,voi_delta,"_sd.Rdata",sep='')) #loads dry season metrics
			deltalim_x=round(range(outsd[,paste(es,year,percentile,sep='_')])[1],1)
			deltalim_y=round(range(outsd[,paste(es,year,percentile,sep='_')])[2],1)
			deltalims=c(deltalim_x,deltalim_y)
			deltalims=max(abs(deltalims))
			deltalims=c(deltalims*-1, deltalims)
			deltamid=round(((deltalims[1]+deltalims[2])/2),1)
			deltalabs = c(paste('<',deltalims[1]),deltamid,paste('>',deltalims[2]))

			tasc = base.asc; tasc[cbind(pos$row,pos$col)] = outsd[,paste(es,year,percentile,sep='_')] #get the data
			tasc[which(tasc<deltalims[1])] = deltalims[1]; tasc[which(tasc>deltalims[2])] = deltalims[2] #ensure all data within limits
			image(tasc,ann=FALSE,axes=FALSE,zlim=deltalims,col=cols) #create the image
			plot(Drainageshape , lwd=2, ann=FALSE,axes=FALSE, add=TRUE)
			
			if(voi_delta=="sd_num_month") {
			legend.gradient(pnts,cols=cols,limits=deltalims, title='Total Length', cex=1.5)}  	
			if(voi_delta=="sd_total_severity") {
			legend.gradient(pnts,cols=cols,limits=deltalims, title='Total Severity', cex=1.5)}
			if(voi_delta=="sd_max_clust_length") {  
			legend.gradient(pnts,cols=cols,limits=deltalims, title='Cluster length', cex=1.5)}
			if(voi_delta=="sd_fut_clust_severity") { 
			legend.gradient(pnts,cols=cols,limits=deltalims, title='Cluster Severity', cex=1.5)}
			if(voi_delta=="sd_month_max_clust") {
			legend.gradient(pnts,cols=cols,limits=deltalims, title='Cluster Start', cex=1.5)}
		}
	dev.off() #close out the image
								

								
###################################################################################################
### Temperature figures			
				
data.dir="/home/jc246980/Stability/Output/"			
vois=c("tmp", "tmn", "tmx")
pnts=cbind(x=c(113,116,116,113), y=c(-13,-13,-18.5,-18.5))

	png(paste(image.dir,'Temperature_delta_',year,'.png',sep=''),width=dim(base.asc)[1]*3+30, height=dim(base.asc)[2]*3+60, units='px', pointsize=20, bg='lightgrey')
		par(mar=c(0,0,0,0),mfrow=c(3,3),cex=1,oma=c(4,4,4,0)) #define the plot parameters
		
		for (voi in vois) { cat(voi,'\n') 
			
				outdelta=read.csv(paste(data.dir,voi,"_delta.csv", sep=''))
				# outdeltalims=outdelta[,101:103] 
				# deltalim_x=round(range(outdeltalims)[1],1)
				# deltalim_y=round(range(outdeltalims)[2],1)
				# deltalims=c(deltalim_x,deltalim_y)
				deltalims=c(1.3,6.6)
				deltamid=round(((deltalims[1]+deltalims[2])/2),1)
				deltalabs = c(paste('<',deltalims[1]),deltamid,paste('>',deltalims[2]))
				
				for (percentile in c(10,50,90)) { cat(percentile,'\n') #cycle through the percentiles
						tasc = base.asc; tasc[cbind(pos$row,pos$col)] = outdelta[,paste(es,year,percentile,sep='_')] #get the data
						tasc[which(tasc<deltalims[1])] = deltalims[1]; tasc[which(tasc>deltalims[2])] = deltalims[2] #ensure all data within limits
						image(tasc,ann=FALSE,axes=FALSE,zlim=deltalims,col=cols) #create the image
						if (percentile==10 & voi=="tmp") legend.gradient(pnts,cols=cols,limits=deltalims, cex= 2, title='')
				}

				mtext(c('10th Percentile','50th Percentile','90th Percentile'),side=3,line=1,outer=TRUE,cex=2.5,at=seq(1/6,0.99,1/3))
				mtext(c('Maximum Temperature','Minimum Temperature','Mean Temperature'),side=2,line=1,outer=TRUE,cex=2.5, at=seq(1/6,0.99,1/3))
			}
		dev.off() #close out the image
				

all.cols = colorRampPalette(c("#A50026","#D73027","#F46D43","#FDAE61","#FEE090","#FFFFBF","#E0F3F8","#ABD9E9","#74ADD1","#4575B4","#313695"))(21)#colorRampPalette(c('red4','orangered','gold','beige','tan','lightblue4','blue4'))(21) #define a set of colors
cols = all.cols[11:1] # blue to red				
percentile=50
					
	png(paste(image.dir,'Temperature_sd_',year,'.png',sep=''),width=dim(base.asc)[1]*2+30, height=dim(base.asc)[2]*2, units='px', pointsize=20, bg='lightgrey')
		par(mar=c(0,0,0,0),cex=1,oma=c(3,3,3,0)) #define the plot parameters
		  mat = matrix(c( 1,1,1,1,2,2,2,2,
						 1,1,1,1,2,2,2,2,
						 1,1,1,1,2,2,2,2,
						 1,1,1,1,2,2,2,2,
						 3,3,3,3,4,4,4,4,
						 3,3,3,3,4,4,4,4,
						 3,3,3,3,4,4,4,4,
						 3,3,3,3,4,4,4,4),nr=8,nc=8,byrow=TRUE) #create a layout matrix for images
		
			layout(mat) #call layout as defined above

		for (voi in vois) { cat(voi,'\n')	
			outsd=read.csv(paste(data.dir,voi,"_sd.csv", sep=''))
			deltalims=c(3.3, 12.3)
			deltamid=round(((deltalims[1]+deltalims[2])/2),1)
			deltalabs = c(paste(deltalims[1]),deltamid,paste(deltalims[2]))

			tasc = base.asc; tasc[cbind(pos$row,pos$col)] = outsd[,paste(es,year,percentile,sep='_')] #get the data
			tasc[which(tasc<deltalims[1])] = deltalims[1]; tasc[which(tasc>deltalims[2])] = deltalims[2] #ensure all data within limits
			image(tasc,ann=FALSE,axes=FALSE,zlim=deltalims,col=cols) #create the image
			plot(Drainageshape , lwd=2, ann=FALSE,axes=FALSE, add=TRUE)
			
			if(voi=="tmp") {
			text(120,-11,'Mean', cex=3)}  	
			if(voi=="tmn") {
			text(120,-11,'Minimum', cex=3)}
			if(voi=="tmx") {  
			text(120,-11,'Maximum', cex=3)}
			
		}
		  labs=deltalabs
		  plot(1:20,axes=FALSE,ann=FALSE,type='n')
		  text(10,18,"sd from current",cex=3)
		  color.legend(9,4,11,16,labs,rect.col=cols,align="rb",gradient="y", cex=2)
		
		
		
	dev.off() #close out the image
												

###################################################################################################
### Precipitation figures				

				
data.dir="/home/jc246980/Stability/Output/"			
voi=c("pre")

		png(paste(image.dir,'Precipitation_delta_',year,'.png',sep=''),width=dim(base.asc)[1]*1+80, height=dim(base.asc)[2]*3, units='px', pointsize=20, bg='lightgrey')
		par(mar=c(0,0,0,0),cex=1,oma=c(4,4,4,0)) #define the plot parameters

	    mat = matrix(c( 1,1,1,1,1,
						1,1,1,1,1,
						1,1,1,1,1,
						1,1,1,1,1,
						2,2,2,2,2,
						2,2,2,2,2,
						2,2,2,2,2,
						2,2,2,2,2,
						3,3,3,3,3,
						3,3,3,3,3,
						3,3,3,3,3,
						3,3,3,3,3,
						4,4,4,4,4),nr=13,nc=5,byrow=TRUE) #create a layout matrix for images
		
			layout(mat) #call layout as defined above
		
			outdelta=read.csv(paste(data.dir,voi,"_delta.csv", sep=''))
			outdeltalims=outdelta[,101:103] 
			deltalim_x=round(range(outdeltalims)[1],1)
			deltalim_y=round(range(outdeltalims)[2],1)
			deltalims=c(deltalim_x,deltalim_y)
			deltamid=round(((deltalims[1]+deltalims[2])/2),1)
			deltalabs = c(paste('<',deltalims[1]),deltamid,paste('>',deltalims[2]))
			
			for (percentile in c(10,50,90)) { cat(percentile,'\n') #cycle through the percentiles
					tasc = base.asc; tasc[cbind(pos$row,pos$col)] = outdelta[,paste(es,year,percentile,sep='_')] #get the data
					tasc[which(tasc<deltalims[1])] = deltalims[1]; tasc[which(tasc>deltalims[2])] = deltalims[2] #ensure all data within limits
					image(tasc,ann=FALSE,axes=FALSE,zlim=deltalims,col=all.cols) #create the image
					
			}
		
		    plot(1:20,axes=FALSE,ann=FALSE,type='n')
		    text(10,18,"Difference from current",cex=3)
		    color.legend(2,10,18,15,deltalabs,rect.col=all.cols,align="rb",gradient="x", cex=1.5)
		    mtext(c('10th Percentile','50th Percentile','90th Percentile'),side=2,line=1,outer=TRUE,cex=2.5,at=c(0.25, 0.56, 0.87))
			
		dev.off() #close out the image
				

				
percentile=50
outsd=read.csv(paste(data.dir,voi,"_sd.csv", sep=''))					
all.cols = colorRampPalette(c("#A50026","#D73027","#F46D43","#FDAE61","#FEE090","#FFFFBF","#E0F3F8","#ABD9E9","#74ADD1","#4575B4","#313695"))(10)
	
	
png(paste(image.dir,'Precipitation_sd_',year,'.png',sep=''),width=dim(base.asc)[1]*2+30, height=dim(base.asc)[2]*3, units='px', pointsize=20, bg='lightgrey')
		par(mar=c(0,0,0,0),cex=1,oma=c(3,3,3,0)) #define the plot parameters

			mat = matrix(c( 1,1,1,1,1,1,
							1,1,1,1,1,1,
							1,1,1,1,1,1,
							1,1,1,1,1,1,
							1,1,1,1,1,1,
							1,1,1,1,1,1),nr=7,nc=6,byrow=TRUE) #create a layout matrix for images
		
			layout(mat) #call layout as defined above
	
			# deltalim_x=round(range(outsd[,paste(es,year,percentile,sep='_')])[1],1)
			# deltalim_y=round(range(outsd[,paste(es,year,percentile,sep='_')])[2],1)
			# deltalims=c(deltalim_x,deltalim_y)
			# deltamid=round(((deltalims[1]+deltalims[2])/2),1)
			# deltalabs = c(paste('<',deltalims[1]),deltamid,paste('>',deltalims[2]))
			tasc = base.asc; tasc[cbind(pos$row,pos$col)] = outsd[,paste(es,year,percentile,sep='_')] #get the data
		
			
			zlims = c(-2.5, 2.5)
			image(tasc, ann=FALSE,axes=FALSE,col=all.cols,zlim=zlims)
			plot(Drainageshape , lwd=2, ann=FALSE,axes=FALSE, add=TRUE)
			text(130,-39.5,"sd from current",cex=4)
			labs=c(-2.5,0,2.5)
			color.legend(116,-42.5,142,-40.5,labs,rect.col=all.cols,align="rb",gradient="x", cex=3)
			

	dev.off() #close out the image
												
###################################################################################################
### Runoff delta figures

data.dir="/home/jc246980/Stability/Output/"			
voi=c("Runoff")
all.cols = colorRampPalette(c("#A50026","#D73027","#F46D43","#FDAE61","#FFFFBF","#E0F3F8","#ABD9E9","#74ADD1","#4575B4","#313695"))(6)
#all.cols=colorRampPalette(c("#A50026","#F46D43","#FDAE61", "#FEE090", "#FFFFBF","#ABD9E9","#4575B4"))(6)

	png(paste(image.dir,'Runoff_delta_',year,'.png',sep=''),width=dim(base.asc)[1]*1+80, height=dim(base.asc)[2]*3, units='px', pointsize=20, bg='lightgrey')
		par(mar=c(0,0,0,0),cex=1,oma=c(4,5,4,0)) #define the plot parameters
		
	    mat = matrix(c( 1,1,1,1,1,
						1,1,1,1,1,
						1,1,1,1,1,
						1,1,1,1,1,
						2,2,2,2,2,
						2,2,2,2,2,
						2,2,2,2,2,
						2,2,2,2,2,
						3,3,3,3,3,
						3,3,3,3,3,
						3,3,3,3,3,
						3,3,3,3,3,
						4,4,4,4,4),nr=13,nc=5,byrow=TRUE) #create a layout matrix for images
		
				layout(mat) #call layout as defined above
				
				outdelta=read.csv(paste(data.dir,voi,"_delta.csv", sep=''))
				outdeltalims=outdelta[,101:103] 
				
				for (percentile in c(10,50,90)) { cat(percentile,'\n') #cycle through the percentiles
					tasc = base.asc; tasc[cbind(pos$row,pos$col)] = outdelta[,paste(es,year,percentile,sep='_')] #get the data						
					tasc[which(tasc<=0.25)] = 0.01
					tasc[which(tasc<=0.5 & tasc>0.25)] = 0.02
					tasc[which(tasc>0.5 & tasc<=1)] = 0.03
					tasc[which(tasc>1 & tasc<=2)] = 0.04
					tasc[which(tasc>2 & tasc<=4)] = 0.05
					tasc[which(tasc>=4)] = 0.06
					zlims = range(c(0,as.vector(tasc)),na.rm=TRUE)
					image(tasc, ann=FALSE,axes=FALSE,col=all.cols,zlim=zlims)
					plot(Drainageshape , lwd=2, ann=FALSE,axes=FALSE, add=TRUE)
				}

				  labs=c("<0.25","0.5","1","2",">4")
				  plot(1:20,axes=FALSE,ann=FALSE,type='n')
				  text(10,18,"Difference from current",cex=3)
				  color.legend(2,10,18,15,labs,rect.col=all.cols,align="rb",gradient="x", cex=1.5)
				  mtext(c('90th Percentile','50th Percentile','10th Percentile'),side=2,line=1,outer=TRUE,cex=2.5,at=c(0.25, 0.55, 0.87))

		dev.off() #close out the image
				


												














