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

coal_combustion_sectors <- scc %>% 
        filter(grepl(pattern = "coal", ignore.case = TRUE, EI.Sector)) %>%
        select(SCC, EI.Sector)
        
#coal_combustion_sectors <- scc %>%
#        .[grep(pattern = "coal", ignore.case = TRUE, scc$EI.Sector),] %>%
#        select(SCC) %>%
#        mutate(SCC = as.character(SCC))

CoalCombustionEmissions <- nei %>%
        filter(SCC %in% coal_combustion_sectors$SCC) %>%
        mutate(Sector = coal_combustion_sectors$EI.Sector[match(SCC, coal_combustion_sectors$SCC)]) %>%
        group_by(year, Sector) %>% summarise(Emissions = sum(Emissions))

plot <- ggplot(CoalCombustionEmissions, aes(year, Emissions)) +
        geom_point(size = 2, aes(color=factor(Sector), shape=factor(Sector))) +
        geom_smooth(aes(group = CoalCombustionEmissions$Sector, color=factor(CoalCombustionEmissions$Sector)), 
                    method = "lm", formula = y ~ x, fill = NA, lty=2, lwd=0.4) +
        labs(title = "Emissions from coal combustion related sources in the USA.") +
        xlab("Year") +
        scale_color_discrete(name = "Sector", labels = factor(CoalCombustionEmissions$Sector)) +
        scale_shape_discrete(name = "Sector", labels = factor(CoalCombustionEmissions$Sector)) +
        theme(plot.title = element_text(hjust = 0.5)) #+
        #theme(legend.position = "bottom")
        
        
print(plot)

dev.copy(png, "plot4.png")
dev.off()

setwd(wd)