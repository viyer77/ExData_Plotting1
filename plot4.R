# create a temporary directory
td = tempdir()

#url to download
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# create the placeholder file
tf = tempfile(tmpdir=td, fileext=".zip")

# download into the placeholder file
download.file(url, tf)

# get the name of the first file in the zip archive
fname = unzip(tf, list=TRUE)$Name[1]

# unzip the file to the temporary directory
unzip(tf, files=fname, exdir=td, overwrite=TRUE)

# fpath is the full path to the extracted file
fpath = file.path(td, fname)

# read csv file
d = read.csv(fpath, header=TRUE,sep=";",
             stringsAsFactors=FALSE)

# Convert to Date class
d$Date2 <- as.Date(as.character(d$Date),"%d/%m/%Y")

# subset for Feb 2 and 3 values
Feb_2_3_power <- d[ which (d$Date2 == as.Date("2007-02-01") | d$Date2 == as.Date("2007-02-02") ),]

# Add Date time

Feb_2_3_power$DateTime2 <- strptime(paste(Feb_2_3_power$Date,Feb_2_3_power$Time,sep=" "),"%d/%m/%Y %H:%M:%S")

# open png device
png(filename="plot4.png",width=480,height=480)

#plot chart


par(mfrow=c(2,2))

plot(Feb_2_3_power$DateTime2,Feb_2_3_power$Global_active_power, type="n", xlab=" ", ylab="Global Active Power")

lines(Feb_2_3_power$DateTime2,Feb_2_3_power$Global_active_power)

plot(Feb_2_3_power$DateTime2,Feb_2_3_power$Voltage,type="n",xlab="datetime",ylab="Voltage")

lines(Feb_2_3_power$DateTime2,Feb_2_3_power$Voltage)

plot(Feb_2_3_power$DateTime2,Feb_2_3_power$Sub_metering_1,type="n",xlab=" ",ylab="Energy sub metering",ylim=c(0,40))
lines(Feb_2_3_power$DateTime2,Feb_2_3_power$Sub_metering_1,col="black")
lines(Feb_2_3_power$DateTime2,Feb_2_3_power$Sub_metering_2,col="red")
lines(Feb_2_3_power$DateTime2,Feb_2_3_power$Sub_metering_3,col="blue")
legend("topright",col=c("black","blue","red"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty = 1)

plot(Feb_2_3_power$DateTime2,Feb_2_3_power$Global_reactive_power,type="n",xlab="datetime",ylab="Global_reactive_power")
lines(Feb_2_3_power$DateTime2,Feb_2_3_power$Global_reactive_power)

#close png device
dev.off()