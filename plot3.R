library("dplyr")
library("ggplot2")

wd <- getwd()
setwd(getSrcDirectory(function(x) {x})[1])

source("./utils.R")

u <- util()

if (!exists("nei")) {
        u$loadData()
        
        nei <- as_tibble(u$NEI())
        scc <- as_tibble(u$SCC())
}

BaltimoreEmissionsByYear <- nei[nei$fips == "24510",] %>% group_by(year, type) %>% summarise(Emissions = sum(Emissions))

plot <- ggplot(BaltimoreEmissionsByYear, aes(year, Emissions, color=factor(type))) +
        geom_point(pch = 4, size = 2 ) +
        facet_wrap(vars(type), nrow = 2) +
        geom_smooth(method = "lm", formula = y ~ x, fill = NA, lty=2, lwd=0.4, col = "grey") +
        labs(title = "Total emissions by type in Baltimore from 1999 to 2008") +
        xlab("Year") +
        theme(plot.title = element_text(hjust = 0.5)) +
        theme(legend.position = "none") +
        scale_color_discrete(name = "Type")
        
print(plot)

dev.copy(png, "plot3.png")
dev.off()

setwd(wd)