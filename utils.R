util <- function() {
        dir <- "./data"
        dataseturl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
        datasetarchive <- file.path(dir, "data.zip")
        neifile <- file.path(dir, "summarySCC_PM25.rds")
        sccfile <- file.path(dir, "Source_Classification_Code.rds")
        
        
        # Datasets
        nei <- NULL
        scc <- NULL
        
        if (!dir.exists(dir)) {
                dir.create(dir)
        }
        
        loadData <- function() {
                if (!file.exists(datasetarchive)) {
                        download.file(dataseturl, datasetarchive)
                }
                
                if (file.exists(datasetarchive)) {
                        unzip(datasetarchive, exdir = dir)
                }
                
                if (file.exists(neifile)) {
                        nei <<- readRDS(neifile)
                }
                
                if (file.exists(sccfile)) {
                        scc <<- readRDS(sccfile)
                }
        }
        
        nei <- function() nei
        scc <- function() scc
        
        list(
                dir = dir, url = dataseturl, archive = datasetarchive,
                loadData = loadData,
                NEI = nei,
                SCC = scc
        )
}