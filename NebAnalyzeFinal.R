library(tidyverse)
library(ggplot2)
library(gganimate)
library(geomtextpath)
library(extrafont)
library(patchwork)
library(svglite)
# font_import()
loadfonts(device = "win")
windowsFonts("Century Gothic" = windowsFont("Century Gothic"))
library(scales)

rm(list = ls())
myFont = "Century Gothic"

files_list <- list.files(path="Data/Final/alarmmin80/FS", pattern="[0-9].csv$", full.names = TRUE)

Eth10 <- bind_rows(lapply(files_list[1:3], read_csv)) %>%
  mutate(eth = 10)

Eth25 <- read_csv(files_list[[4]]) %>% mutate(eth = 25)

Eth5 <- bind_rows(lapply(files_list[5:7], read_csv)) %>%
  mutate(eth = 5)

Eth0 <- bind_rows(lapply(files_list[8:10], read_csv)) %>%
  mutate(eth = 0)

EthAll <- bind_rows(Eth0, Eth5, Eth10, Eth25)

Eth0_AVGS <- data.frame(name = as.factor("Water"), eth=0, n=nrow(Eth0), 
                      VMD_Mean_MEDIAN = median(Eth0$vmd_median),
                      VMD_Mean_MEAN = mean(Eth0$vmd_mean),
                      VMD_Mean_STDEV = sd(Eth0$vmd_median),
                      FPF_Mean_MEAN = mean(Eth0$fpf_mean),
                      FPF_Mean_STDEV = sd(Eth0$fpf_mean),
                      RF_Mean_MEAN = mean(Eth0$rf_mean),
                      RF_Mean_STDEV = sd(Eth0$rf_mean),
                      eFPF_Mean_MEAN = mean(Eth0$efpf_mean),
                      eFPF_Mean_STDEV = sd(Eth0$efpf_mean)
                      )

Eth5_AVGS <- data.frame(name = as.factor("5% Ethanol"), eth=5, n=nrow(Eth5), 
                        VMD_Mean_MEDIAN = median(Eth5$vmd_median),
                        VMD_Mean_MEAN = mean(Eth5$vmd_mean),
                        VMD_Mean_STDEV = sd(Eth5$vmd_median),
                        FPF_Mean_MEAN = mean(Eth5$fpf_mean),
                        FPF_Mean_STDEV = sd(Eth5$fpf_mean),
                        RF_Mean_MEAN = mean(Eth5$rf_mean),
                        RF_Mean_STDEV = sd(Eth5$rf_mean),
                        eFPF_Mean_MEAN = mean(Eth5$efpf_mean),
                        eFPF_Mean_STDEV = sd(Eth5$efpf_mean)
                        )

Eth10_AVGS <- data.frame(name = as.factor("10% Ethanol"), eth=10, n=nrow(Eth10), 
                         VMD_Mean_MEDIAN = median(Eth10$vmd_median),
                         VMD_Mean_MEAN = mean(Eth10$vmd_mean),
                         VMD_Mean_STDEV = sd(Eth10$vmd_median),
                         FPF_Mean_MEAN = mean(Eth10$fpf_mean),
                         FPF_Mean_STDEV = sd(Eth10$fpf_mean),
                         RF_Mean_MEAN = mean(Eth10$rf_mean),
                         RF_Mean_STDEV = sd(Eth10$rf_mean),
                         eFPF_Mean_MEAN = mean(Eth10$efpf_mean),
                         eFPF_Mean_STDEV = sd(Eth10$efpf_mean))

Eth25_AVGS <- data.frame(name = as.factor("25% Ethanol") , eth=25, n=nrow(Eth25), 
                         VMD_Mean_MEDIAN = median(Eth25$vmd_median),
                         VMD_Mean_MEAN = mean(Eth25$vmd_mean),
                         VMD_Mean_STDEV = sd(Eth25$vmd_median),
                         FPF_Mean_MEAN = mean(Eth25$fpf_mean),
                         FPF_Mean_STDEV = sd(Eth25$fpf_mean),
                         RF_Mean_MEAN = mean(Eth25$rf_mean),
                         RF_Mean_STDEV = sd(Eth25$rf_mean),
                         eFPF_Mean_MEAN = mean(Eth25$efpf_mean),
                         eFPF_Mean_STDEV = sd(Eth25$efpf_mean))

EthTable <- EthAll[, 1:13]


EthOverview <- bind_rows(Eth0_AVGS, Eth5_AVGS, Eth10_AVGS, Eth25_AVGS)
XLab = "% Ethanol by Volume"

p1 <- ggplot(EthOverview, aes(x = eth, y=VMD_Mean_MEAN, colour = name)) + 
  geom_line() +
  geom_point() +
  theme_bw() +
  theme(text=element_text(family=myFont, size=12)) +
  geom_errorbar(aes(ymin=VMD_Mean_MEAN-VMD_Mean_STDEV, ymax=VMD_Mean_MEAN+VMD_Mean_STDEV)) +
  xlab(XLab) +
  ylab("Mean Experimental VMD") +
  ggtitle("Mean Experimental VMD vs Ethanol %")

p2 <- ggplot(EthOverview, aes(x = eth, y=FPF_Mean_MEAN, colour = name)) + 
  geom_line() +
  geom_point() +
  theme_bw() +
  theme(text=element_text(family=myFont, size=12)) +
  geom_errorbar(aes(ymin=FPF_Mean_MEAN-FPF_Mean_STDEV, ymax=FPF_Mean_MEAN+FPF_Mean_STDEV)) +
  xlab(XLab) +
  ylab("Mean Experimental FPF") +
  ggtitle("Mean Experimental FPF vs Ethanol %")

p3 <- ggplot(EthOverview, aes(x = eth, y=RF_Mean_MEAN, colour = name)) + 
  geom_line() +
  geom_point() +
  theme_bw() +
  theme(text=element_text(family=myFont, size=12)) +
  geom_errorbar(aes(ymin=RF_Mean_MEAN-RF_Mean_STDEV, ymax=RF_Mean_MEAN+RF_Mean_STDEV)) +
  xlab(XLab) +
  ylab("Mean Experimental RF") +
  ggtitle("Mean Experimental RF vs Ethanol %")

p4 <- ggplot(EthOverview, aes(x = eth, y=eFPF_Mean_MEAN, colour = name)) + 
  geom_line() +
  geom_point() +
  theme_bw() +
  theme(text=element_text(family=myFont, size=12)) +
  geom_errorbar(aes(ymin=eFPF_Mean_MEAN-eFPF_Mean_STDEV, ymax=eFPF_Mean_MEAN+eFPF_Mean_STDEV)) +
  xlab(XLab) +
  ylab("Mean Experimental eFPF") +
  ggtitle("Mean Experimental eFPF vs Ethanol %")
  

(p1 + p2 + p3 + p4) +
  plot_layout(guides = 'collect') +
  plot_annotation(caption = "Please note that the 25% Ethanol data is very sparse, only had one trial, and is the least accurate indicator. ") &
  theme(text=element_text(family=myFont))

write_csv(EthOverview, "finaloverview.csv")
write_csv(EthTable, "finaltable.csv")

# ggsave(paste0("Exports/Final/alarmmin80/","FinalResults",".svg"), width = 12, height = 5, units = "in")