Sys.setlocale("LC_ALL","russian")
library(lubridate)
library(ggplot2)
library(dplyr)
library(ggplot2)
setwd('d:/YandexDisk/ИВПРАН/R forecasts/error_test')
df <- read.csv('error_sandbox/qdata.csv', 
               colClasses = c('integer', 'Date', 'numeric'), 
               col.names = c('index', 'date', 'q_fact'))

q <- df %>%
  filter(year(date) == 2009)

ggplot(q, aes(x=date, y=q_fact)) + geom_line() + 
  labs(x='', y=expression('Расход воды, м'^3*'/с')) + 
  theme_light(base_size = 16) + scale_x_date(date_breaks = '1 month', date_labels = '%b')

error1 <- rnorm(n = nrow(q), mean = 0, sd = 1)

q$q_mod1 <- q$q_fact + error1

ggplot(q, aes(x=date)) + 
  geom_line(aes(y=q_fact, col='Факт')) + 
  geom_line(aes(y=q_mod1, col='Модель 1')) + 
  labs(x='', y=expression('Расход воды, м'^3*'/с')) + 
  theme_light(base_size = 16) + scale_x_date(date_breaks = '1 month', date_labels = '%b')

ggplot(q, aes(x=q_fact, y=q_mod1)) + geom_point() + 
  geom_abline() +
  geom_smooth(method = 'lm', se = F) + 
  xlim(0, 60) + ylim(0,60) + theme_light(base_size = 16)

error2 <- rnorm(n = nrow(q), mean = 10, sd = 1)
q$q_mod2 <- q$q_fact + error2

ggplot(q, aes(x=q_fact)) + 
  geom_point(aes(y=q_mod1, col='Модель 1')) + 
  geom_point(aes(y=q_mod2, col='Модель 2')) + 
  geom_abline() + 
  geom_smooth(aes(x=q_fact, y=q_mod1), method = 'lm', formula = y ~ x,  se = F) + 
  geom_smooth(aes(x=q_fact, y=q_mod2), method = 'lm', formula = y ~ x,  se = F) + 
  xlim(0, 60) + ylim(0,60) + theme_light(base_size = 16)

error3 <- rnorm(n = nrow(q), mean = -10, sd = 1)
q$q_mod3 <- q$q_fact + error3

ggplot(q, aes(x=q_fact)) + 
  geom_point(aes(y=q_mod1, col='Модель 1')) + 
  geom_point(aes(y=q_mod2, col='Модель 2')) + 
  geom_point(aes(y=q_mod3, col='Модель 3')) + 
  geom_abline() + 
  geom_smooth(aes(x=q_fact, y=q_mod1), method = 'lm', formula = y ~ x,  se = F) + 
  geom_smooth(aes(x=q_fact, y=q_mod2), method = 'lm', formula = y ~ x,  se = F) + 
  geom_smooth(aes(x=q_fact, y=q_mod3), method = 'lm', formula = y ~ x,  se = F) + 
  xlim(-10, 50) + ylim(-10,50) + theme_light(base_size = 16)

cor(q[,-c(1,2)])

library(hydroGOF)
rmse(obs = q$q_fact, sim = q$q_mod1)
rmse(obs = q$q_fact, sim = q$q_mod2)
rmse(obs = q$q_fact, sim = q$q_mod3)

NSE(obs = q$q_fact, sim = q$q_mod1)
NSE(obs = q$q_fact, sim = q$q_mod2)
NSE(obs = q$q_fact, sim = q$q_mod3)

ggplot(q, aes(x=date, y=q_fact, col='Факт')) + 
  geom_line(aes(y=q_mod1, col='Модель 1')) + 
  geom_line(aes(y=q_mod2, col='Модель 2')) + 
  geom_line(aes(y=q_mod3, col='Модель 3')) + 
  theme_light(base_size = 16)
