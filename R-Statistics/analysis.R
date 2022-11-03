library(tidyverse)
library(car)
library(bestNormalize)
library(effsize)
library(moments)
library(EnvStats)
library(ggplot2)

# Load data files, separate blocks

df = read_csv("data/full_data.csv")

# Separate by block
df_360p =  df %>%
  filter(block == '360p')

df_adaptive = df %>%
  filter(block == 'Adaptive')


# Separate by version
df_360p_native = df_360p %>%
  filter(version == 'native')
df_adaptive_native = df_adaptive %>%
  filter(version == 'native')

df_360p_web = df_360p %>%
  filter(version == 'web')
df_adaptive_web = df_adaptive %>%
  filter(version == 'web')

# Factors



# Box plot for block 360p
ggplot(data=df_360p_native, aes(x=subject, y=batterystats_Joule_calculated)) + 
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y="Energy consumed in Joules", x="Subjects") +
  geom_boxplot(fill="cyan")+
  theme_minimal()+
  ylim(0, 4500)

ggplot(data=df_360p_web, aes(x=subject, y=batterystats_Joule_calculated)) + 
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y="Energy consumed in Joules", x="Subjects") +
  geom_boxplot(fill="cyan")+
  theme_minimal()+
  ylim(0, 4500)


# Box plot for block Adaptive
ggplot(data=df_adaptive_native, aes(x=subject, y=batterystats_Joule_calculated)) + 
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y="Energy consumed in Joules", x="Subjects") + 
  geom_boxplot(fill="red", alpha=0.5)+
  theme_minimal()+
  ylim(0, 4500)


ggplot(data=df_adaptive_web, aes(x=subject, y=batterystats_Joule_calculated)) + 
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(y="Energy consumed in Joules", x="Subjects") +
  geom_boxplot(fill="red", alpha=0.5)+
  theme_minimal()+
  ylim(0, 4500)


# Descriptive statistics

descriptive_stats <- function(df) {
  print(
   df %>% group_by(subject) %>%
      summarize(
        min = min(batterystats_Joule_calculated),
        max = max(batterystats_Joule_calculated),
        mean_cons = mean(batterystats_Joule_calculated),
        sd_cons = sd(batterystats_Joule_calculated),
        cv = sd(batterystats_Joule_calculated) / mean(batterystats_Joule_calculated) * 100,
        sk = skewness(batterystats_Joule_calculated),
        Q1 = quantile(batterystats_Joule_calculated, 0.25),
        Q2 = quantile(batterystats_Joule_calculated, 0.50),
        Q3 = quantile(batterystats_Joule_calculated, 0.75),
    )
  )
}
 
descriptive_stats(df_360p_native)
descriptive_stats(df_360p_web)

descriptive_stats(df_adaptive_native)
descriptive_stats(df_adaptive_web)


# Outlier detection boxplots

outiler_detection_boxplot <- function(df){
  print(
  df %>% group_by(subject) %>%
    summarise(boxplot=list( boxplot.stats(batterystats_Joule_calculated)$out ) )%>%
    unnest_wider(boxplot)
  )
}

# Outliers using Inter-Quartile Range (IQR) proximity rule

iqr <- function(df){
  return (df %>% group_by(subject) %>%
      summarize(
        Q1 = quantile(batterystats_Joule_calculated, 0.25),
        Q3 = quantile(batterystats_Joule_calculated, 0.75),
        IQR = Q3 - Q1,
        upper_limit = Q3 + 1.5 * IQR,
        lower_limit = Q1 - 1.5 * IQR
      ))
  
}

remove_outliers <-function(df){
  tmp_irq = iqr(df)
  for (val in 1:nrow(tmp_irq)){
    s = tmp_irq$subject[val]
    up = tmp_irq$upper_limit[val]
    low = tmp_irq$lower_limit[val]
    
    df = df[(df$batterystats_Joule_calculated < up & df$batterystats_Joule_calculated > low & df$subject==s) |  df$subject!=s, ]
  }
  return(df)
  
}

outiler_detection_boxplot(df_360p_native)
outiler_detection_boxplot(df_360p_native)
df_360p_native = remove_outliers(df_360p_native)
descriptive_stats(df_360p_native)

outiler_detection_boxplot(df_360p_web)
outiler_detection_boxplot(df_360p_web)
df_360p_web = remove_outliers(df_360p_web)
descriptive_stats(df_360p_web)

# Update full block data
df_360p <- rbind(df_360p_native, df_360p_web)

outiler_detection_boxplot(df_adaptive_native)
outiler_detection_boxplot(df_adaptive_native)
df_adaptive_native = remove_outliers(df_adaptive_native)
descriptive_stats(df_adaptive_native)

outiler_detection_boxplot(df_adaptive_web)
outiler_detection_boxplot(df_adaptive_web)
df_adaptive_web = remove_outliers(df_adaptive_web)
descriptive_stats(df_adaptive_web)

# Update full block data
df_adaptive <- rbind(df_adaptive_native, df_adaptive_web)

# Compute means

