# Calculating LiDAR features for Metsahallitus
# Checking duplicates in list of sample plots

library(foreign)

# reading plot information regarding LiDAR data
if (Sys.info()['sysname']=="Windows") {
  sp.data.las <- read.dbf("../koealat/refkoealat/refkoealat_lidar.dbf",as.is=T)
} else {
  sp.data.las <- read.dbf("/work/users/L1320/MH_tulkinta/refkoealat/refkoealat_lidar.dbf",as.is=T)
}
sp.data.las <- sp.data.las[sp.data.las$hyvaksytty==1,]
# renaming columns of coordinates
names(sp.data.las)[grep("^I$|^P$",names(sp.data.las))] <- c("x","y")
# creating unique identifiers based on coordinates and acquisition date
sp.data.las$plotid <- paste(sprintf("%.2f",sp.data.las$x),sprintf("%.2f",sp.data.las$y),sp.data.las$vuosi,sep="_")
sp.data.las$plotid2 <- paste(sprintf("%.2f",sp.data.las$x),sprintf("%.2f",sp.data.las$y),sp.data.las$vuosi,sp.data.las$lid_vuodet,sep="_")
sp.data.las$plotid3 <- paste(sprintf("%.2f",sp.data.las$x),sprintf("%.2f",sp.data.las$y),sp.data.las$lid_vuodet,sep="_")

sum(duplicated(sp.data.las$plotid))
sum(duplicated(sp.data.las$plotid2))
sum(duplicated(sp.data.las$plotid3))

tmp <- sp.data.las[duplicated(sp.data.las[c("x","y","vuosi")]) | duplicated(sp.data.las[c("x","y","vuosi")],fromLast=T),]
tmp <- tmp[order(tmp$x,tmp$y),]

tmp2 <- sp.data.las[duplicated(sp.data.las[c("x","y","vuosi","lid_vuodet")]) | duplicated(sp.data.las[c("x","y","vuosi","lid_vuodet")],fromLast=T),]
tmp2 <- tmp2[order(tmp2$x,tmp2$y),]

tmp3 <- sp.data.las[duplicated(sp.data.las[c("x","y","lid_vuodet")]) | duplicated(sp.data.las[c("x","y","lid_vuodet")],fromLast=T),]
tmp3 <- tmp3[order(tmp3$x,tmp3$y),]

tmp3[!row.names(tmp3)%in%row.names(tmp),]
tmp3[tmp3$plotid3%in%tmp3$plotid3[!row.names(tmp3)%in%row.names(tmp)],]

identical(row.names(tmp),row.names(tmp2))

