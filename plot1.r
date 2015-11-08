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


# PLOT1----------------------------------------------------------
library(ggplot2)
plot1 <- qplot(Global_active_power,data=febData,ylab="Frequency",xlab="Global Active Power (kilowatts)",main="Global Active Power", binwidth = 0.5)
ggsave(filename="plot1.png", plot=plot1, width=6, height=6, units="in",  dpi=80) ##save plot1 to file with name 480 pixels