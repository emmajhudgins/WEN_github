# Packages ----------------------------------------------------------------

install.packages('remotes') # for installing packages from sources that aren't CRAN
library(remotes) # load the package

install_github("allisonhorst/palmerpenguins") #installing development version of dataset
library(palmerpenguins) # loading the package which contains dataset we will use


install.packages('tidyverse')
library(tidyverse) # loading tidyverse package for ggplot etc.

# Session Info ------------------------------------------------------------

sessionInfo() # good practice to copy and paste this after loading all packages
#so that other users know the soft/hardware you are working with
# can put this in your script or put it in the readme



#R version 4.1.2 (2021-11-01)
#Platform: x86_64-w64-mingw32/x64 (64-bit)
#Running under: Windows 10 x64 (build 22000)
#
#Matrix products: default
#
#locale:
#[1] LC_COLLATE=English_Canada.1252  LC_CTYPE=English_Canada.1252    LC_MONETARY=English_Canada.1252
#[4] LC_NUMERIC=C                    LC_TIME=English_Canada.1252    
#system code page: 65001

#attached base packages:
#[1] stats     graphics  grDevices utils     datasets  methods   base     

#other attached packages:
#[1] forcats_0.5.1        stringr_1.4.0        dplyr_1.0.8          purrr_0.3.4         
#[5] readr_2.1.2          tidyr_1.2.0          tibble_3.1.6         ggplot2_3.3.5       
#[9] tidyverse_1.3.1      palmerpenguins_0.1.0 remotes_2.4.2       

#loaded via a namespace (and not attached):
#[1] Rcpp_1.0.8       cellranger_1.1.0 pillar_1.7.0     compiler_4.1.2   dbplyr_2.1.1    
#[6] tools_4.1.2      lubridate_1.8.0  jsonlite_1.7.3   lifecycle_1.0.1  gtable_0.3.0    
#[11] pkgconfig_2.0.3  rlang_1.0.1      reprex_2.0.1     rstudioapi_0.13  cli_3.2.0       
#[16] DBI_1.1.2        curl_4.3.2       haven_2.4.3      xml2_1.3.3       withr_2.4.3     
#[21] httr_1.4.2       fs_1.5.2         generics_0.1.2   vctrs_0.3.8      hms_1.1.1       
#[26] grid_4.1.2       tidyselect_1.1.1 glue_1.6.1       R6_2.5.1         fansi_1.0.2     
#[31] readxl_1.3.1     tzdb_0.2.0       modelr_0.1.8     magrittr_2.0.2   backports_1.4.1 
#[36] scales_1.1.1     ellipsis_0.3.2   rvest_1.0.2      assertthat_0.2.1 colorspace_2.0-2
#[41] utf8_1.2.2       stringi_1.7.6    munsell_0.5.0    broom_0.7.12     crayon_1.5.0    


# Create data ---------------------------------------------------------------

data(penguins, package = "palmerpenguins")

write.csv(penguins_raw, "Raw data/penguins_raw.csv", row.names = FALSE)

write.csv(penguins,"Data/penguins.csv",row.names = FALSE)


# Load data ---------------------------------------------------------------

pen.data <- read.csv("Data/penguins.csv")

str(pen.data) # look at data types (e.g., factor, character)
colnames(pen.data) # look at the column names

# check for bullshit
head(pen.data) # first few rows of the start of the data
tail(pen.data) # last few rows at the end


pairs(pen.data[,c(3:6,8)]) # pairwise correlation plot of numeric columns
# [row, column] and we want columns 3:6 and 8 which are the numeric variables
?pairs # will give you information about the function


hist(pen.data$body_mass_g)  # make a histogram    
?hist


boxplot(pen.data$body_mass_g ~ pen.data$species) # boxplot of body mass x species
?boxplot


# Save boxplot as pdf in base R -------------------------------------------

pdf("Output/wt_by_spp.pdf",
    width = 7,
    height = 5) # open a graphics device (everything you print to the screen while this is open will be saved to the file name that you give here), there are analogous functions for png and other image types


boxplot(pen.data$body_mass_g ~ pen.data$species,
        xlab="Species", ylab="Body Mass (g)") # print the boxplot to the pdf file


dev.off() #close the graphics device (very important to run this line or the pdf won’t save and will continue to add new plots that you run afterwards)



# ggplot figure --------------------------------------------------------

pen_fig <- pen.data %>% # calling on the data
  drop_na() %>%  # dropping "NAs" from the plot
  ggplot(aes(y = body_mass_g, x = sex, # aesthetic: y = body mass, x = sex
             colour = sex)) + # colour violin plots by sex
  facet_wrap(~species) + # each species will have it's own plot
  geom_violin(trim = FALSE, # violin plot, turn off trim the edges
              lwd = 1) + # make the lines thick
  theme_bw() + # black and white background theme
  theme(text = element_text(size = 12), # change the text size
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        strip.text = element_text(size=12),
        legend.position = "none") + # remove the legend
  labs(y = "Body Mass (g)", # specify labels on axes
       x = " ") +
  scale_colour_manual(values = c("black", "darkgrey"))

pen_fig


ggsave("Output/pen_fig.jpeg", pen_fig, # save figure to output
       width = 7,
       height = 5)



