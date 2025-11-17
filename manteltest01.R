library(dplyr)
library(linkET)
library(ggplot2)
library(vegan)

speciese_raw <- read.csv(file.choose(),header = T,row.names = NULL)
env_raw <- read.csv(file.choose(),header = T,row.names = NULL)
speciese <- as.data.frame(scale(speciese_raw))
env <- as.data.frame(scale(env_raw))

mantel01 <- mantel_test(speciese, env,
                        spec_dist =  dist_func(.FUN = "vegdist", method = "euclidean"),
                        # env_dist = dist_func(.FUN = "vegdist", method = "euclidean"),
                        spec_select = list(`Macroeconomy & Growth` = c(1,8,62,93  ),
                                           `Primary Industry` = c(2,5,21,24,27,58:59,63:71  ),
                                           `Secondary Industry` = c(3,6,22,25,28:31,72:73,76:77,81:89,80,146  ),
                                           `Service Industry` = c(4,7,23,26,32:53,94:95  ),
                                           `Population & Labor Force` = c(9:20,54:56,60  ),
                                           `Resources, Energy & Environment` = c(57,61,145,147,150:166  ),
                                           `Investment & Foreign Economy` = c(74:75, 78:79, 90:92,96:100 ),
                                           `Fiscal & Finance` = c(101:108,167 ),
                                           `Science, Technology & Education` = c(109:124 ),
                                           `Culture, Health, Sports & Social Security` = c(125:132,168:171 ),
                                           `Infrastructure, Transport & Communication` = c(133:144,148:149 )
                        )) %>%
  mutate(rd = cut(r, breaks = c(-Inf, 0.05, 0.1, Inf),
                  labels = c("< 0.05", "0.05 - 0.1", ">= 0.1")),
         pd = cut(p, breaks = c(-Inf, 0.15, 0.25, Inf),
                  labels = c("< 0.15", "0.15 - 0.3", ">= 0.3")))

qcorrplot(correlate(env),
          type = "lower",
          diag = FALSE,
) +
  geom_square() +
  geom_couple(aes(colour = pd, size = rd),data = mantel01, curvature = 0.1,
            node.colour = c("blue", "blue"),
            node.fill = c("grey", "grey"),
            node.size = c(3.5, 2.5),
) +
  scale_fill_gradientn(colours = RColorBrewer::brewer.pal(11, "RdBu"),
                     limits = c(-1, 1),
                     breaks = seq(-1,1,0.5)) +
  geom_mark(size=4.5,
          only_mark=T,
          sig_level=c(0.05, 0.01, 0.001),
          sig_thres=0.05)+
  scale_size_manual(values = c(0.5, 1, 1.5, 2)) +
  scale_colour_manual(values = color_pal(3)) +
  guides(size = guide_legend(title = "Mantel's r",
                           override.aes = list(colour = "grey35"),
                           order = 2),
       colour = guide_legend(title = "Mantel's P",
                             override.aes = list(size = 1.5),
                             order = 1),
       fill = guide_colorbar(title = "Pearson's r", order = 3)) +
  scale_x_discrete(expand = expansion(add = c(1, 5.15)))

  


ggsave("Mantel test DBP-adj.png", width = 11,height = 5,dpi = 300)
