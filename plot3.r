# PACKAGE REQUIREMENT FOR FIRST TIME USE----------------------------------
##install.packages("ggplot2")

# DATA IMPORT-------------------------------------------------------------
##setting dates of interest
startDate<-as.Date("2007-02-01", format="%Y-%m-%d")
endDate<-as.Date("2007-02-02", format="%Y-%m-%d")

##initializing data frame
febData<-data.frame(Date=numeric(), Time=numeric(), Global_active_power=numeric(), Global_reactive_power=numeric(), Voltage=numeric(), Global_intensity=numeric(), Sub_metering_1=numeric(), Sub_metering_2=numeric(), Sub_metering_3=numeric())

##iterating through rows to import relevant data
for(i in 66636:69520){
  ##single row read
  rowData<-read.table("household_power_consumption.txt", header = FALSE, sep = ";", na.strings = "?", nrows= 1, skip = i)
  ##extract date of row data
  date<-as.Date(paste(rowData[[1]],rowData[[2]],sep=":"), format="%d/%m/%Y:%H:%M:%S")
  rowData[[1]]<-as.Date(rowData[[1]], format="%d/%m/%Y")
  ##import data into data frame if within relevant date range
  if(date>=startDate & date<=endDate){
    febData<-rbind(febData,rowData)
  }
}
##display data for review
colnames(febData)<-c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
View(febData)
rm(startDate,endDate,i,rowData,date)



# PLOT3----------------------------------------------------------
library(ggplot2)

##Setting date format
febData$parsedDate<-as.POSIXct(paste(febData$Date, febData$Time, sep = " "), format="%Y-%m-%d %H:%M:%S")

##Initializing dataframe for new format with submetering data as individual data points
dataLength<-length(febData$Time) ##number of data points in original set
index<-c(rep(x="Sub_metering_1",times=dataLength),rep(x="Sub_metering_2",times=dataLength),rep(x="Sub_metering_3",times=dataLength)) ##create a list of grouping id's
subMeteringDataTotal<-data.frame(Date=c(febData$parsedDate,febData$parsedDate,febData$parsedDate), submetering=c(febData$Sub_metering_1,febData$Sub_metering_2,febData$Sub_metering_3), index=index)
rm(dataLength,index)

##plot 3 with subMeteringData, grouped by 1, 2, or 3. Points connected by a line. No graph title. No x-axis title, y-axis title of "Energy sub metering"
plot3 <- ggplot(data=subMeteringDataTotal, aes(x=Date, y=submetering, group=index, col=index)) +geom_line() +xlab("") +ylab("Energy sub metering") +theme(legend.title=element_blank(), legend.position=c(1,1), legend.justification=c(1,1)) +scale_x_datetime(breaks=date_breaks("1 day"), labels=date_format("%a"))
ggsave(filename="plot3.png", plot=plot3, width=6, height=6, units="in",  dpi=80) ##save plot3 to file with name 480 pixels