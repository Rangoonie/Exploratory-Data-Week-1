## Read the data using read.table()
power_data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?", colClasses = c("character", "character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))

## Format the date to type Date
power_data$Date <- as.Date(power_data$Date, "%d/%m/%Y")

## Extract only the data from "2007-02-01" to "2007-02-02" and exclude NA values
power_data <- subset(power_data, Date >= as.Date("2007-02-01") & Date <= as.Date("2007-02-02"))
power_data <- power_data[complete.cases(power_data), ]

## Merge the Date and Time variables as a new date_time variable and format it as type POSIXct
date_time <- paste(power_data$Date, power_data$Time)
date_time <- setNames(date_time, "Date_Time")
power_data <- power_data[, !(names(power_data) %in% c("Date", "Time"))]
power_data <- cbind(date_time, power_data)
power_data$date_time <- as.POSIXct(date_time)

par(mfrow = c(2,2))
with(power_data, {
    plot(x = power_data$date_time, y = power_data$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power")
    plot(x = power_data$date_time, y = power_data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")
    plot(power_data$date_time, power_data$Sub_metering_1, col = "black", type = "l", xlab = "", ylab = "Energy sub metering")
    lines(x = power_data$date_time, y = power_data$Sub_metering_2, col = "red", type = "l")
    lines(x = power_data$date_time, y = power_data$Sub_metering_3, col = "blue", type = "l")
    legend(x = "topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd = c(1,1,1), col = c("black", "red", "blue"), bty = "n")
    plot(x = power_data$date_time, y = power_data$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")
})
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()