# Check normality of runs
df_360p_means = df_360p %>%
  group_by(subject, version) %>%
  summarize(
    batterystats_Joule_calculated = mean(batterystats_Joule_calculated,
                 version = version,
    ))

df_adaptive_means = df_adaptive %>%
  group_by(subject, version) %>%
  summarize(
    batterystats_Joule_calculated = mean(batterystats_Joule_calculated,
    version = version,
  ))

# Descriptive statistics
descriptive_stats_version <- function(df) {
  print(
    df %>% group_by(version) %>%
      summarize(
        min = min(batterystats_Joule_calculated),
        max = max(batterystats_Joule_calculated),
        mean_cons = mean(batterystats_Joule_calculated),
        sd_cons = sd(batterystats_Joule_calculated),
        cv = sd(batterystats_Joule_calculated) / mean(batterystats_Joule_calculated) * 100,
        sk = skewness(batterystats_Joule_calculated),
        Q1 = quantile(batterystats_Joule_calculated, 0.25),
        Q2 = quantile(batterystats_Joule_calculated, 0.50),
        Q3 = quantile(batterystats_Joule_calculated, 0.75),
      )
  )
}
descriptive_stats_version(df_360p_means)
descriptive_stats_version(df_adaptive_means)


check_normality <- function(data) {
  par(mfrow=c(1,2))
  plot(density(data))
  car::qqPlot(data)
  print(shapiro.test(data))
  par(mfrow=c(1,1))
}

df_360p_means = df_360p_means %>% 
  mutate_at(c('version'), as.factor)

df_adaptive_means = df_adaptive_means %>% 
  mutate_at(c('version'), as.factor)

check_normality(df_360p_means$batterystats_Joule_calculated[df_360p_means$version=='native'])
check_normality(df_360p_means$batterystats_Joule_calculated[df_360p_means$version=='web'])

check_normality(df_adaptive_means$batterystats_Joule_calculated[df_adaptive_means$version=='native'])
check_normality(df_adaptive_means$batterystats_Joule_calculated[df_adaptive_means$version=='web'])

# Histograms of means
library(tidyverse)
bp_360p <- ggplot(df_360p_means, aes(x=version, y=batterystats_Joule_calculated, fill=version))+
  xlab("Version") + ylab("Energy consumed in Joules") +
  ylim(c(0, 5000)) +
  geom_violin(trim=TRUE, alpha=0.5) +
  geom_boxplot(fill='white', width=.2, outlier.size=.5) +
  geom_jitter(width=0.2) +
  stat_summary(fun=mean, color='black', geom='point', shape=5, size=1.5)+
  theme(legend.position='none')
bp_360p
ggsave("boxplot_360p.png", width=20, height=16, units=c("cm"), dpi=300)

bp_adaptive <- ggplot(df_adaptive_means, aes(x=version, y=batterystats_Joule_calculated, fill=version))+
  xlab("Version") + ylab("Energy consumed in Joules") +
  ylim(c(0, 5000)) +
  geom_violin(trim=TRUE, alpha=0.5) +
  geom_boxplot(fill='white', width=.2, outlier.size=.5) +
  geom_jitter(width=0.2) +
  stat_summary(fun=mean, color='black', geom='point', shape=5, size=1.5)+
  theme(legend.position='none')
bp_adaptive

ggsave("boxplot_adaptive.png", width=20, height=16, units=c("cm"), dpi=300)

boxplot(batterystats_Joule_calculated~version, df_360p_means, ylim = c(0,4000))
boxplot(batterystats_Joule_calculated~version, df_adaptive_means, ylim = c(0,4000))

# Statistical test

distance <-function(df1, df2){
  d=c()
  for (val in 1:nrow(df1)){
    s1 = df1$subject[val]
    x = df1$batterystats_Joule_calculated[val]
    s2 = df2$subject[val]
    y = df2$batterystats_Joule_calculated[val]
    assertthat::are_equal(s1,s2)
    d=append(d,x-y)
  }
  return(d)
}

# MAny ways to perform the same statistical test
distance_vect_360p = distance(df_360p_means[df_360p_means$version=='native',], df_360p_means[df_360p_means$version=='web',] )
distance_vect_adaptive = distance(df_adaptive_means[df_adaptive_means$version=='native',], df_adaptive_means[df_adaptive_means$version=='web',] )

wilcox.test(x=distance_vect_360p, alternative="two.sided", mu=0)
wilcox.test(x=distance_vect_adaptive, alternative="two.sided", mu=0)

wilcox.test(batterystats_Joule_calculated~version, data=df_360p_means, mu=0, paired=TRUE)
wilcox.test(batterystats_Joule_calculated~version, data=df_adaptive_means,mu=0, paired=TRUE)

wilcox.test(df_360p_means$batterystats_Joule_calculated[df_360p_means$version=='native'], df_360p_means$batterystats_Joule_calculated[df_360p_means$version=='web'], paired=TRUE)
wilcox.test(df_adaptive_means$batterystats_Joule_calculated[df_adaptive_means$version=='native'], df_adaptive_means$batterystats_Joule_calculated[df_adaptive_means$version=='web'], paired=TRUE)
