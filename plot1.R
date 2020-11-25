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

emissionsByYear <- nei %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

with(emissionsByYear, {
        plot(year, Emissions, type = "n", xlab = "")
        points(year, Emissions, col="blue", pch=4)
        lines(year, Emissions, lty=2, col="grey")
        title(main="Total emissions by year", xlab="Year")
        model <- line(year, Emissions)
        #model <- lm(Emissions ~ year)
        abline(model, lm, col="red", lty=3)
})

dev.copy(png, "plot1.png")
dev.off()

setwd(wd)