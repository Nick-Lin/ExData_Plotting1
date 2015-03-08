## Filter records needed for course assignment to a temporary file, then read it in as a data frame
conx1 <- file("./household_power_consumption.txt", "r")
conx2 <- file("./household_power_consumption_filtered.txt", "w")
writeLines(readLines(conx1, n=1), conx2) ## Output header
tag <- c("^[12]/2/2007") ##Filtering condition
repeat {
	reg <- readLines(conx1, n=1)    
	if (length(reg) == 0) break
	if (regexec(tag, reg) < 1) next
	writeLines(reg, conx2)
}
close(conx1);close(conx2)

hpcData <- read.table("./household_power_consumption_filtered.txt", header=TRUE, sep=";", na.strings="?", as.is=TRUE)
hpcData$datetime <- strptime(paste(hpcData$Date,hpcData$Time), "%d/%m/%Y %H:%M:%S") ## Date/Time conversion

## Plot
Sys.setlocale(category = "LC_ALL", locale = "C") ## Set locale to English
with(hpcData, {
	plot(datetime, Sub_metering_1, type="l", col="black", xlab="", ylab="Energy sub metering")
	lines(datetime, Sub_metering_2, type="l", col="red")
	lines(datetime, Sub_metering_3, type="l", col="blue")
})
legend("topright", lty=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), cex=0.75)

## Output to PNG device
dev.copy(png, "./plot3.png", width=480, height=480)
dev.off()