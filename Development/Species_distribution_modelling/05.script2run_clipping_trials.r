#### First current 1990 clip data to realised distributions and save out
#### C.James 	
	
################################################################################
###get the command line arguements
args=(commandArgs(TRUE)); for(i in 1:length(args)) { eval(parse(text=args[[i]])) } #evaluate the arguments

################################################################################


load('/home/jc148322/NARPfreshwater/SDM/clip.Rdata') #load position data of segmentNo and regions. object called clip.
load('/home/jc148322/NARPfreshwater/SDM/connectivity.file.Rdata') #load position data of segmentNo and connected 'sub-graphs

clipping_action=read.csv("/home/jc246980/SDM/Fish_clipping_actions.csv")

distdata=read.csv(paste(work.dir,spp,"/output/potential/current_1990.csv",sep='')) #load the potential distribution current distribution
cois=c(2,3) #limit current distribution to SegNo, Current
distdata=distdata[,cois]; colnames(distdata)=c('SegmentNo',spp)

thresdir = paste(work.dir,"/",spp,'/',sep='')
threshold = read.csv(paste(thresdir,'output/maxentResults.csv',sep=''))#; threshold = threshold[which(threshold$Species==spp),]
threshold = threshold$Equate.entropy.of.thresholded.and.original.distributions.logistic.threshold[1] #extract the species threshold value	

distdata[which(distdata[,2]<=threshold),2]=0 #clip anything below threshold to 0
occur=read.csv(paste(work.dir,spp,'/occur.csv', sep=''),as.is=T) #load occurrence data

clip.species=clipping_action[which(clipping_action$Species==spp),]
clip.column=colnames(clip.species)[which(clip.species=="1"]

regions2subtract=clipping_action[which(clipping_action$Species==spp),3]
regions2subtract=as.character(regions2subtract)
regions2subtract=as.data.frame(strsplit(regions2subtract, ",")[[1]])
colnames(regions2subtract)="minuses"
regions2subtract=as.numeric(levels(regions2subtract$minuses))[regions2subtract$minuses]

regions2add=clipping_action[which(clipping_action$Species==spp),4]
regions2add=as.character(regions2add)
regions2add=as.data.frame(strsplit(regions2add, ",")[[1]])
colnames(regions2add)="additions"
regions2add=as.numeric(levels(regions2add$additions))[regions2add$additions]

regions=unique(clip[which(clip$SegmentNo %in% occur$lat),clip.column])#find the regions in which species has been observed - this will be fish provinces for fish, and level 2 basins for other taxa. Remember that occur$lat is actually SegmentNo
regions=c(regions, regions2add, -regions2subtract)
regions=regions[!is.na(regions)]


SegmentNo=clip$SegmentNo[which(clip[,clip.column] %in% regions)] #find the segment nos within those regions
distdata[which(!(distdata[,'SegmentNo'] %in% SegmentNo)),spp]=0 #apply the clip
colnames(distdata)=c('SegmentNo','Current')
save(distdata,file=paste(out,"/",spp,'.cur.real.mat.Rdata',sep='')); rm(distdata); gc() #write out the data		
	
