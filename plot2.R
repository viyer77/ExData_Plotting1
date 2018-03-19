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
png(filename="plot2.png",width=480,height=480)

#plot chart

plot(Feb_2_3_power$DateTime2,Feb_2_3_power$Global_active_power, type="n", xlab=" ", ylab="Global Active Power (kilowatts)")

lines(Feb_2_3_power$DateTime2,Feb_2_3_power$Global_active_power)

#close png device
dev.off()