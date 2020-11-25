library(dplyr)

wd <- getwd()
setwd(getSrcDirectory(function(x) {x})[1])

source("./utils.R")

u <- util()

if (!exists("nei")) {
        u$loadData()
        
        nei <- as_tibble(u$NEI())
        scc <- as_tibble(u$SCC())
}

BaltimoreEmissionsByYear <- nei[nei$fips == "24510",] %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

with(BaltimoreEmissionsByYear, {
        plot(year, Emissions, type = "n", xlab = "")
        points(year, Emissions, col="blue", pch=4)
        lines(year, Emissions, lty=2, col="grey")
        title(main="Total emissions in Baltimore City from 1999 to 2008", xlab="Year")
})

dev.copy(png, "plot2.png")
dev.off()

setwd(wd)