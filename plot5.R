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

motor_vehicles_sectors <- scc %>% 
        filter(grepl(pattern = "vehicle", ignore.case = TRUE, EI.Sector)) %>%
        select(SCC, EI.Sector)
        
#motor_vehicles_sectors <- scc %>%
#        .[grep(pattern = "vehicle", ignore.case = TRUE, scc$EI.Sector),] %>%
#        select(SCC) %>%
#        mutate(SCC = as.character(SCC))

BaltimoreMotorVehicleEmissionsEmissions <- nei %>%
        filter(nei$fips == "24510", SCC %in% motor_vehicles_sectors$SCC) %>%
        mutate(Sector = motor_vehicles_sectors$EI.Sector[match(SCC, motor_vehicles_sectors$SCC)]) %>%
        group_by(year, Sector) %>% summarise(Emissions = sum(Emissions))

plot <- ggplot(BaltimoreMotorVehicleEmissionsEmissions, aes(year, Emissions)) +
        geom_point(size = 2, aes(color=factor(Sector), shape=factor(Sector))) +
        geom_smooth(aes(group = BaltimoreMotorVehicleEmissionsEmissions$Sector, color=factor(BaltimoreMotorVehicleEmissionsEmissions$Sector)), 
                    method = "lm", formula = y ~ x, fill = NA, lty=2, lwd=0.4) +
        labs(title = "Emissions from motor vehicles related sources in the Baltimore City.") +
        xlab("Year") +
        scale_color_discrete(name = "Sector", labels = factor(BaltimoreMotorVehicleEmissionsEmissions$Sector)) +
        scale_shape_discrete(name = "Sector", labels = factor(BaltimoreMotorVehicleEmissionsEmissions$Sector)) +
        theme(plot.title = element_text(hjust = 0.5)) #+
        #theme(legend.position = "bottom")
        
        
print(plot)

dev.copy(png, "plot5.png")
dev.off()

setwd(wd)